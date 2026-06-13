# UniversitiesBrowser

A small, production-quality iOS app that lists universities for a country, caches them
locally, and shows a details screen for a selected item. The focus is **architecture,
modularization, and code quality** rather than visual polish.

The app lists universities for the **United Arab Emirates** from the
[Hipolabs Universities API](http://universities.hipolabs.com/search?country=United%20Arab%20Emirates),
caches the result in a local database, and falls back to the cache when the network is
unavailable.

---

## Requirements

- Xcode 15 or later (developed against Xcode 26)
- iOS 15.1+ deployment target
- Swift 5.9+

## How to run

1. Open `UniversitiesBrowser.xcodeproj` in Xcode.
2. Select the **UniversitiesBrowser** scheme and an iOS 15.1+ simulator.
3. Build & run (`Cmd + R`).

The local SPM packages under `Packages/` are referenced by path, so Xcode resolves them
automatically — no extra setup is required. The only remote dependency is
[GRDB.swift](https://github.com/groue/GRDB.swift) (used by `PersistenceKit`), which Xcode
fetches on first build.

> The API is served over **HTTP**, so the app relies on an App Transport Security
> exception for `universities.hipolabs.com`.

### Running tests

Run the unit tests from Xcode (`Cmd + U`), or per package:

```bash
cd Packages/NetworkKit && swift test
```

---

## Architecture

The app follows **VIPER + Clean Architecture** with a strict dependency direction:
feature modules depend only on abstractions (`DomainKit`) and shared UI (`CommonUI`).
Concrete implementations of those abstractions live in the app target and are injected at
composition time, so no feature module knows about the network or database layers.

### Layers

- **Domain** (`DomainKit`) — framework-agnostic entities (`University`), repository and
  service **protocols**, and errors. This is the contract every other layer is written
  against and the shared model passed between features.
- **Data** (`NetworkKit`, `PersistenceKit`) — a custom URLSession-based API client and a
  GRDB-backed cache. The app target's `UniversitiesRepositoryImpl` composes the two into
  the network-first / cache-fallback policy.
- **Presentation** (`ListingFeature`, `DetailsFeature`, `CommonUI`) — VIPER modules whose
  SwiftUI views are hosted inside `UIViewController`s and routed via
  `UINavigationController`.

### VIPER per feature

Each feature module is split into the standard VIPER roles:

- **View** — a `UIViewController` that embeds a SwiftUI `View` via `UIHostingController`.
- **Presenter** — an `@MainActor ObservableObject` that exposes a `@Published` state and
  is observed by the SwiftUI view. The state stream is the single source of truth per
  screen.
- **Interactor** — talks to the domain repository/use cases.
- **Router** — performs navigation through the shared `UINavigationController`
  (push/pop). No SwiftUI `NavigationStack` routing is used.
- **Builder** — wires the V/I/P/R graph and returns a ready `UIViewController`.

### Navigation & data flow

```
Listing (fetch + cache) ──push──▶ Details (shows passed item, no API call)
        ▲                                    │
        └──── refresh wired back via ────────┘
              UniversitiesRefreshService
```

1. The user lands on the **Listing** screen, which fetches from the API and caches the
   result.
2. On API failure the repository loads from the database if data exists; otherwise the
   listing shows the shared `ErrorView` with a **Try Again** action.
3. Selecting a row pushes the **Details** screen. The selected `University` is passed
   directly across packages — **no API call happens on Details**.
4. Details exposes a **Refresh** button. It calls a `UniversitiesRefreshService`
   abstraction (Details stays unaware of the network layer); the app wires that back to
   the Listing presenter, which re-fetches and updates the cache.

### Composition root

`AppContainer` (app target) is the composition root. It constructs the API client,
database, cache, repository, and refresh service, then injects them into the feature
builders. `UniversitiesBrowserApp` hosts the root `UINavigationController` inside a
`UIViewControllerRepresentable`.

---

## Modules (SPM packages)

| Package            | Responsibility                                                                 |
|--------------------|--------------------------------------------------------------------------------|
| `DomainKit`        | Shared entities, repository/service protocols, domain errors.                  |
| `NetworkKit`       | URLSession API client, endpoint building, DTO decoding, network errors.        |
| `PersistenceKit`   | GRDB database stack + universities cache (read/write).                         |
| `CommonUI`         | Shared `LoadingView`, `EmptyStateView`, `ErrorStateView`.                      |
| `ListingFeature`   | Module A — listing screen (SwiftUI in a `UIViewController`).                   |
| `DetailsFeature`   | Module B — details screen (SwiftUI in a `UIViewController`) with Refresh.      |

Dependency rules: features depend on `DomainKit` and `CommonUI` only. `NetworkKit` and
`PersistenceKit` depend on `DomainKit` for the shared model. The app target depends on
everything and supplies the concrete implementations.

---

## Concurrency

- Network and database access use `async/await`.
- Presenters are annotated `@MainActor`; UI state is published and observed on the main
  actor.

---

## Trade-offs & notes

- **Single shared model.** `University` from `DomainKit` is used end-to-end. DTOs
  (`NetworkKit`) and records (`PersistenceKit`) map to/from it, keeping each layer's
  serialization concerns local while features share one type.
- **Network-first repository.** On every load the repository fetches from the network and
  refreshes the cache on success; on any failure it returns cached data, and only
  surfaces an error when the cache is empty. This keeps the listing usable offline.
- **GRDB** was chosen over Core Data for a lighter, value-type-friendly API and simpler
  testing; it is the one external dependency.
- **Refresh decoupling.** Details triggers a refresh through the
  `UniversitiesRefreshService` protocol rather than calling the network directly, so the
  Details module has no knowledge of the data layer.
