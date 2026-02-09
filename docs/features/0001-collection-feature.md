# Feature: CollectionFeature

## Summary
- A minimal collection list feature with add capability and a basic list UI.

## Motivation
- Establish the first feature and testing patterns.
- Prove the TCA + swift-dependencies baseline in a real module.

## Scope
- In scope
  - Add records by title
  - List existing records
- Out of scope
  - Persistent storage
  - Barcode scanning
  - Sharing

## Decisions
- The feature is a target inside the `RecordsKit` package with `Sources`, `Tests`, and `DemoApps`.
- Dependencies are injected using `swift-dependencies`.
- UI is included in the feature target for now.

## Risks & Mitigations
- Risk: Demo app is not wired into a runnable Xcode target yet.
- Mitigation: Provide a demo app entry file and instructions for wiring.

## Testing
- Unit/integration tests cover add behavior and empty input handling.
- UI tests are deferred.

## Follow-ups
- Wire the demo app into a dedicated Xcode target.
- Add persistence once the data model stabilizes.
