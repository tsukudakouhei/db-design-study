PRAGMA journal_mode = OFF;
PRAGMA synchronous = OFF;

CREATE TABLE skills (
  id   INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE freelancers (
  id         INTEGER PRIMARY KEY,
  name       TEXT NOT NULL,
  email      TEXT NOT NULL,
  自己紹介    TEXT,
  希望単価    INTEGER NOT NULL,          -- 万円
  created_at TEXT NOT NULL              -- 前回の教訓: 最初から置く！
);

CREATE TABLE freelancer_skills (
  freelancer_id INTEGER NOT NULL REFERENCES freelancers(id),
  skill_id      INTEGER NOT NULL REFERENCES skills(id),
  経験年数       INTEGER NOT NULL,
  PRIMARY KEY (freelancer_id, skill_id)
);

-- スキルマスタ: 50件
INSERT INTO skills
SELECT value, 'skill_' || value FROM generate_series(1, 50);
UPDATE skills SET name = 'TypeScript' WHERE id = 1;
UPDATE skills SET name = 'Next.js'    WHERE id = 2;
UPDATE skills SET name = 'PostgreSQL' WHERE id = 3;

-- フリーランス: 10万人（単価30〜100万・登録日はバラバラ）
INSERT INTO freelancers
SELECT
  value,
  'フリーランス' || value,
  'fl' || value || '@example.com',
  'よろしくお願いします',
  30 + abs(random()) % 71,
  datetime('2024-01-01', '+' || (abs(random()) % 900) || ' days')
FROM generate_series(1, 100000);

-- スキル保有: 1人10スキル = 100万行（経験年数0〜10年）
INSERT INTO freelancer_skills
SELECT
  f.value,
  (f.value * 7 + k.value) % 50 + 1,
  abs(random()) % 11
FROM generate_series(1, 100000) AS f,
     generate_series(0, 9)      AS k;
