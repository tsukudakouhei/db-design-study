# DB設計 学習用サンドボックス

題材: フリーランスマッチングサービス（学習セッション 2026-07-18〜）

## ファイル

| ファイル | 内容 |
|---|---|
| `db-origin-notes.html` | **原点ノート図解版**（各概念が「なぜ生まれたか」の歴史を年表＋図で。画像は gpt-image-2 生成） |
| `zukai-notes.html` | **図解版ノート**（図10枚・言葉最小限。まずこれを開く） |
| `study-notes.html` | 学習ノート詳細版（全ラウンドの学び＋チートシート） |
| `er-diagram.html` | 現時点のスキーマ関連図（ブラウザで開く） |
| `seed.sql` | スキーマ定義＋ダミーデータ生成（10万人・100万行） |
| `matching.db` | 生成済み SQLite DB（インデックス2本＋ANALYZE 適用済み） |

## 使い方

```bash
# 対話モードで開く
sqlite3 matching.db

# ゼロから作り直す（数秒で終わる）
rm -f matching.db && sqlite3 matching.db < seed.sql
```

作り直した場合、インデックスは入っていないので必要なら:

```sql
CREATE INDEX skill_id          ON freelancer_skills (skill_id, freelancer_id); -- ラウンド5で自作した目次
CREATE INDEX idx_fs_skill_years ON freelancer_skills (skill_id, 経験年数);      -- 教科書解（実測は引き分けだった）
ANALYZE;  -- これを忘れるとインデックスが使われないことがある！
```

## 例の検索クエリ（TypeScript・経験3年以上・単価70万以下・新着順20人）

```sql
.timer on
EXPLAIN QUERY PLAN
SELECT f.id, f.name, f.希望単価, fs.経験年数, f.created_at
FROM skills s
JOIN freelancer_skills fs ON fs.skill_id = s.id
JOIN freelancers f ON f.id = fs.freelancer_id
WHERE s.name = 'TypeScript' AND fs.経験年数 >= 3 AND f.希望単価 <= 70
ORDER BY f.created_at DESC, f.id DESC LIMIT 20;
```

実測メモ（2026-07-19, M系Mac）: インデックスなし 61ms → あり 19ms。
`SCAN` = 全行読み / `SEARCH ... USING INDEX` = 目次で短絡、を実行計画で確認する。

## 学習の続きは

Claude Code で「DB設計の続きやろう」または `/run-benkyou DB設計` で再開（run-benkyou スキルが
想起クイズ→間隔再挑戦→新ラウンドの順で回す）。進捗・次回クイズ候補は `progress.md` 参照。
