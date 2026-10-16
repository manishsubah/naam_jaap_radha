# JaapMala

A devotional companion for daily naam jaap and reflections.

- Interactive mala counter (27 / 54 / 108 beads) with haptics, temple bell, and petal burst on mala completion
- Manual entry for jaap done with a physical mala
- Jaap log: every day's count per naam with a running total, plus a form to add or correct any day
- History calendar, weekly chart, streaks, and per-naam totals
- Optional Google backup: records sync to the user's own Google account ([setup](docs/google_backup_setup.md))
- Thoughts journal with typed notes, speech-to-text (Hindi / English), and voice recordings
- Saffron and gold theme with day and night modes

## Run

```bash
flutter pub get
flutter run
```

To turn on Google backup, follow [docs/google_backup_setup.md](docs/google_backup_setup.md), then run with:

```bash
flutter run --dart-define-from-file=config/google_oauth.json
```

## Project structure

```
lib/
├── main.dart                 # Entry point: opens storage, starts the app
├── app/                      # App widget, router, bottom-nav shell
├── core/                     # Shared, feature-agnostic code
│   ├── services/             # Haptics/bell, audio recording, speech-to-text
│   ├── theme/                # Colors and ThemeData
│   ├── utils/                # Pure helpers (date keys, streaks)
│   └── widgets/              # Reusable widgets
├── data/
│   ├── models/               # Naam, JaapEntry, Thought, AppSettings
│   ├── repositories/         # Repository interfaces
│   ├── local/                # Hive implementations of the repositories
│   ├── providers/            # Riverpod state, one file per entity
│   └── sync/                 # Google sign-in, Drive storage, merge and sync
└── features/<feature>/
    ├── domain/               # Pure logic (e.g. MalaProgress)
    └── presentation/         # Screens, plus widgets/ for feature-only widgets
test/                         # Mirrors lib/
```

Imports use `package:naam_jaap/...` paths (enforced by `always_use_package_imports`).

Data is stored on the device with Hive. Storage is accessed through the interfaces in `lib/data/repositories/repositories.dart`, so a remote backend can be added later by implementing them.

## Security

See [docs/security.md](docs/security.md) for what the app stores, what leaves the device, which files must never be committed, and the release checklist.

## Checks

```bash
flutter analyze
flutter test
```

CI runs both on every push and pull request (`.github/workflows/ci.yml`).
