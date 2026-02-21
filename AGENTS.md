# AGENTS

These are mandatory engineering guardrails for this repo.

## Global Rules
- All new features must be testable in the same change.
- CI must be green before merging (tests, lint, format, coverage).
- Changes that impact architecture require an ADR.

## Architecture Decision Records (ADR)
- Required when making an architectural change (module boundaries, data storage strategy, persistence model, dependency rules, significant build system changes).
- Store ADRs in `docs/adr/` using the template in docs/adr/0000-template.md.
- One ADR per decision; short and explicit.

## Feature Descriptions
- Every new feature or task must include a description document in `docs/features/` using the template in docs/features/0000-template.md.
- The document must capture motivation and key decisions so future changes can be correlated with code history.

## Modularity
- All features live as targets inside the single `RecordsKit` Swift package.
- Each feature has `Sources`, `Tests`, and a `DemoApp` folder.
- Split stores and views into separate files:
  - `*Feature.swift` holds reducer/state/action logic.
  - `*View.swift` holds SwiftUI views.
- View types drop the `Feature` suffix. Examples:
  - `AppFeature` -> `AppView`
  - `CollectionFeature` -> `CollectionView`
  - `DetailFeature` -> `DetailView`
- Feature modules may depend on each other for now, but keep boundaries clean and APIs explicit.
- Public API must be minimal and documented.
- Naming conventions:
  - Feature modules must end with `Feature`.
  - Stateful services must end with `Service`.
  - Stateless clients must end with `Client`.
- Use `/Users/ivo/Projects/records/scripts/new-feature.sh` to scaffold new feature targets inside `RecordsKit`.

## Testing
- Prepare a list of relevant tests for all new features and confirm test plan before implementing them.
- Use testing patterns as documented in: https://swiftpackageindex.com/pointfreeco/swift-composable-architecture/main/documentation/composablearchitecture/testingtca.
- Never commit or push code that has not been built and tested (at least the affected targets).

## Dependencies
- All dependencies must be injected using TCA's `swift-dependencies` library.

## Tooling
- CI runs on macOS only.
- Git hooks: `pre-commit` runs SwiftGen, SwiftFormat, and SwiftLint.
- During normal implementation, do not run SwiftFormat/SwiftLint after every small edit; rely on `pre-commit` as the default style/lint gate.
- Build and run relevant tests before pushing, even when relying on pre-commit for format/lint.

## Swift
- Always avoid force-unwrapping optional types.

## Localization
- All user-facing strings must be localized. Do not hardcode UI text in feature/source files.
- SwiftGen is used to generate type-safe string accessors from localization resources.
- Localization resources live in `/Users/ivo/Projects/records/Packages/RecordsKit/Sources/Localization/Resources/`.
- Generated accessors live in `/Users/ivo/Projects/records/Packages/RecordsKit/Sources/Localization/Generated/L10n.generated.swift`.
- Use generated `L10n` symbols in code (for example `L10n.Collection.Navigation.title`) instead of raw string keys.
- When adding or changing strings:
  1. Update all relevant `.strings` resource file.
  2. Run `/Users/ivo/Projects/records/scripts/swiftgen.sh`.
  3. Ensure generated changes are included in the commit.
  4. Let `pre-commit` run formatting/linting before commit.

## PR Format
- PR descriptions must be valid Markdown.
- Use sections: `Summary` and `Testing`.

## Git Hygiene
- Never commit directly on `main`. Always create a `codex/*` branch first.
- Always build and run relevant tests before committing or pushing.
- Always start a new feature on its own branch.
- New branches should always originate from the latest `main` branch.
- Required preflight before starting any code changes:
  1. `git checkout main`
  2. `git pull --ff-only origin main`
  3. `git checkout -b codex/<feature-name>`
- Do not reuse an existing local `codex/*` branch for new work.
- Verification is mandatory immediately after branch creation:
  - `git merge-base --is-ancestor main HEAD` must succeed.
  - `git rev-parse main` and `git rev-parse HEAD~0` should match at branch start (before new commits).
