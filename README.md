# UIWorkouts

Shared SwiftUI design system for the Workouts app ecosystem (first consumers:
**Couch to Hour**, **Rounds**).

> **The code does not live on `main`.**
> This branch is intentionally a landing page only. Source, tests, the demo app
> and CI are on **`develop`**.

## Branch model

| Branch | Purpose |
|---|---|
| `main` | This README only. Stable pointer; never receives day-to-day work. |
| `develop` | Integration branch — all PR-approved changes land here. Carries the tag of the latest release. Breakable. |
| `release/x.y.z` | Production release versions. |
| `feature/TICKET-short-title` | Where work happens. Branched from `develop`, merged back via PR. |

## Installing

Add the package by **version tag** (tags resolve regardless of branch):

```swift
.package(url: "https://github.com/PadillaTomas/UI-Workouts.git", from: "0.2.0")
```

then add `"UIWorkouts"` to your target and `import UIWorkouts`.

## Working on it

```bash
git clone https://github.com/PadillaTomas/UI-Workouts.git
cd UI-Workouts
git checkout develop
open Package.swift          # or: open Demo/Catalog.xcodeproj
```

The `develop` branch README has the component catalog, testing, and the
pre-tag checklist.
