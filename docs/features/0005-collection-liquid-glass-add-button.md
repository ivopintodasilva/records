# Feature: Collection Liquid Glass Add Button

## Summary
- Add a bottom-left floating "liquid glass" add button to `CollectionView`, visually inspired by Apple Music's floating controls.

## Motivation
- Establish the primary entry point for adding records.
- Prepare UI affordance before wiring the upcoming serial-code scanning flow.

## Scope
- In scope
  - Add floating button UI in the collection screen.
  - Hook button tap to a dedicated reducer action.
  - Localize the button accessibility label.
- Out of scope
  - Serial/barcode scanning flow.
  - Persisting newly added records.
  - Any add-record form or modal.

## Decisions
- Use a bottom-left overlay anchored to safe-area insets to match expected placement.
- Use layered gradients, stroke, and shadow to approximate a liquid glass look while keeping compatibility with current deployment targets.
- Route taps through `CollectionFeature.Action.addRecordButtonTapped` so behavior can be expanded in follow-up work without view rewiring.

## Risks & Mitigations
- Risk: The visual style may diverge from final product direction.
- Mitigation: Keep styling encapsulated in a dedicated view helper for fast iteration.

## Testing
- Unit test verifies the add-button action is handled by the reducer.
- Existing state initialization test remains in place.
- Snapshot/UI tests are deferred.

## Follow-ups
- Present serial-code scanning flow on button tap.
- Tune spacing and visual tokens based on design review.
