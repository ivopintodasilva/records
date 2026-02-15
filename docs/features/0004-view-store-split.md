# Feature: View/Store Split

## Summary
- Split each feature into separate store and view files.

## Motivation
- Keep reducer logic focused and UI code isolated.
- Improve navigation and readability as features grow.

## Scope
- In scope: AppFeature and CollectionFeature split; scaffolding update; repo rules update.
- Out of scope: UI redesign or behavior changes.

## Decisions
- `*Feature.swift` for store/reducer logic.
- `*View.swift` for SwiftUI views.

## Risks & Mitigations
- Risk: More files to manage per feature.
- Mitigation: Update scaffolding to generate both files.

## Testing
- Lint + format + build.
- No behavior changes.

## Follow-ups
- Apply the split to future features via the scaffold.
