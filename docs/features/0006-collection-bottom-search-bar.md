# Feature: Collection Bottom Search Bar

## Summary
- Add an iOS-native floating search bar beside the bottom glass add button in `CollectionView`.

## Motivation
- Match the Apple Music-style bottom control strip interaction.
- Provide immediate in-view filtering of displayed records.

## Scope
- In scope
  - Add a bottom search bar UI next to the existing add button.
  - Filter records by album title or artist while typing.
  - When search is focused, change the add button icon from `+` to `x`.
- Out of scope
  - Persisting search state.
  - Adding records from search interactions.
  - Backend or scanner integration.

## Decisions
- Use local view state (`searchQuery`, focus state) because this is ephemeral UI-only behavior.
- Keep reducer behavior unchanged; only existing add-button action is dispatched when search is not focused.
- Apply glass styling to the search capsule on supported iOS versions, with fallback styling for older OS versions.

## Risks & Mitigations
- Risk: Bottom controls can overlap content visually.
- Mitigation: Keep controls in overlay with consistent bottom padding and compact fixed height.

## Testing
- Existing reducer tests remain valid.
- Manual UI verification required for:
  - Focus state swap (`+` -> `x`)
  - Search filtering behavior
  - Styling parity across supported OS versions

## Follow-ups
- Hook `addRecordButtonTapped` to scanner presentation flow.
- Add UI tests for focus-toggle and filter behavior.
