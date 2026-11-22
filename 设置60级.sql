-- ============================================================================
-- 把指定账号设为 Lv.60（满级）
-- 用法：Supabase Dashboard → SQL Editor
--       ★ 一次只跑一段：选中该段 → Run，跑完再选下一段
-- 等级不存在单独字段，由 saves.data->stats->xp 换算：
--   Lv.1=0  Lv.20=10070  Lv.40=38220  Lv.60=84370
-- ============================================================================


-- ───────────────────────── 第 1 段：看现状 ─────────────────────────
select n.nick,
       n.id as user_id,
       (s.data->'stats'->>'xp')::int as xp
from user_nicks n
left join saves s on s.user_id = n.id
order by xp desc nulls last, n.nick;


-- ───────────────────── 第 2 段：改成 Lv.60（白名单）─────────────────────
-- 名单 = 财富榜前 7 名真实账号；要加人/换人直接改括号里的昵称
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
from user_nicks n
where n.id = s.user_id
  and n.nick in (
    '彦祖是我',
    '幻影黑风011',
    '曼巴红狼',
    '南辞（手表上那个）',
    '曼巴',
    '一只鼠鼠995',
    '蚀金玫瑰'
  );


-- ───────────── 第 2-B 段：全员 60 级（可选，想全设就跑这段）─────────────
-- update saves s
-- set data = jsonb_set(
--              coalesce(s.data, '{}'::jsonb),
--              '{stats}',
--              jsonb_build_object(
--                'runs',     coalesce((s.data->'stats'->>'runs')::int, 0),
--                'extracts', coalesce((s.data->'stats'->>'extracts')::int, 0),
--                'kills',    coalesce((s.data->'stats'->>'kills')::int, 0),
--                'xp',       84370
--              ),
--              true
--            )
--            || jsonb_build_object('ts', (extract(epoch from now()) * 1000)::bigint),
--     updated_at = now()
-- where s.data is not null
--   and s.user_id in (select id from user_nicks where nick not like 'test%');


-- ───────────────────────── 第 3 段：验证 ─────────────────────────
select n.nick,
       (s.data->'stats'->>'xp')::int as xp,
       to_timestamp((s.data->>'ts')::bigint / 1000) as save_ts
from user_nicks n
join saves s on s.user_id = n.id
where n.nick in (
  '彦祖是我','幻影黑风011','曼巴红狼','南辞（手表上那个）','曼巴','一只鼠鼠995','蚀金玫瑰'
)
order by n.nick;


-- 说明：
-- · 第 2 段返回 UPDATE 7 行，说明 7 个存档都改到了
-- · 第 3 段 xp 应该全是 84370
-- · 如果某人第 3 段查不到，说明他没有云存档（没联网玩过），让他先登录玩一次再跑
-- · 已经写入了新的 ts（当前时间），玩家下次进游戏会自动拉取，显示 Lv.60 / 已满级
