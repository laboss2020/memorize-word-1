"""词库释义/例句翻译增补：seed_v1.sqlite → seed_v2.sqlite

功能：
1. 日语词补中文释义（jamdict-cn，SenseGloss.lang='chn'）
2. 英语词补日文释义（EJDict 公有领域，en→ja）
3. 例句翻译升级为多语言：旧 {"text","translation"} → {"text","translations":[{lang,text}]}
   并通过 Tatoeba（sentences.csv + links.csv）为日语例句补 cmn 翻译、英语例句补 cmn/jpn 翻译
4. meta.seed_version → '2'

用法：
  python tool/pipeline/augment_glosses.py --datasets <dir> [--seed assets/db/seed_v1.sqlite]

数据集目录（--datasets）需包含：
  jamdict_cn_deduplicated.db / ejdict/ejdict.json / sentences.csv / links.csv

许可：JMdict 数据 CC-BY-SA-4.0（jamdict-cn 同）；EJDict 公有领域；
Tatoeba 例句按句标注 CC-BY / CC0（原管线已采用）。
"""

import argparse
import json
import shutil
import sqlite3
import sys
import unicodedata
from collections import defaultdict

TATOEBA_LANG = {'cmn': 'zh', 'jpn': 'ja', 'eng': 'en'}


def norm_text(s: str) -> str:
    """匹配归一化：NFKC + 去空白 + 小写（拉丁）。"""
    s = unicodedata.normalize('NFKC', s)
    s = ''.join(s.split()).lower()
    return s


# ---------- 1. 日语词 ← jamdict-cn 中文释义 ----------

def build_jamdict_index(jam_path):
    con = sqlite3.connect(jam_path)
    kanji_idx = defaultdict(set)
    for idseq, text in con.execute('select idseq, text from Kanji'):
        kanji_idx[text].add(idseq)
    kana_idx = defaultdict(set)
    for idseq, text in con.execute('select idseq, text from Kana'):
        kana_idx[text].add(idseq)
    # sid → 所属 entry（Sense.ID 是 sid）
    sid2entry = dict(con.execute('select ID, idseq from Sense'))
    # entry → 中文 gloss 列表（按 sense 顺序）
    zh_glosses = defaultdict(list)  # idseq -> [str]
    sid_seen = set()
    for sid, text in con.execute(
            "select sid, text from SenseGloss where lang='chn' order by sid, rowid"):
        e = sid2entry.get(sid)
        if e is None:
            continue
        # 同一 sense 的多条中文 gloss 合并为一条（去重）
        key = (sid,)
        text = text.strip()
        if not text:
            continue
        zh_glosses[e].append(text)
    con.close()
    return kanji_idx, kana_idx, zh_glosses


def augment_ja_zh(seed, kanji_idx, kana_idx, zh_glosses):
    rows = seed.execute(
        "select id, headword, reading, meanings from words where language='ja'").fetchall()
    hit = miss = 0
    for wid, hw, rd, meanings in rows:
        ids = set()
        if hw:
            ids |= kanji_idx.get(hw, set())
        if rd:
            ids |= kana_idx.get(rd, set())
        if not ids:
            miss += 1
            continue
        hit += 1
        # 取匹配 entry 的中文释义；多 entry 时取 gloss 数最多的前一个
        best = None
        for e in ids:
            g = zh_glosses.get(e)
            if g and (best is None or len(g) > len(best)):
                best = g
        if not best:
            miss += 1
            continue
        # 合并去重、截断（释义过长不友好）
        seen, defs = set(), []
        for g in best:
            if g not in seen:
                seen.add(g)
                defs.append(g)
        joined = '；'.join(defs[:6])
        ml = json.loads(meanings)
        if not any(m.get('lang') == 'zh' for m in ml):
            ml.append({'lang': 'zh', 'def': joined})
            seed.execute('update words set meanings=? where id=?',
                         (json.dumps(ml, ensure_ascii=False), wid))
    print(f'[ja→zh] hit={hit}/{len(rows)} ({hit / len(rows) * 100:.1f}%)')


# ---------- 2. 英语词 ← EJDict 日文释义 ----------

def augment_en_ja(seed, ejdict_path):
    with open(ejdict_path, encoding='utf-8') as f:
        raw = json.load(f)
    ej = {k.lower(): v for k, v in raw.items()}
    rows = seed.execute(
        "select id, headword, tags from words where language='en'").fetchall()
    hit = miss = 0
    for wid, hw, tags in rows:
        cands = {hw.lower()}
        if tags:
            ex = (json.loads(tags).get('exchange') or '')
            for part in ex.split('/'):
                if ':' in part:
                    v = part.split(':', 1)[1].strip().lower()
                    if v:
                        cands.add(v)
        meaning = None
        for c in cands:
            m = ej.get(c)
            if m:
                meaning = m.strip()
                break
        if not meaning:
            miss += 1
            continue
        hit += 1
        ml = json.loads(seed.execute(
            'select meanings from words where id=?', (wid,)).fetchone()[0])
        if not any(m.get('lang') == 'ja' for m in ml):
            # EJDict 释义内含【タグ】（词性标注）与换行，清理后取前段
            import re
            clean = re.sub(r'【[^】]*】', '', meaning)
            clean = '；'.join(x.strip() for x in clean.split('\\n') if x.strip())
            ml.append({'lang': 'ja', 'def': clean[:200]})
            seed.execute('update words set meanings=? where id=?',
                         (json.dumps(ml, ensure_ascii=False), wid))
    print(f'[en→ja] hit={hit}/{len(rows)} ({hit / len(rows) * 100:.1f}%)')


# ---------- 3. 例句翻译（Tatoeba） ----------

def upgrade_examples_and_translations(seed, datasets_dir):
    # 3.1 收集 seed 全部例句文本；旧 translation 按词语言转换（ja 词=英文翻译）
    word_rows = seed.execute(
        'select id, language, examples from words where examples is not null').fetchall()
    texts = set()
    per_word = {}
    for wid, lang, examples in word_rows:
        out = []
        for e in json.loads(examples):
            ne = {'text': e.get('text', '')}
            translations = {}
            old_tr = (e.get('translation') or '').strip()
            if old_tr:
                translations[{'ja': 'en', 'en': 'zh'}.get(lang, 'zh')] = old_tr
            ne['translations'] = translations
            out.append(ne)
            texts.add(ne['text'])
        per_word[wid] = (lang, out)

    # 3.2 pass1：text → Tatoeba id（精确 + 归一化双索引）
    exact = defaultdict(list)
    normed = defaultdict(list)
    for t in texts:
        exact[t].append(t)
        normed[norm_text(t)].append(t)
    tatoeba_ids = defaultdict(set)   # seed text -> {tatoeba id}
    with open(f'{datasets_dir}/sentences.csv', encoding='utf-8', newline='') as f:
        for line in f:
            parts = line.rstrip('\n').split('\t')
            if len(parts) < 3:
                continue
            sid, lang, text = parts[0], parts[1], parts[2]
            matched = None
            if text in exact:
                matched = exact[text]
            elif len(text) > 8:
                m = normed.get(norm_text(text))
                if m:
                    matched = m
            if matched:
                for t in matched:
                    tatoeba_ids[t].add(sid)
    n_hit = sum(1 for t in texts if tatoeba_ids.get(t))
    print(f'[tatoeba] 例句命中 {n_hit}/{len(texts)} ({n_hit / len(texts) * 100:.1f}%)')

    # 3.3 pass2：links 图 BFS 扩展（逐轮扫 links.csv，最多 4 跳）。
    # 目的：翻译句常不是直接链接，而是翻译网络中几跳之外的 cmn/jpn 句。
    # 每句候选上限 MAX_PER_TEXT、sid 归属取首个文本（重复句文本相同，损失可忽略）。
    MAX_PER_TEXT = 120
    MAX_ROUNDS = 3
    known = {t: set(ids) for t, ids in tatoeba_ids.items()}
    sid2text = {}
    for t, ids in known.items():
        for sid in ids:
            sid2text.setdefault(sid, t)

    for _ in range(MAX_ROUNDS):
        added = defaultdict(set)
        with open(f'{datasets_dir}/links.csv', encoding='utf-8', newline='') as f:
            for line in f:
                a, _, b = line.partition('\t')
                if not b:
                    continue
                b = b.strip()
                ta = sid2text.get(a)
                if ta is not None:
                    added[ta].add(b)
                tb = sid2text.get(b)
                if tb is not None:
                    added[tb].add(a)
        grew = False
        for t, sids in added.items():
            cur = known[t]
            for sid in sids:
                if sid not in cur:
                    if len(cur) >= MAX_PER_TEXT:
                        break
                    cur.add(sid)
                    sid2text.setdefault(sid, t)
                    grew = True
        if not grew:
            break

    # 3.4 pass3：取链接句文本（只留 cmn/jpn）
    need = set()
    for ids in known.values():
        need.update(ids)
    link_text = {}
    with open(f'{datasets_dir}/sentences.csv', encoding='utf-8', newline='') as f:
        for line in f:
            parts = line.rstrip('\n').split('\t', 2)
            if parts[0] in need:
                lang = parts[1] if len(parts) > 2 else ''
                if lang in ('cmn', 'jpn'):
                    link_text[parts[0]] = (lang, parts[2])

    # 3.5 写回：每语言取最短的 1 条翻译；跳过与原句相同的自匹配
    n_tr = 0
    for wid, (lang, out) in per_word.items():
        for ne in out:
            ids = known.get(ne['text'])
            if not ids:
                continue
            by_lang = defaultdict(list)
            for sid in ids:
                pair = link_text.get(sid)
                if not pair:
                    continue
                if pair[1] == ne['text']:
                    continue  # Tatoeba 重复句自匹配，非翻译
                l = TATOEBA_LANG.get(pair[0])
                if l and l not in ne['translations']:
                    by_lang[l].append(pair[1])
            for l, cands in by_lang.items():
                if cands:
                    ne['translations'][l] = min(cands, key=len)
                    n_tr += 1
        seed.execute('update words set examples=? where id=?',
                     (json.dumps(out, ensure_ascii=False), wid))
    print(f'[tatoeba] 新增翻译 {n_tr} 条')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--datasets', default='D:/tmp_flutter_dl/datasets')
    ap.add_argument('--seed', default='assets/db/seed_v1.sqlite')
    ap.add_argument('--out', default='assets/db/seed_v2.sqlite')
    args = ap.parse_args()

    shutil.copyfile(args.seed, args.out)
    seed = sqlite3.connect(args.out)

    print('== jamdict-cn 日语中文释义 ==')
    kanji_idx, kana_idx, zh_glosses = build_jamdict_index(
        f'{args.datasets}/jamdict_cn_deduplicated.db')
    augment_ja_zh(seed, kanji_idx, kana_idx, zh_glosses)

    print('== EJDict 英语日文释义 ==')
    augment_en_ja(seed, f'{args.datasets}/ejdict/ejdict.json')

    print('== Tatoeba 例句翻译 ==')
    upgrade_examples_and_translations(seed, args.datasets)

    seed.execute("update meta set value='2' where key='seed_version'")
    seed.commit()
    seed.close()
    print('== 完成：', args.out)


if __name__ == '__main__':
    sys.exit(main())
