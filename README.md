# Preventivi Facili

Web app semplicissima per fare preventivi, pensata per chi oggi li scrive a mano.

## Cosa fa
- **Preventivi** numerati in automatico (es. 3/2026), con stato: bozza, inviato, accettato, rifiutato
- **Voci di preventivo** con descrizione, unità di misura, quantità, prezzo unitario, sconto %, IVA (22/10/5/4/0)
- **Le mie voci**: catalogo personale delle voci più usate. Mentre scrivi una voce nuova puoi premere ⭐ *Memorizza* per salvarla; le più usate compaiono come pulsanti da toccare
- **Clienti**: rubrica che si riempie da sola quando salvi un preventivo
- Totali automatici: imponibile, IVA divisa per aliquota, totale
- **Stampa / PDF** con intestazione aziendale, condizioni, validità e spazio per la firma di accettazione
- Duplica preventivo, ricerca, backup e ripristino dei dati

## Pubblicarla su GitHub Pages (5 minuti)
1. Crea un account su https://github.com
2. Clicca **New repository**, nome `preventivi`, lascia *Public*, crea
3. **Add file → Upload files** e carica `index.html` (e questo README)
4. **Settings → Pages** → *Source: Deploy from a branch* → branch `main`, cartella `/ (root)` → Save
5. Dopo un minuto l'app è su `https://TUO-NOME.github.io/preventivi/`

## Database su GitHub
I dati vengono salvati come file JSON in un repository GitHub, con **un file per ogni utente** (`dati/mario.json`, `dati/luca.json`…). Ogni salvataggio è un commit, quindi hai anche lo storico di tutte le modifiche.

Consiglio due repository:
- `preventivi` **pubblico**: contiene solo l'app (`index.html`), servita da GitHub Pages
- `preventivi-dati` **privato**: contiene i dati, così nessuno li vede

### Creare il repository dei dati
1. **New repository** → nome `preventivi-dati` → **Private** → spunta *Add a README file* → Create

### Creare il token (la "chiave" che permette all'app di scrivere)
1. In GitHub: foto profilo → **Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token**
2. Nome: `preventivi`; Scadenza: 1 anno (o quella che preferisci)
3. **Repository access → Only select repositories** → scegli `preventivi-dati`
4. **Permissions → Repository permissions → Contents → Read and write**
5. Genera e copia il token (inizia con `github_pat_`)

### Collegare l'app
Apri l'app → **Impostazioni → Database su GitHub** → inserisci il tuo nome utente, il nome del tuo account GitHub, `preventivi-dati`, il token → **Collega e carica i dati**. Si fa una volta per ogni computer/telefono.

Note:
- Il token resta salvato solo nel browser di quel dispositivo. Chi ha il token può modificare i dati, quindi non condividerlo fuori dall'azienda.
- Se GitHub non è raggiungibile, l'app continua a funzionare con i dati del browser e lo segnala in alto.
- Ogni file utente può arrivare a 1 MB (migliaia di preventivi).

## Usare l'app con più ditte
L'app è una sola (`https://lucioros.github.io/preventivi/`), ma **ogni ditta ha il suo repository privato e il suo token**: così nessuna ditta può vedere i dati di un'altra.

### Aggiungere una nuova ditta (circa 5 minuti)
1. **Crea il repository della ditta**: github.com/new → nome `preventivi-NOMEDITTA` (es. `preventivi-rossi`) → **Private** → spunta *Add a README file* → Create
2. **Crea il token della ditta**: github.com/settings/personal-access-tokens/new
   - Nome: `preventivi-rossi`; scadenza: la più lunga che ti propone (segnati la data!)
   - *Repository access* → **Only select repositories** → solo `preventivi-rossi`
   - *Permissions* → **Contents: Read and write** → Generate token → copialo
3. **Crea il link di attivazione**: apri l'app → *Impostazioni* → *Per l'amministratore: crea il link di attivazione* → nome ditta, repository, token → **Crea link** → **Copia link**
4. **Manda il link alla ditta** in privato (WhatsApp, email). Ogni persona della ditta lo apre sul proprio computer o telefono, scrive il suo nome e l'app è pronta. Poi va su *Impostazioni* e inserisce dati e logo della ditta.

Ogni persona della ditta ha il suo file (`dati/mario.json`, `dati/luca.json`) nello stesso repository.

### Quando un token scade
L'app mostra "Token non valido o scaduto". Crea un nuovo token per lo stesso repository (passo 2), un nuovo link (passo 3) e rimandalo: i dati non si perdono.

### Togliere l'accesso a una ditta
Elimina il suo token da github.com/settings/personal-access-tokens. I dati restano nel repository finché non lo cancelli.

### Privacy
I repository sono sul tuo account, quindi conservi tu i dati dei clienti delle ditte: è opportuno un breve accordo scritto con ogni ditta sul trattamento dei dati (GDPR).

## Alternativa futura
Se un giorno servissero login veri e permessi più fini, `supabase_schema.sql` contiene lo schema pronto per un database Supabase.
