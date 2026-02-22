# ADR 0002: Move RecordsKit To iOS-Only (iOS 26 Baseline)

## Status
- Accepted

## Context
- The project currently includes macOS compatibility branches and runtime availability checks that increase UI complexity.
- The active product direction is iOS-first, and new UI work depends on iOS 26 glass APIs (`buttonStyle(.glass)`, `glassEffect`).
- Maintaining multi-platform compatibility adds implementation overhead and slows feature iteration for current goals.

## Decision
- Set `RecordsKit` platform support to iOS only with minimum deployment target iOS 26.
- Remove macOS-specific and iOS runtime-availability branching from `CollectionView`.
- Adopt glass APIs directly for bottom controls without fallback code paths.

## Consequences
- Positive
  - Simpler and more readable UI code.
  - Native usage of iOS 26 interaction and visual APIs.
  - Less platform-conditional testing and maintenance.
- Negative
  - `RecordsKit` no longer supports macOS builds.
  - Existing macOS-oriented workflows/tests must be replaced with iOS-focused build/test flows.
- Follow-ups
  - Update CI build/test jobs to run against iOS simulator destinations only.
  - Audit remaining features for residual platform-conditional code and remove as needed.
