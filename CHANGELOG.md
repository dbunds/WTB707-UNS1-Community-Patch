# Changelog

## v0.1.0 — 2026-11-25 (initial public beta; package 0.0.4)

### Fixed (16 audit IDs)

- A01: use exponentiation instead of bitwise XOR in navigation sensor accuracy formulas.
- A02: independent radio/GPS sensor position objects.
- A03: correct selected GPS receiver index.
- A04: live PERF destination distance updates.
- A05: live FUEL destination distance updates.
- A06 v2: remove recursive FUEL page resume navigation; select page 2 after valid passenger and cargo entries, including zero. Preserve manual paging.
- A10: active-leg preservation for insertion at index zero.
- A11: correct flight-plan batch close token.
- A13: imported direct-to enroute segment lookup.
- A14: airway exit selection page index and boundary handling.
- A15: ETA anchored to simulator clock.
- A16: first available unique pilot waypoint suffix.
- A19: reject stale async destination facility result.
- A25: correct GPS-only navigation message text (message ordering/deduplication not addressed).
- A26: correct LDA label and runway-number validation.
- A27: selected zero-value PERF/FUEL calculations and displays.

### Validation

A04, A05 and A06 have direct simulator evidence; the cumulative build passed maintainer flight testing. Other individual edge cases remain to be verified. New local hash-gated installer recreates the tested instrument without distributing the full shipped bundle; Windows installer execution is pending.

### Known limitations

Brief FUEL page 1 flash before page 2 is cosmetic. No rendering change, weight-default change, VNAV implementation or STAR/SID transaction redesign included.

## Planned

A07, A08, A09, A12, A21 and remaining findings as documented in the audit. No release commitment.
