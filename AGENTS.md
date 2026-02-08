# AGENTS

These are mandatory engineering guardrails for this repo.

## Global Rules
- No test, no merge. All new behavior must be covered by tests.
- TDD is the default workflow for new features.
- All new features must be testable and include tests in the same change.
- CI must be green before merging (tests, lint, format, coverage).
- Definition of Done must be satisfied for every PR (see PR template).
- Changes that impact architecture require an ADR.

## Architecture Decision Records (ADR)
- Required when making an architectural change (module boundaries, data storage strategy, persistence model, dependency rules, significant build system changes).
- Store ADRs in `docs/adr/` using the template.
- One ADR per decision; short and explicit.

## Feature Descriptions
- Every new feature or task must include a description document in `docs/features/` using the template.
- The document must capture motivation and key decisions so future changes can be correlated with code history.

## Modularity
- Each feature is its own Swift Package with `Sources`, `Tests`, and `DemoApp` targets.
- Feature modules may depend on each other for now, but keep boundaries clean and APIs explicit.
- Public API must be minimal and documented.

## Testing
- Unit + integration tests for all logic-layer changes.
- Coverage is enforced per module (initial threshold: 80%).
- Prefer TCA TestStore patterns as documented by TCA.

## Dependencies
- All dependencies must be injected using TCA's `swift-dependencies` library.

## Tooling
- SwiftLint and SwiftFormat are required locally and in CI.
- CI runs on macOS only.
- Git hooks: `pre-commit` runs SwiftFormat and SwiftLint.

## PR Format
- PR descriptions must be valid Markdown with real newlines, not escaped `\\n` characters.
- Use sections: `Summary` and `Testing`.
