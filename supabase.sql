-- Rasid : base de données d'un client (à exécuter une seule fois dans Supabase > SQL Editor > New query > Run)

create table if not exists public.docs (
  col        text        not null,
  id         text        not null,
  data       jsonb       not null,
  updated_at timestamptz not null default now(),
  updated_by uuid        default auth.uid(),
  primary key (col, id)
);

create or replace function public.docs_touch() returns trigger language plpgsql as $$
begin new.updated_at := now(); new.updated_by := auth.uid(); return new; end $$;
drop trigger if exists docs_touch on public.docs;
create trigger docs_touch before insert or update on public.docs for each row execute function public.docs_touch();

-- Seules les personnes connectées (comptes créés par l'administrateur) lisent et écrivent
alter table public.docs enable row level security;
drop policy if exists "lecture membres" on public.docs;
drop policy if exists "ajout membres" on public.docs;
drop policy if exists "modif membres" on public.docs;
drop policy if exists "suppression membres" on public.docs;
create policy "lecture membres"     on public.docs for select to authenticated using (true);
create policy "ajout membres"       on public.docs for insert to authenticated with check (true);
create policy "modif membres"       on public.docs for update to authenticated using (true) with check (true);
create policy "suppression membres" on public.docs for delete to authenticated using (true);

-- Mise à jour en direct entre les appareils
alter table public.docs replica identity full;
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null; end $$;
