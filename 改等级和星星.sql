-- ============================================================================
-- ① 曼巴红狼（2个号）+ zhaoxuan：等级升到 Lv.60
-- ② zhaoxuan：追加 20 颗东洲之星
-- 用法：Supabase Dashboard → SQL Editor → 一次选中一段 → Run
-- 等级换算：Lv.60（满级）= xp 84370
-- ============================================================================


-- ─────────────── 第 1 段：先看三人现状 ───────────────
select n.nick,
       n.id as user_id,
       (s.data->'stats'->>'xp')::int as xp,
       (select count(*) from jsonb_array_elements(coalesce(s.data->'stash','[]'::jsonb)) el
         where el->>'n' = '东洲之星') as stars
from user_nicks n
left join saves s on s.user_id = n.id
where n.id in (
  '8a86a68b-549e-46b6-95e0-83bd02343afa',   -- zhaoxuan
  'ace835c0-dca0-456d-a510-e3198207b612',   -- 曼巴红狼（号1）
  'b9eec6d8-8648-4f70-8f0e-c8bb5ba7e69d'    -- 曼巴红狼（号2）
);


-- ─────────────── 第 2 段：三个号等级全部设为 Lv.60 ───────────────
update saves s
set data = jsonb_set(
             coalesce(s.data, '{}'::jsonb),
             '{stats}',
             jsonb_build_object(
               'runs',     coalesce((s.data->'stats'->>'runs')::int, 0),
               'extracts', coalesce((s.data->'stats'->>'extracts')::int, 0),
               'kills',    coalesce((s.data->'stats'->>'kills')::int, 0),
               'xp',       84370
             ),
             true
           )
           || jsonb_build_object('ts', (extract(epoch from now()) * 1000)::bigint),
    updated_at = now()
where s.user_id in (
  '8a86a68b-549e-46b6-95e0-83bd02343afa',
  'ace835c0-dca0-456d-a510-e3198207b612',
  'b9eec6d8-8648-4f70-8f0e-c8bb5ba7e69d'
);
-- 预期返回 UPDATE 2 或 3（没玩过的号可能没有存档行）


-- ─────────────── 第 3 段：给 zhaoxuan 追加 20 颗东洲之星 ───────────────
-- ★ 会重复发放：跑一次 +20 颗，再跑一次再 +20 颗，不想多发就只跑一次
update saves s
set data = jsonb_set(
             coalesce(s.data, '{}'::jsonb),
             '{stash}',
             coalesce(s.data->'stash', '[]'::jsonb) ||
             (select jsonb_agg(jsonb_build_object(
                'n', '东洲之星',
                'r', 'mythic',
                'v', 12000 + (random() * 1500)::int,
                'k', '稀世宝石',
                'e', null,
                'a', 0,
                'b', 0,
                'h', 0,
                'l', 'star-gem',
                's', 0
              ))
              from generate_series(1, 20)),
             true
           )
           || jsonb_build_object('ts', (extract(epoch from now()) * 1000)::bigint),
    updated_at = now()
where s.user_id = '8a86a68b-549e-46b6-95e0-83bd02343afa';
-- 预期返回 UPDATE 1（若返回 0，说明 zhaoxuan 还没有云存档，让他先登录玩一次再跑）


-- ─────────────── 第 4 段：验证 ───────────────
select n.nick,
       (s.data->'stats'->>'xp')::int as xp,
       (select count(*) from jsonb_array_elements(coalesce(s.data->'stash','[]'::jsonb)) el
         where el->>'n' = '东洲之星') as stars,
       to_timestamp((s.data->>'ts')::bigint / 1000) as save_ts
from user_nicks n
left join saves s on s.user_id = n.id
where n.id in (
  '8a86a68b-549e-46b6-95e0-83bd02343afa',
  'ace835c0-dca0-456d-a510-e3198207b612',
  'b9eec6d8-8648-4f70-8f0e-c8bb5ba7e69d'
);
-- 预期：三行 xp 全是 84370；zhaoxuan 的 stars 比之前多 20
