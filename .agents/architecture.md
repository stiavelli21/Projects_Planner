# Architecture

Purpose: let an AI agent understand the codebase fast, without exploring
file by file.

## Stack
- Language/framework: Dart / Flutter
- Database / external services: SQLite
- Package manager / build tool: flutter pub

## Folder structure
project/
  lib/            [Main source code]
    data/         [Database configuration and SQLite helper classes]
    models/       [Data models representing entities like Project and Note]
    screens/      [UI screens representing full pages of the app]
    theme/        [Global styling, colors, and typography configurations]
    widgets/      [Reusable UI components used across multiple screens]
  test/           [Unit and widget tests]
  .agents/        # AI agent directives (this folder)

## Key modules
- `lib/main.dart` — entry point, theme setup, runs the app.
- `lib/data/database_helper.dart` — local SQLite database management, CRUD operations.
- `lib/screens/` — UI screens (HomeScreen, ProjectDetailScreen, etc.).

## Data flow
UI screens in `lib/screens/` call `DatabaseHelper` to perform CRUD operations on `Project` and `Note` models. State is managed locally within widgets.

## Conventions
- Naming: snake_case for files, PascalCase for classes, camelCase for variables/methods.
- Errors: Standard Dart try-catch, console logging.
- Tests: Located in `test/`, run via `flutter test`.

## Known constraints / decisions
- Local persistence using SQLite (`sqflite`).
- No complex state management library is used (relies on standard Flutter `setState` / local state).
- UI uses Material 3 with Google Fonts (Nunito).
