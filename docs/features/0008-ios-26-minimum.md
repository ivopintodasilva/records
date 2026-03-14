# Feature: iOS 26 Minimum Baseline

## Summary
- Raise the app and package minimum deployment target to iOS 26 and simplify code paths accordingly.

## Motivation
- Reduce complexity by removing availability checks for APIs that are guaranteed by the new baseline.
- Keep platform requirements aligned with the product direction and supported device set.

## Scope
- In scope
- Update deployment targets to iOS 26.0 in the app.
- Remove `#available(iOS ...)` checks related to the previous lower baseline.
- Out of scope
- Any additional feature changes or UI adjustments beyond the baseline update.

## Decisions
- Keep the app iOS-only and align deployment targets in the Xcode project.
- Retain a macOS 13 entry in the SPM manifest to keep SwiftPM-based tooling working.
- Prefer static imports and straightforward feature rendering over gated availability branches.

## Risks & Mitigations
- Risk
- Users on iOS versions below 26 cannot run the app.
- Mitigation
- Product explicitly targets iOS 26+ devices; communicate this baseline in release notes.

## Testing
- What tests are required?
- Build the `records` scheme for an iOS 26 simulator.
- What is not tested (and why)?
- No automated tests were added; change is configuration and availability cleanup only.

## Follow-ups
- None.
