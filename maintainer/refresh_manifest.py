"""Refresh source-only checksums. Never package original game files or APKs."""
import hashlib
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
EXCLUDE={'tools','output','.git','__pycache__','_compile'}
META={'manifest.json','README.md','README.en.md','VALIDATION.md','audit-result.json'}
def refresh():
    manifest=json.loads((ROOT/'manifest.json').read_text('utf-8-sig'))
    files=[]
    for path in sorted(ROOT.rglob('*')):
        rel=path.relative_to(ROOT)
        if not path.is_file() or set(rel.parts)&EXCLUDE or path.name in META:
            continue
        if path.suffix.lower() in {'.apk','.exe','.dll','.win','.droid','.dat','.zip','.7z','.keystore','.jks','.pyc'}:
            raise ValueError('Unexpected binary/private build artifact: '+str(rel))
        files.append({'path':rel.as_posix(),'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
    manifest['version']='2.01.04-multilingual-r7'
    manifest['files']=files
    (ROOT/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
    print('Source-only manifest:',len(files),'files')
if __name__=='__main__':
    refresh()
