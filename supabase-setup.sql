-- 何度実行しても大丈夫な、ふたりの図鑑用セットアップSQLです。

create table if not exists public.entries (
  id bigint not null,
  room text not null,
  name text not null,
  kind text,
  type text,
  sprite text,
  photo text,
  date text,
  place text,
  lat double precision,
  lng double precision,
  owner uuid not null default auth.uid(),
  primary key (room, id)
);

alter table public.entries enable row level security;
alter table public.entries add column if not exists dex_no bigint;

drop policy if exists "shared dex read" on public.entries;
drop policy if exists "shared dex add" on public.entries;
drop policy if exists "shared dex update" on public.entries;
drop policy if exists "shared dex delete" on public.entries;
create policy "shared dex read" on public.entries for select using (auth.uid() = owner);
create policy "shared dex add" on public.entries for insert with check (auth.uid() = owner);
create policy "shared dex update" on public.entries for update using (auth.uid() = owner) with check (auth.uid() = owner);
create policy "shared dex delete" on public.entries for delete using (auth.uid() = owner);

insert into storage.buckets (id, name, public) values ('dex-photos', 'dex-photos', true)
on conflict (id) do nothing;

drop policy if exists "shared dex photo read" on storage.objects;
drop policy if exists "shared dex photo add" on storage.objects;
drop policy if exists "shared dex photo update" on storage.objects;
drop policy if exists "shared dex photo delete" on storage.objects;

-- Supabase の storage.objects.owner_id は text 型なので、ログインIDを文字列へ変換します。
create policy "shared dex photo read" on storage.objects for select
  using (bucket_id = 'dex-photos' and owner_id = (select auth.uid()::text));
create policy "shared dex photo add" on storage.objects for insert
  with check (bucket_id = 'dex-photos' and owner_id = (select auth.uid()::text));
create policy "shared dex photo update" on storage.objects for update
  using (bucket_id = 'dex-photos' and owner_id = (select auth.uid()::text))
  with check (bucket_id = 'dex-photos' and owner_id = (select auth.uid()::text));
create policy "shared dex photo delete" on storage.objects for delete
  using (bucket_id = 'dex-photos' and owner_id = (select auth.uid()::text));
