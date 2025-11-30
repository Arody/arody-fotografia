# Architecture Plan - Arody Fotografía

## Tech Stack
- **Frontend**: Flutter (latest stable)
- **Backend**: Supabase (PostgreSQL, Auth, Storage, Edge Functions)
- **State Management**: Riverpod (v2.x) with code generation (`flutter_riverpod`, `riverpod_annotation`).
    - *Justification*: Riverpod offers a robust, compile-time safe dependency injection and state management solution. It decouples state from the widget tree, making testing and scalability easier compared to Provider or Bloc (less boilerplate than Bloc for simple states, powerful enough for complex flows).
- **Navigation**: `go_router` (standard for modern Flutter apps).

## Folder Structure (Clean Architecture)
We will organize the `lib` folder into layers:

```
lib/
├── core/                   # Shared utilities, constants, exceptions
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/                   # Data layer (Repositories implementations, Data Sources)
│   ├── models/             # DTOs (Data Transfer Objects) mirroring Supabase tables
│   ├── repositories/       # Implementation of domain repositories
│   └── datasources/        # Direct Supabase client calls
├── domain/                 # Business logic layer (Entities, Repository Interfaces)
│   ├── entities/           # Pure Dart classes (business objects)
│   └── repositories/       # Abstract interfaces for repositories
├── presentation/           # UI layer (Widgets, Providers/Controllers)
│   ├── common/             # Reusable widgets
│   ├── screens/            # Screen widgets (grouped by feature)
│   │   ├── auth/
│   │   ├── home/
│   │   ├── sessions/
│   │   ├── inspiration/
│   │   └── payments/
│   └── providers/          # Riverpod providers for UI state
└── main.dart
```

## Supabase Integration
- **Initialization**: Initialize Supabase in `main.dart` using `Supabase.initialize()`.
- **Configuration**: Store URL and Anon Key in `lib/core/constants/supabase_constants.dart` (reading from `String.fromEnvironment` for security, allowing injection via `--dart-define`).
- **Data Access**:
    - Use `Supabase.instance.client` in Data Sources.
    - Repositories will handle data fetching and mapping from `Model` (Data layer) to `Entity` (Domain layer).

## High-Level Data Flow
1.  **Auth**:
    - UI triggers login.
    - Repository calls `Supabase.auth.signInWithPassword`.
    - Session persisted automatically by Supabase SDK.
    - Auth state changes listened to via `onAuthStateChange` stream.
2.  **Sessions/Data**:
    - UI watches a Riverpod provider (e.g., `sessionsProvider`).
    - Provider calls `GetSessionsUseCase` (or directly Repository).
    - Repository fetches data from `sessions` table via Supabase client.
    - Data returned as Entities to UI.
