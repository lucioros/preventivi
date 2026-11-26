-- Preventivi Facili - schema database per Supabase (fase 2: multiutente)
-- Ogni utente vede SOLO i propri dati (Row Level Security).

create table aziende (
  user_id uuid primary key references auth.users on delete cascade,
  ragione text, piva text, indirizzo text, email text, telefono text, iban text,
  iva_default numeric default 22, validita int default 30,
  pagamento text, note text
);

create table clienti (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  nome text not null, piva text, indirizzo text, email text, telefono text,
  creato_il timestamptz default now()
);

create table voci (                      -- "Le mie voci" (catalogo personale)
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  codice text, descrizione text not null, categoria text,
  um text default 'pz', prezzo numeric(12,2) default 0,
  iva numeric(5,2) default 22, sconto numeric(5,2) default 0,
  utilizzi int default 0
);

create table preventivi (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  anno int not null, numero int not null,
  data date not null default current_date, validita_giorni int default 30,
  stato text not null default 'bozza' check (stato in ('bozza','inviato','accettato','rifiutato')),
  cliente_id uuid references clienti on delete set null,
  cliente jsonb,                         -- copia dei dati cliente al momento del preventivo
  oggetto text, pagamento text, consegna text, note text,
  totale numeric(12,2),
  modificato_il timestamptz default now(),
  unique (user_id, anno, numero)
);

create table righe_preventivo (
  id uuid primary key default gen_random_uuid(),
  preventivo_id uuid not null references preventivi on delete cascade,
  posizione int not null,
  descrizione text not null, um text, quantita numeric(12,3) default 1,
  prezzo numeric(12,2) default 0, sconto numeric(5,2) default 0, iva numeric(5,2) default 22
);

alter table aziende enable row level security;
alter table clienti enable row level security;
alter table voci enable row level security;
alter table preventivi enable row level security;
alter table righe_preventivo enable row level security;

create policy "propri dati" on aziende    for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "propri dati" on clienti    for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "propri dati" on voci       for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "propri dati" on preventivi for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "righe dei propri preventivi" on righe_preventivo for all
  using (exists (select 1 from preventivi p where p.id = preventivo_id and p.user_id = auth.uid()))
  with check (exists (select 1 from preventivi p where p.id = preventivo_id and p.user_id = auth.uid()));
