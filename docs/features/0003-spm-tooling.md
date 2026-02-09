# Feature: SwiftPM Tooling

## Summary
- Run SwiftLint and SwiftFormat via SwiftPM plugins instead of local installs.

## Motivation
- Avoid per-machine tool installation.
- Align local and CI tooling versions.

## Scope
- In scope: SwiftLint/SwiftFormat plugin dependencies, scripts, CI updates.
- Out of scope: Other tooling (e.g., testing, coverage, build settings).

## Decisions
- Use SwiftLintPlugins and SwiftFormat SwiftPM packages.
- Invoke tooling through `swift package --package-path Packages/RecordsKit plugin ...` in scripts.

## Risks & Mitigations
- Risk: Plugin invocation differs from local binaries.
- Mitigation: Keep scripts as the single entry point and run them in CI.

## Testing
- Lint/format scripts should be run locally.
- No product tests added for tooling changes.

## Follow-ups
- Consider pinning tool versions via Renovate/Dependabot.
