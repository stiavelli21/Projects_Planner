# Projects Planner

**Projects Planner** è un'applicazione multipiattaforma sviluppata in Flutter ideata per organizzare il tuo lavoro e i tuoi progetti in modo semplice ed elegante. Risolve il problema della dispersione delle informazioni, permettendoti di raccogliere note, task e dettagli operativi associati a ogni progetto in un unico posto. Con un approccio *offline-first*, garantisce privacy e velocità, permettendoti di accedere ai tuoi dati ovunque, anche senza connessione internet.

## Stack Necessario

Il progetto adotta una Clean Architecture e si basa sui seguenti strumenti chiave:
- **Framework:** Flutter (Dart)
- **Database:** SQLite (`sqflite`) per una persistenza dei dati veloce e interamente locale
- **File System:** `path_provider` per gestire l'accesso ai percorsi di sistema nei vari OS
- **UI & Stile:** Material Design 3, `google_fonts` e icone native per un'esperienza visiva di alto livello

---

## Panoramica

**Projects Planner** è un'applicazione multipiattaforma sviluppata in **Flutter** e **Dart** che permette di organizzare il proprio lavoro in modo semplice ed elegante. Progettata con un approccio **offline-first**, l'app archivia tutti i dati localmente sul dispositivo garantendo privacy, velocità e disponibilità immediata anche senza connessione Internet.

## Caratteristiche Principali

-  **Gestione Progetti Completa**: Crea, modifica, visualizza e organizza i tuoi progetti. Ogni progetto dispone di un titolo, una descrizione dettagliata e un badge a colori personalizzabile per una rapida identificazione visiva.
-  **Organizzazione Note e Attività**: Associa note e task specifici a ciascun progetto. Tieni traccia dei dettagli operativi con timestamp di creazione e aggiornamento automatici.
-  **Interfaccia Utente Elegante**: Esperienza visiva di altissimo livello basata su **Material Design 3**, arricchita dalla tipografia moderna di **Google Fonts** e icone chiare e intuitive.
-  **Persistenza Locale e Sicura**: Archiviazione dati affidabile e reattiva gestita tramite **SQLite** (`sqflite`), per massimizzare le performance senza dipendere da server esterni.
-  **Selettore di Colori e Stati Vuoti**: Esperienza utente curata nei minimi dettagli, con un color picker dedicato (`color_picker.dart`) e schermate di empty state animate e accattivanti (`empty_state.dart`).
-  **Supporto Multipiattaforma**: Sviluppata per funzionare uniformemente su Android, iOS, Windows, macOS, Linux e Web.

---

## Stack Tecnologico

| Componente | Tecnologia | Descrizione |
| :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev/) | Framework UI per applicazioni native e multipiattaforma |
| **Linguaggio** | [Dart](https://dart.dev/) (^3.9.2) | Linguaggio di programmazione ottimizzato per client UI |
| **Database** | [sqflite](https://pub.dev/packages/sqflite) | Motore database SQLite per la memorizzazione locale |
| **File System** | [path_provider](https://pub.dev/packages/path_provider) | Accesso ai percorsi di sistema nei vari OS |
| **Styling & UI** | [google_fonts](https://pub.dev/packages/google_fonts) & `cupertino_icons` | Tipografia moderna e icone di sistema |

---

## Struttura del Progetto

Il codice sorgente è strutturato seguendo una pulita separazione delle responsabilità (Clean Architecture):

```text
lib/
├── data/
│   └── database_helper.dart      # Gestione del database SQLite e query SQL
├── models/
│   ├── note.dart                 # Modello dati per le note (con serializzazione)
│   └── project.dart              # Modello dati per i progetti
├── screens/
│   ├── home_screen.dart          # Schermata principale con elenco progetti
│   ├── project_detail_screen.dart # Dettaglio progetto ed elenco note associate
│   ├── project_form_screen.dart  # Form di creazione e modifica progetto
│   └── note_editor_screen.dart   # Editor per la stesura e modifica delle note
├── theme/
│   └── app_theme.dart            # Definizione del tema (Material Design 3, colori, font)
├── widgets/
│   ├── project_card.dart         # Card visiva del progetto con indicatore di colore
│   ├── note_tile.dart            # Elemento di lista per le singole note
│   ├── color_picker.dart         # Componente per la selezione del colore del progetto
│   └── empty_state.dart          # Widget per visualizzare schermate vuote
└── main.dart                     # Punto di ingresso dell'applicazione e configurazione
```

---

## Per Iniziare

### Prerequisiti

Assicurati di avere installato sul tuo ambiente di sviluppo:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versione 3.x o superiore)
- [Dart SDK](https://dart.dev/get-dart)
- Un editor di codice come [VS Code](https://code.visualstudio.com/), [Android Studio](https://developer.android.com/studio) o [IntelliJ IDEA](https://www.jetbrains.com/idea/)

### Installazione ed Esecuzione

1. **Clona il repository**:
   ```bash
   git clone https://github.com/stiavelli21/Projects_Planner.git
   cd Projects_Planner
   ```

2. **Installa le dipendenze**:
   Scarica i pacchetti necessari eseguendo il comando:
   ```bash
   flutter pub get
   ```

3. **Esegui l'applicazione**:
   Connetti un dispositivo (fisico o emulatore) ed avvia l'app con:
   ```bash
   flutter run
   ```

---

## Contributi

I contributi sono benvenuti! Se desideri proporre miglioramenti o nuove funzionalità:
1. Fai un **Fork** del repository.
2. Crea un branch per la tua funzionalità (`git checkout -b feature/NuovaFunzionalita`).
3. Effettua il commit delle tue modifiche (`git commit -m 'Aggiunta nuova funzionalità'`).
4. Fai il push sul branch (`git push origin feature/NuovaFunzionalita`).
5. Apri una **Pull Request**.

---

## Licenza

Questo progetto è distribuito con licenza **MIT**. Sentiti libero di utilizzarlo e modificarlo per le tue esigenze di sviluppo e apprendimento.
