# Changelog

All notable project changes will be documented here.

## [Unreleased]

### Planned
- A07 STAR/approach async insertion reliability.
- A08 SID async insertion reliability.
- A09 waypoint insertion result propagation.
- A12 transactional route import.
- A21 FPL ETA/ETE display.

## [0.9.0-beta.1] - Initial release candidate

### Fixed
- A01 navigation sensor exponentiation/XOR errors.
- A02 shared mutable navigation sensor origin.
- A03 active GPS receiver double increment.
- A04 PERF destination prediction stale distance.
- A05 FUEL destination prediction stale distance.
- A06 FUEL page recursive lifecycle/navigation failure.
- A10 active-leg preservation when insertion index is zero.
- A11 incorrect flight-plan batch close token.
- A13 imported direct-to reconstruction segment lookup.
- A14 airway exit page-boundary/index handling.
- A15 waypoint ETA simulator-date anchoring.
- A16 pilot waypoint first-free suffix naming.
- A19 stale asynchronous destination-facility result.
- A25 GPS-only message text.
- A26 LDA label and runway validation.
- A27 zero-value PERF/FUEL formatting cases.

### Validation
- A04, A05, A06 simulator-tested.
- Remaining included items offline-tested with exact source transformation and extracted-algorithm regression checks.
