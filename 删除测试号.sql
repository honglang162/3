-- ============ 删除全部测试号（共 67 个）============
-- 用法：Supabase Dashboard → SQL Editor → 整段粘贴 → Run
-- 范围：测甲/测乙/穿甲/穿乙/踩甲/踩乙/镜甲/镜乙/名甲/名乙/倒甲/倒乙
--       + 测试竖屏甲乙 / 甲8006 / 乙8006 / 甲8205 / 乙8205 / 榜1284 / 榜1660 / test1793519343
-- 不碰：曼巴、曼巴红狼、幻影黑风011、无名干员、以及其他真实账号

-- ① 先看一眼将删的账号（跑一次确认数量 = 67，再往下执行）
-- select id, nick from user_nicks
-- where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
--      or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343');

-- ② 删关联数据（私聊 / 好友 / 排行榜 / 云存档）
delete from messages    where sender  in (select id from user_nicks where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343'))
                         or receiver in (select id from user_nicks where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343'));
delete from friends     where owner   in (select id from user_nicks where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343'))
                         or friend    in (select id from user_nicks where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343'));
delete from leaderboard where user_id in (select id from user_nicks where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343'));
delete from saves       where user_id in (select id from user_nicks where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343'));

-- ③ 删联机残留（伤害队列 / 成员 / 房间）
delete from mp_dmg      where target  in (select id from user_nicks where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343'))
                         or room_id in (select room_id from mp_members where user_id in (select id from user_nicks where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343')));
delete from mp_rooms    where id      in (select room_id from mp_members where user_id in (select id from user_nicks where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343')));
delete from mp_members  where user_id in (select id from user_nicks where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343'))
                         or room_id in (select room_id from mp_members where user_id in (select id from user_nicks where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343')));

-- ④ 删账号本体（user_nicks 昵称表 + auth.users 登录本体）
delete from auth.users  where id in (select id from user_nicks where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343'));
delete from user_nicks  where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343');

-- ⑤ 验证：好友列表里不应该再有测试号（应返回 0 行）
select nick from user_nicks where nick like any(array['测甲%','测乙%','穿甲%','穿乙%','踩甲%','踩乙%','镜甲%','镜乙%','名甲%','名乙%','倒甲%','倒乙%'])
     or nick in ('测试竖屏甲','测试竖屏乙','甲8006','乙8006','甲8205','乙8205','榜1284','榜1660','test1793519343');
