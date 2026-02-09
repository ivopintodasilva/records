# Feature: AppFeature

## Summary
- Introduce a single app-level feature that composes the root UI.

## Motivation
- Ensure the main app imports only `AppFeature` and keeps feature composition centralized.

## Scope
- In scope
  - Add `AppFeature` target in `RecordsKit`
  - Compose `CollectionFeature` inside `AppFeature`
  - Update app to render `AppFeatureRootView`
- Out of scope
  - Navigation or multi-feature routing

## Decisions
- App target depends only on the `RecordsKit` package and imports `AppFeature`.
- `AppFeature` exposes `AppFeatureRootView` for the app to render without importing TCA.

## Risks & Mitigations
- Risk: App-level composition becomes a bottleneck.
- Mitigation: Keep `AppFeature` small; add child features via scoped reducers.

## Testing
- Unit test validates initial state composition.

## Follow-ups
- Add navigation scaffolding when more features are introduced.
