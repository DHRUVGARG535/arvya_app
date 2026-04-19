# ArvyaX (Interview Assignment)

Immersive session mini-app: Ambiences → Player → Reflection (Journal) → History.

## How to run

1. Install Flutter dependencies:
   - `flutter pub get`
2. Run on Android (recommended for this assignment):
   - `flutter run`

Note: Audio/images are referenced as local assets from `assets/` (see `assets/data/ambiences.json` and `pubspec.yaml`).
Make sure matching files exist under `assets/audio/` and `assets/images/` before running.

## Architecture

State management: `flutter_riverpod` (single approach across the app).

Folder organization:
- `lib/data/`
  - `models/` (plain data models)
  - `repositories/` (data loading + persistence)
- `lib/features/`
  - `ambience/` (home + details)
  - `player/` (audio session UI + timing)
  - `journal/` (reflection + history)
- `lib/shared/`
  - reusable widgets (ex: `mini_player_bar.dart`)

## Data flow (high-level)

1. Ambience library
   - `AmbienceRepository` loads `assets/data/ambiences.json`
   - `ambienceListProvider` exposes the list to `HomeScreen`
   - tapping an ambience opens `AmbienceDetailsScreen`
2. Player session
   - `PlayerScreen` uses `just_audio` to load `ambience.audio`
   - session timing is capped to `ambience.duration`
   - when the session reaches the cap or user ends the session, it navigates to `JournalScreen`
3. Persistence (Journal + History)
   - `JournalRepository` persists entries to Hive box `journals`
   - `HistoryScreen` reads all saved journal entries and displays them via `JournalCard`

## Analytics (Local Logging)

Basic analytics events are implemented to track user interaction flow:

- `session_start`
  - Triggered when the user starts a session for the first time (on play).
  - Logs ambience title and duration.

- `session_end`
  - Triggered when the session completes or is manually ended.
  - Logs ambience title.

- `journal_saved`
  - Triggered when a reflection is saved.
  - Logs selected mood and journal text length.

Implementation:
- A lightweight `AnalyticsService` is used for structured local logging.
- Events are printed using `debugPrint` for visibility during development.

Purpose:
- Demonstrates basic product thinking and user behavior tracking.
- Keeps implementation simple and aligned with assignment scope (no external SDKs).

## Packages used (why)

- `flutter_riverpod`: predictable state management with providers
- `just_audio`: reliable local audio playback + position streams
- `hive` + `hive_flutter`: lightweight local persistence for journal entries
- `intl`: user-friendly date/time formatting on history cards

## Tradeoffs / what I would improve next

- Add the assignment’s mini-player + “last active session state” restore (so exiting the session still shows a persistent player and the app can resume after restart).
- Add a slightly more advanced session timer controller (pause/resume semantics consistent with play/pause).
- Improve UX around missing audio/image assets with stronger preflight checks.
