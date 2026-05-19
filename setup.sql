-- Run this in the Supabase SQL editor (supabase.com → your project → SQL Editor)
--
-- ALSO: Create a storage bucket called "completions" in Supabase Storage
--   → Storage → New Bucket → Name: completions, Public: ON

create table gslop_requests (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  description text,
  submitted_by text,
  created_at timestamptz default now()
);

create table gslop_votes (
  id uuid default gen_random_uuid() primary key,
  request_id uuid references gslop_requests(id) on delete cascade,
  device_id text not null,
  vote_type smallint not null check (vote_type in (-1, 1)),
  voted_at timestamptz default now(),
  unique(request_id, device_id)
);

create table gslop_completions (
  id uuid default gen_random_uuid() primary key,
  request_id uuid references gslop_requests(id) on delete cascade,
  image_url text not null,
  uploaded_by text,
  created_at timestamptz default now()
);

create table gslop_comments (
  id uuid default gen_random_uuid() primary key,
  request_id uuid references gslop_requests(id) on delete cascade,
  body text not null,
  author text,
  created_at timestamptz default now()
);

alter table gslop_requests enable row level security;
alter table gslop_votes enable row level security;
alter table gslop_completions enable row level security;
alter table gslop_comments enable row level security;

create policy "public_all" on gslop_requests for all using (true) with check (true);
create policy "public_all" on gslop_votes for all using (true) with check (true);
create policy "public_all" on gslop_completions for all using (true) with check (true);
create policy "public_all" on gslop_comments for all using (true) with check (true);
