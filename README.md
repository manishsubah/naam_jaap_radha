# JaapMala

A devotional companion for daily naam jaap and reflections.

- Interactive mala counter (27 / 54 / 108 beads) with haptics, temple bell, and petal burst on mala completion
- Manual entry for jaap done with a physical mala
- History calendar, weekly chart, streaks, and per-naam totals
- Thoughts journal with typed notes, speech-to-text (Hindi / English), and voice recordings
- Saffron and gold theme with day and night modes

## Run

```bash
flutter pub get
flutter run
```

Data is stored on the device with Hive. Storage is accessed through the interfaces in `lib/data/repositories/repositories.dart`, so a remote backend can be added later by implementing them.
