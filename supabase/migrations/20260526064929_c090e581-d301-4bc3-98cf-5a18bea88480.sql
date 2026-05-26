-- Public game rooms lobby for Nebula Tactics online multiplayer
create table if not exists public.game_rooms (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  host_name text not null default 'Commander',
  needed_players int not null default 2 check (needed_players between 2 and 4),
  joined_players int not null default 1 check (joined_players >= 0),
  status text not null default 'waiting' check (status in ('waiting','playing','finished')),
  state jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_game_rooms_status_created on public.game_rooms (status, created_at desc);

alter table public.game_rooms enable row level security;

-- Public lobby: anyone (anon or authenticated) can list, create, join, update, and clean up rooms.
-- This is an ephemeral lobby (no PII, no auth required), so open access is acceptable.
drop policy if exists "Anyone can read rooms" on public.game_rooms;
drop policy if exists "Anyone can create rooms" on public.game_rooms;
drop policy if exists "Anyone can update rooms" on public.game_rooms;
drop policy if exists "Anyone can delete rooms" on public.game_rooms;

create policy "Anyone can read rooms" on public.game_rooms for select using (true);
create policy "Anyone can create rooms" on public.game_rooms for insert with check (true);
create policy "Anyone can update rooms" on public.game_rooms for update using (true) with check (true);
create policy "Anyone can delete rooms" on public.game_rooms for delete using (true);

-- Auto-update updated_at on changes
create or replace function public.touch_game_rooms_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_touch_game_rooms on public.game_rooms;
create trigger trg_touch_game_rooms before update on public.game_rooms
for each row execute function public.touch_game_rooms_updated_at();

-- Enable Realtime so the lobby list updates live
alter publication supabase_realtime add table public.game_rooms;