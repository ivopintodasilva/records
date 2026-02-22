# Feature: AddRecordFeature Barcode Scan and Lookup

## Summary
- Build a single `AddRecordFeature` responsible for scanning a barcode and resolving record metadata.
- On success, emit a delegate action so `CollectionFeature` can append the new `Record`.

## Motivation
- Keep `CollectionFeature` focused on display and collection state ownership.
- Isolate add/scan flow into one feature with clear boundaries and testable behavior.
- Enable incremental delivery: UI and flow first, metadata quality improvements after.

## Scope
- In scope
- Create `AddRecordFeature` (state, actions, reducer, view).
- Present barcode scanner UI from `AddRecordFeature`.
- Add `BarcodeScannerClient` integration to return scanned code.
- Add `RecordLookupClient` abstraction and implementation strategy.
- Delegate resolved `Record` back to `CollectionFeature`.
- Add tests for reducer logic and integration boundaries.

- Out of scope
- Advanced deduplication and merge rules.
- Offline caching/sync.
- Rich error recovery UX beyond basic retry/cancel.
- Multi-market metadata reconciliation heuristics.

## Decisions
- Single feature: scanner + lookup stay inside `AddRecordFeature`.
- Data handoff uses delegate action:
  - `.delegate(.didResolveRecord(Record))`
- `CollectionFeature` remains source of truth for current in-memory record list.
- External lookup order:
  1. Discogs (primary)
  2. MusicBrainz (fallback)
  3. Failure state if unresolved
- All business logic remains in reducers/clients, not views.

## Ordered Plan (Priority)
1. Architecture and contracts (highest priority)
- Scaffold `AddRecordFeature` target with `Sources`, `Tests`, `DemoApp`.
- Define state machine for add flow:
  - idle -> scanning -> lookingUp -> success/failure
- Define delegate contract:
  - `AddRecordFeature.Action.delegate(DelegateAction)`
  - `DelegateAction.didResolveRecord(Record)`
- Define client interfaces:
  - `BarcodeScannerClient.scan() async throws -> String`
  - `RecordLookupClient.lookup(barcode: String) async throws -> Record`

2. Collection integration
- Wire presentation from `CollectionFeature` to `AddRecordFeature`.
- Handle delegate action in `CollectionFeature` and append record.
- Keep ownership of collection array in `CollectionFeature` only.

3. Scanner implementation path
- Add scanner screen/controller bridge inside `AddRecordFeature`.
- Map scanner output into reducer action (`barcodeScanned(String)`).
- Add cancellation/close handling.

4. Metadata lookup and mapping
- Implement `RecordLookupClient` with provider chain:
  - Discogs query by barcode.
  - MusicBrainz fallback query by barcode.
- Normalize provider payloads into internal `Record` model.
- Handle partial metadata (missing cover/title/artist) with safe defaults.

5. UX states and localization
- Add loading, not found, and request failure states.
- Add localized strings for all add/scan UI text.
- Keep current UI minimal; no heavy filtering/sorting changes.

6. Testing and quality gates
- Reducer tests:
  - start scan
  - scan success -> lookup start
  - lookup success -> delegate emission
  - lookup failure -> error state
  - cancel flow
- Client tests:
  - provider fallback behavior
  - mapping of representative payloads
- Build and run affected tests before push.

7. Hardening follow-ups (lower priority)
- Duplicate detection policy in `CollectionFeature`.
- Better retry guidance and user-facing error classification.
- Add telemetry hooks for scan/lookup success rate.

## Risks & Mitigations
- Risk
- External API reliability/rate limits.
- Mitigation
- Provider fallback chain, timeout policy, and resilient error mapping.

- Risk
- Inconsistent barcode coverage across providers.
- Mitigation
- Fallback to alternate provider and explicit not-found UX.

- Risk
- Leaking business logic into view layer.
- Mitigation
- Enforce reducer/client-only logic and keep views declarative.

## Testing
- What tests are required?
- `AddRecordFeatureTests` for flow transitions and delegate behavior.
- `CollectionFeatureTests` for delegate handling and append behavior.
- `RecordLookupClientTests` for fallback and mapping cases.

- What is not tested (and why)?
- Real external API end-to-end calls in CI are excluded due to network instability and credentials.

## Follow-ups
- Introduce persistent collection storage and move from in-memory list to shared data layer.
- Revisit lookup ranking/selection when multiple release matches are returned.
- Expand metadata fields (label, year, format, catalog number) after initial flow is stable.
