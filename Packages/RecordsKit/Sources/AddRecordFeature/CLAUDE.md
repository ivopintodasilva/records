# AddRecordFeature

## Responsibilities
- Barcode scanning
- Record lookup using barcode

## Steps
1. Present scanner UI
2. Handle scan events
3. Perform barcode lookup
4. Emit `.delegate(.didResolveRecord(Record))` actions to be handled by parent modules

## Module-specific context
- Lookup strategy: MusicBrainz API (Discogs planned).
