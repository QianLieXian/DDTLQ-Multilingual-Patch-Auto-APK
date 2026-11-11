"""Validate reviewed AI JSON and compile installer assets. Python 3, stdlib only.

Usage: python compile_locale.py LOCALE --fonts12 DIR --fonts10 DIR
No translation service is called. Missing or unreviewed strings fail closed.
"""
import argparse
import collections
import hashlib
import json
import re
import shutil
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LITERAL = re.compile(r'"(?:[^"\\]|\\.)*"')
# Ordinary prose such as "100% in my work" is not a printf placeholder.
# Preserve literal percent signs too, without consuming the following word.
TOKENS = re.compile(r'%(?:\d+\$)?[-+0#]*\d*(?:\.\d+)?[sdif](?![A-Za-z])|%|\{[A-Za-z_][A-Za-z_0-9]*\}|<3|\\[nrt]')

def load(path):
    return json.loads(path.read_text('utf-8-sig'))

def dump(path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, ensure_ascii=False, separators=(',', ':')) + '\n', encoding='utf8')

def indexed(rows, expected, label):
    result = {}
    for row in rows:
        ident, text = row['id'], row['text']
        if ident in result:
            raise ValueError(f'{label}: duplicate ID {ident}')
        if not isinstance(text, str) or not text.strip():
            raise ValueError(f'{label}: empty/non-string text {ident}')
        if unicodedata.normalize('NFC', text) != text:
            raise ValueError(f'{label}: text must use NFC Unicode at {ident}')
        result[ident] = text
    if result.keys() != expected.keys():
        raise ValueError(f'{label}: missing={sorted(expected.keys()-result.keys(),key=str)}, '
                         f'extra={sorted(result.keys()-expected.keys(),key=str)}')
    return result

def glyphs(folder, size, variant, wanted, fallback12=None):
    result = {}
    for fallback in [variant, 'latin', 'zh_hans', 'ja', 'ko']:
        path = folder / f'fusion-pixel-{size}px-monospaced-{fallback}.bdf'
        if not path.exists():
            continue
        for block in path.read_text('utf8').split('STARTCHAR ')[1:]:
            cp = int(re.search(r'ENCODING (\d+)', block)[1])
            if cp not in wanted or cp in result:
                continue
            bw, bh, bx, by = map(int, re.search(r'BBX (\d+) (\d+) (-?\d+) (-?\d+)', block).groups())
            result[cp] = {'cp': cp, 'width': bw, 'height': bh, 'xoff': bx, 'yoff': by,
                'advance': int(re.search(r'DWIDTH (\d+)', block)[1]),
                'bits': block.split('BITMAP\n', 1)[1].split('ENDCHAR', 1)[0].strip().splitlines()}
    missing = wanted - result.keys()
    if size == 10 and variant == 'cyrillic' and fallback12 is not None:
        # The 10px Fusion face lacks Cyrillic. Its 12px face contains compact
        # 5px-wide Cyrillic bitmaps which fit the existing small UI atlas intact.
        # Move these up one pixel to compensate for the non-ASCII baseline shift
        # in patch-font.csx; preserve every bitmap row, including Ё and descenders.
        cyrillic = {cp for cp in missing if 0x0400 <= cp <= 0x052F}
        for row in glyphs(fallback12, 12, 'latin', cyrillic):
            row = {**row, 'yoff': row['yoff'] + 1}
            for index, bits in enumerate(row['bits']):
                if int(bits, 16) and not 0 <= 11-row['yoff']-row['height']+index < 12:
                    raise ValueError(f'Cyrillic UI fallback exceeds atlas cell: {row["cp"]}')
            result[row['cp']] = row
        missing = wanted - result.keys()
    if missing:
        raise ValueError(f'{size}px missing glyphs: ' + repr(''.join(map(chr, sorted(missing)))))
    return [result[cp] for cp in sorted(result)]

def replace_literals(text, mapping):
    def replace(match):
        raw = match.group()
        try:
            value = json.loads(raw)
        except json.JSONDecodeError:
            return raw
        return json.dumps(mapping[value], ensure_ascii=False) if value in mapping else raw
    return LITERAL.sub(replace, text)

def compile_locale(locale, fonts12, fonts10):
    source = load(ROOT / 'translation-source.json')
    core = {row['id']: row for row in source['core']}
    ui = {row['id']: row for row in source['ui']}
    directory = ROOT / 'locales' / locale
    translated = load(directory / 'translations.json')
    translated_ui = load(directory / 'ui.json')
    if translated['locale'] != locale or translated_ui['locale'] != locale:
        raise ValueError('Locale metadata does not match directory')
    if translated.get('needs_review') or translated_ui.get('needs_review'):
        raise ValueError('Unresolved review items remain')
    texts = indexed(translated['translations'], core, 'core')
    ui_texts = indexed(translated_ui['translations'], ui, 'UI')
    unchanged = []
    allowed = translated.get('allowed_unchanged', {})
    for ident, text in texts.items():
        original = core[ident]['en']
        if ident in [1988, 4007] and text != original:
            raise ValueError(f'ID {ident} is an internal wrapping-width sentinel and must preserve the source')
        if ident in [6185, 6186]:
            if text.count('*') != 1 or (ident == 6185 and not text.endswith(' ')) or (ident == 6186 and not text.startswith(' ')):
                raise ValueError(f'Dynamic currency fragment boundary mismatch at {ident}')
        if locale not in ['zh-CN', 'en']:
            if collections.Counter(TOKENS.findall(original)) != collections.Counter(TOKENS.findall(text)):
                raise ValueError(f'Placeholder mismatch at {ident}')
            if original.count('\n') != text.count('\n') or original.count('#') != text.count('#'):
                raise ValueError(f'Linebreak token mismatch at {ident}')
            if text == original:
                unchanged.append(ident)
                if not str(allowed.get(str(ident), '')).strip():
                    raise ValueError(f'Unchanged source needs an explicit review reason: {ident}')
        elif locale == 'en' and text != original:
            raise ValueError(f'English must preserve original source at {ident}')
    if locale not in ['zh-CN', 'en']:
        provenance = load(directory / 'provenance.json')
        if (provenance.get('model') != 'GPT-6' or provenance.get('effort') != 'High'
                or provenance.get('mode') != 'Chat' or not provenance.get('chat_urls')
                or provenance.get('reviewed') is not True):
            raise ValueError('A reviewed GPT-6 High Chat provenance record is required')
    # Work in a temporary directory so failures never expose a half-built language.
    temp = directory / '_compile'
    if temp.exists():
        raise ValueError(f'Remove or inspect previous staging directory first: {temp}')
    shutil.copytree(ROOT / 'payload', temp / 'payload')
    shutil.copytree(ROOT / 'android', temp / 'android')
    legacy_rows = load(ROOT / 'payload/translations.json')
    for row in legacy_rows:
        row['zh'] = texts.get(row['id'], row['source'])
    dump(temp / 'payload/translations.json', legacy_rows)
    mapping = {ui[ident]['source_zh']: text.replace('r5','r6') if ident in ['ui:037','ui:040'] else text
               for ident, text in ui_texts.items()}
    for path in list((temp / 'payload/feature-gml').glob('*.gml')) + list((temp / 'android').glob('*.smali')) + list((temp / 'android').glob('*.json')):
        if path.name == 'gml_Script_zh_display.gml':
            continue
        path.write_text(replace_literals(path.read_text('utf-8-sig'), mapping), encoding='utf8')
    display = ['var s=string(argument0);', 'if(!variable_global_exists("zh_display_map"))global.zh_display_map=-1;', 'if(!ds_exists(global.zh_display_map,ds_type_map)){', ' global.zh_display_map=ds_map_create();', ' var m=global.zh_display_map;']
    seen = {}
    for row in legacy_rows:
        original, target = row['source'], row['zh']
        if original == target:
            continue
        if original in seen and seen[original] != target:
            raise ValueError(f'Conflicting rendering translation: {original}')
        if original not in seen:
            display.append(f' ds_map_add(m,{json.dumps(original,ensure_ascii=False)},{json.dumps(target,ensure_ascii=False)});')
        seen[original] = target
    display += ['}', 'if(ds_map_exists(global.zh_display_map,s))return ds_map_find_value(global.zh_display_map,s);', 'return s;']
    if not seen:
        display = ['return string(argument0);']
    (temp / 'payload/feature-gml/gml_Script_zh_display.gml').write_text('\n'.join(display)+'\n', encoding='utf8')
    chars = {ord(c) for text in list(texts.values()) + list(ui_texts.values()) for c in text if c not in '\n\r\t'}
    if any(cp > 65535 for cp in chars):
        raise ValueError('The GameMaker font format cannot represent non-BMP characters')
    variant = {'zh-CN': 'zh_hans', 'ja': 'ja', 'ko': 'ko', 'ru': 'cyrillic'}.get(locale, 'latin')
    big = glyphs(fonts12, 12, variant, {cp for cp in chars if cp > 126})
    small = glyphs(fonts10, 10, variant, chars | set(range(32, 127)), fallback12=fonts12)
    advances={row['cp']:row['advance'] for row in small}
    def text_width(value):
        return max(sum(advances.get(ord(c),0) for c in line) for line in value.split('\n'))
    # Keep new helper translations on the verified single-line path. The English
    # header has a separately verified two-line layout.
    constraints={'ui:002':568 if locale=='en' else 284,'ui:020':344}
    constraints.update({f'ui:{n:03}':279 for n in range(3,10)})
    constraints.update({f'ui:{n:03}':378 for n in range(21,37)})
    for ident,maximum in constraints.items():
        if text_width(ui_texts[ident])>maximum:
            raise ValueError(f'{ident} needs a shorter contextual translation: width {text_width(ui_texts[ident])}>{maximum}')
    if len(ui_texts['ui:001'])>6:
        raise ValueError('ui:001 helper button label must be at most 6 characters')
    big_advances={row['cp']:row['advance'] for row in big}
    if sum(big_advances.get(ord(c),6) for c in ui_texts['ui:001'])>38:
        raise ValueError('ui:001 needs a shorter button label to fit the desktop/Android helper button')
    if any(len(ui_texts[f'ui:{n:03}'])>8 for n in range(48,51)):
        raise ValueError('Android Confirm/Back/Pause labels must be at most 8 characters')
    dump(temp / 'payload/cjk-glyphs.json', big)
    dump(temp / 'payload/ui10-glyphs.json', small)
    for name in ['payload', 'android']:
        final = directory / name
        if final.exists():
            raise ValueError(f'Refusing to overwrite previously compiled assets: {final}')
    for name in ['payload', 'android']:
        (temp / name).rename(directory / name)
    temp.rmdir()
    dump(directory / 'validation.json', {'locale': locale, 'core_count': len(texts), 'ui_count': len(ui_texts),
         'unchanged_core_ids': unchanged, 'glyphs12': len(big), 'glyphs10': len(small),
         'core_sha256': hashlib.sha256((directory/'translations.json').read_bytes()).hexdigest(),
         'status': 'compiled-awaiting-runtime-validation'})
    print(f'{locale}: {len(texts)} core, {len(ui_texts)} UI, glyphs={len(big)}/{len(small)}')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('locale')
    parser.add_argument('--fonts12', type=Path, required=True)
    parser.add_argument('--fonts10', type=Path, required=True)
    args = parser.parse_args()
    if args.locale not in {r['locale'] for r in load(ROOT/'languages.json')['languages']}:
        parser.error('Unknown locale')
    compile_locale(args.locale, args.fonts12, args.fonts10)
