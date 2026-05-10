-- ============================================
-- GRIND TRACKER — Supabase Database Schema
-- ============================================
-- รันสคริปต์นี้ใน Supabase SQL Editor ครั้งเดียว
-- (Dashboard → SQL Editor → paste → Run)
-- ============================================

-- ============================================
-- 1. PRODUCTS TABLE
-- ============================================
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  price integer not null default 0 check (price >= 0),
  goal integer not null default 1 check (goal >= 1),
  sold integer not null default 0 check (sold >= 0),
  image_data text,                       -- base64 image (compressed ~30-80KB)
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists products_user_id_idx on public.products(user_id);


-- ============================================
-- 2. USER PREFERENCES TABLE
-- ============================================
create table if not exists public.user_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  theme text default 'obsidian',
  current_month text,
  updated_at timestamptz default now()
);


-- ============================================
-- 3. ROW LEVEL SECURITY (RLS)
-- ============================================
-- ป้องกันไม่ให้ user เห็นข้อมูลของ user อื่น
-- ถึงแม้จะใช้ anon key เดียวกัน ก็เห็นได้แค่ของตัวเอง

alter table public.products enable row level security;
alter table public.user_preferences enable row level security;


-- ============================================
-- 4. POLICIES — Products
-- ============================================
drop policy if exists "users_select_own_products" on public.products;
drop policy if exists "users_insert_own_products" on public.products;
drop policy if exists "users_update_own_products" on public.products;
drop policy if exists "users_delete_own_products" on public.products;

create policy "users_select_own_products"
  on public.products for select
  using (auth.uid() = user_id);

create policy "users_insert_own_products"
  on public.products for insert
  with check (auth.uid() = user_id);

create policy "users_update_own_products"
  on public.products for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "users_delete_own_products"
  on public.products for delete
  using (auth.uid() = user_id);


-- ============================================
-- 5. POLICIES — User Preferences
-- ============================================
drop policy if exists "users_select_own_prefs" on public.user_preferences;
drop policy if exists "users_upsert_own_prefs" on public.user_preferences;
drop policy if exists "users_update_own_prefs" on public.user_preferences;

create policy "users_select_own_prefs"
  on public.user_preferences for select
  using (auth.uid() = user_id);

create policy "users_upsert_own_prefs"
  on public.user_preferences for insert
  with check (auth.uid() = user_id);

create policy "users_update_own_prefs"
  on public.user_preferences for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


-- ============================================
-- 6. AUTO-UPDATE updated_at TRIGGER
-- ============================================
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists products_updated_at on public.products;
create trigger products_updated_at
  before update on public.products
  for each row execute function public.set_updated_at();

drop trigger if exists user_prefs_updated_at on public.user_preferences;
create trigger user_prefs_updated_at
  before update on public.user_preferences
  for each row execute function public.set_updated_at();


-- ============================================
-- ✅ ESET เรียบร้อย
-- ============================================
-- ถ้าทุกอย่างผ่าน จะเห็น "Success. No rows returned"
-- ============================================
