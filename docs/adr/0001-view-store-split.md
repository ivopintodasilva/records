# ADR 0001: Split Feature Stores and Views

## Status
- Accepted

## Context
- Feature files contained both reducer logic and SwiftUI views.
- We want clearer separation between logic and UI to keep files focused.
- The codebase uses a modular target structure with many small features.

## Decision
- Each feature is split into two files:
  - `*Feature.swift` contains reducer/state/action logic.
  - `*View.swift` contains SwiftUI views.

## Consequences
- Positive: clearer boundaries and easier navigation.
- Negative: more files per feature.
- Follow-ups: update scaffolding to generate both files.
