"""Merge GPT-produced JSON by actual IDs and report gaps, never by claimed counts.

python merge_batches.py LOCALE OUTPUT INPUT.json [INPUT.json ...]
The result is a progress file, not an installable language pack.
"""
import argparse
import collections
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
def load(path):return json.loads(path.read_text('utf-8-sig'))
def ranges(numbers):
    result=[]
    for number in sorted(numbers):
        if result and number==result[-1][1]+1:result[-1][1]=number
        else:result.append([number,number])
    return result
def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('locale')
    parser.add_argument('output',type=Path)
    parser.add_argument('inputs',type=Path,nargs='+')
    args=parser.parse_args()
    source=load(ROOT/'translation-source.json')
    expected={r['id']:r for r in source['core']}
    expected_ui={r['id']:r for r in source['ui']}
    core,ui,reviews,invalid={}, {}, [], []
    for path in args.inputs:
        batch=load(path)
        if batch['locale']!=args.locale:raise ValueError('Wrong locale: '+str(path))
        for key,target,allowed in [('translations',core,expected),('ui_translations',ui,expected_ui)]:
            seen=set()
            for row in batch.get(key,[]):
                ident,text=row['id'],row['text']
                if ident in seen:raise ValueError(f'Duplicate {ident} in {path}')
                seen.add(ident)
                if ident not in allowed:raise ValueError(f'Unexpected ID {ident} in {path}')
                if not isinstance(text,str) or not text.strip():
                    invalid.append({'input':path.name,'id':ident,'reason':'empty/non-string text'})
                    continue
                if ident in target and target[ident]!=text:raise ValueError(f'Conflicting translations for {ident}; review required')
                target[ident]=text
        for row in batch.get('needs_review',[]):
            reviews.append({'input':path.name,**row} if isinstance(row,dict) else {'input':path.name,'note':row})
    completed=[n for n,row in enumerate(source['core'],1) if row['id'] in core]
    missing=[n for n,row in enumerate(source['core'],1) if row['id'] not in core]
    unchanged=[ident for ident,text in core.items() if text==expected[ident]['en']]
    result={'locale':args.locale,'status':'partial-not-installable' if missing or len(ui)!=len(expected_ui) else 'awaiting-review',
        'translations':[{'id':r['id'],'text':core[r['id']]} for r in source['core'] if r['id'] in core],
        'ui_translations':[{'id':r['id'],'text':ui[r['id']]} for r in source['ui'] if r['id'] in ui],
        'needs_review':reviews,'actual_core_count':len(core),'actual_ui_count':len(ui),
        'invalid_records':invalid,'missing_ui_ids':list(expected_ui.keys()-ui.keys()),
        'completed_input_ranges':ranges(completed),'missing_input_ranges':ranges(missing),
        'source_equal_ids_requiring_review':unchanged,
        'input_files':[str(p) for p in args.inputs]}
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
    print(json.dumps({k:result[k] for k in ['status','actual_core_count','actual_ui_count','completed_input_ranges','missing_input_ranges']},ensure_ascii=False))
if __name__=='__main__':main()
