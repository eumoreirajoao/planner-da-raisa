-- Planner da Raísa: cole este texto no SQL Editor do Supabase e clique em Run.
-- Cria a tabela das páginas do planner e a pasta dos arquivos, e garante que
-- cada pessoa só enxerga e altera o que é dela.

create table if not exists public.planner_docs (
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  key text not null,
  data jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, key)
);
alter table public.planner_docs enable row level security;

drop policy if exists "dono le" on public.planner_docs;
drop policy if exists "dono cria" on public.planner_docs;
drop policy if exists "dono altera" on public.planner_docs;
drop policy if exists "dono apaga" on public.planner_docs;
create policy "dono le" on public.planner_docs for select using (auth.uid() = user_id);
create policy "dono cria" on public.planner_docs for insert with check (auth.uid() = user_id);
create policy "dono altera" on public.planner_docs for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "dono apaga" on public.planner_docs for delete using (auth.uid() = user_id);

insert into storage.buckets (id, name, public, file_size_limit)
values ('arquivos', 'arquivos', false, 20971520)
on conflict (id) do nothing;

-- Pasta pública só com o instalador do app (APK) e o aviso de versão (latest.json).
-- Ninguém grava nela pelo app: quem envia é o GitHub, com a chave service_role.
insert into storage.buckets (id, name, public)
values ('atualizacoes', 'atualizacoes', true)
on conflict (id) do nothing;

drop policy if exists "arquivos do dono" on storage.objects;
create policy "arquivos do dono" on storage.objects for all
  using (bucket_id = 'arquivos' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'arquivos' and (storage.foldername(name))[1] = auth.uid()::text);
