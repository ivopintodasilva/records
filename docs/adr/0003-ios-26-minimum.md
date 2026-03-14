# ADR 0003: Raise Minimum iOS to 26

## Status
- Accepted

## Context
- We already target iOS-only and rely on modern APIs like VisionKit for barcode scanning.
- Maintaining availability checks and older deployment targets adds complexity without user value.
- We want a single platform baseline across the app and package.

## Decision
- Set the minimum iOS deployment target to 26.0 across the project.
- Keep `RecordsKit`'s SwiftPM manifest listing macOS 13 only to satisfy SwiftPM-based tooling
  (SwiftFormat/SwiftLint/SwiftGen plugins) that executes on macOS.
- Remove `#available(iOS ...)` checks that only guarded features now guaranteed by the minimum OS.

## Consequences
- Positive: Less conditional code and simpler views/reducers.
- Negative: App no longer supports devices below iOS 26.
- Follow-ups: Audit remaining availability shims in new features.
