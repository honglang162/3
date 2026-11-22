-- ============================================================
-- W15.1 联机装备同步：给 mp_members 加一个 gear_json 列
-- 作用：让队友能看到你带的枪（品质色）、护甲点数、背包
-- 不加也能玩：代码会自动降级，只是看不到队友装备
-- 执行一次即可，可重复执行（if not exists）
-- ============================================================

alter table public.mp_members
  add column if not exists gear_json jsonb;

-- 验证（应返回 gear_json 一行）
select column_name, data_type
from information_schema.columns
where table_schema = 'public'
  and table_name = 'mp_members'
  and column_name = 'gear_json';
