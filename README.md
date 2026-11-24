# WTB707 UNS-1 Community Patch

An unofficial community reliability and completeness patch for the Working Title UNS-1 implementation used by the Microsoft Flight Simulator 2024 Boeing 707-320C.

The project focuses on correcting confirmed source defects, improving reliability, and completing selected high-value unfinished functionality while preserving the existing UNS-1 interface and familiar aircraft behavior.

## Current status

The current development baseline is the 16-finding cumulative patch tested against the shipped Boeing 707 UNS-1 implementation (WT2.2.4).

Current cumulative patched-file SHA-256:

`E426D307E0F8765D6F247C50C30276B26C87BF7A53DD3A50F5892C9DCA60F791`

Actual simulator target:

`html_ui/Pages/VCockpit/Instruments/Airliners/WTB707/WTUns1v2/WTUns1.js`

### Included audit IDs

`A01 A02 A03 A04 A05 A06 A10 A11 A13 A14 A15 A16 A19 A25 A26 A27`

### Simulator-confirmed fixes

- **A06** — FUEL page lifecycle / recursive resume navigation.
- **A04** — PERF destination prediction distance updates while aircraft moves.
- **A05** — FUEL destination prediction distance updates while aircraft moves.

The remaining included fixes have passed source-level and extracted-algorithm regression tests; not every edge case has been individually demonstrated in the simulator yet.

## Why this project exists

The project began with a severe, reproducible **FUEL-page lockout** in the shipped Boeing 707 UNS-1. After fuel/weight initialization, leaving the FUEL page and attempting to return to it could trigger recursive page navigation until the JavaScript call stack overflowed, effectively making the FUEL page unusable for the rest of the session. Coherent GT confirmed the failure with `RangeError: Maximum call stack size exceeded`. The root cause was navigation being triggered from the FUEL page's `onResume()` lifecycle handler before the requested subpage state had been committed, causing `onResume → navigateTo → resume → onResume` recursion. **A06 removes that recursive navigation path.** In simulator testing, FUEL can now be reopened repeatedly — including NAV → FUEL → NAV → FUEL — without the stack overflow returning.

That confirmed failure led to a broader source audit, which found a mixture of additional deterministic defects, lifecycle bugs, indexing errors, async flight-plan risks, stale reactive dependencies, incomplete UI functions, and unfinished features.

One especially clear example is repeated use of JavaScript's bitwise XOR operator (`^`) in position-variance / ANP formulas where mathematical exponentiation (`**`) is required. The defect exists in the public source lineage and remained present in the newer shipped Boeing 707 implementation.

See [`docs/AUDIT.md`](docs/AUDIT.md) and [`docs/AUDIT-STATUS.csv`](docs/AUDIT-STATUS.csv) for the full engineering record.

## Validation terminology

This project deliberately distinguishes:

- **Source-confirmed** — deterministic defect established from code inspection.
- **Offline-tested** — exact source transformation and/or extracted algorithm regression test passed.
- **Simulator-tested** — behavior demonstrated in MSFS 2024.
- **Research** — integration boundary or suspected behavior not yet established as a defect.

Passing an offline test is not represented as simulator validation.

## Development direction

Near-term work includes:

- A07 — serialize STAR/approach insertion and propagate failure.
- A08 — serialize SID insertion and propagate failure.
- A09 — make waypoint insertion UI reflect the actual insertion result.
- A12 — make route import transactional / rollback-safe.
- A21 — display per-waypoint ETA/ETE on the FPL page using the existing predictor.

Longer-term candidate features include completing the original TUNE radio-management concept and event-driven flight telemetry/logging.

## Project keywords

`msfs-2024` · `microsoft-flight-simulator` · `boeing-707` · `boeing-707-320c` · `uns-1` · `universal-avionics` · `working-title` · `flight-management-system` · `avionics` · `aircraft-enhancement` · `community-patch` · `flight-simulator-addon`

## Installation

A one-step Community-folder release package will be provided through GitHub Releases after the initial public beta is frozen and reviewed.

Do not install multiple packages which replace the same `WTUns1.js` file at the same time.

## Source provenance

The public source basis is Microsoft's `msfs-avionics-mirror`. The shipped MSFS 2024 Boeing 707 instrument is newer than the public source and must be treated as a separate integration target during validation.

The actual 707 instrument path is under `Airliners/WTB707`, not the generic `NavSystems/WTUns1v2` path.

## License

See [`LICENSE`](LICENSE). The Microsoft source license is MIT with an addendum restricting the software and derivative works to use in Microsoft Flight Simulator.

## Disclaimer

This project is unofficial and is not affiliated with or endorsed by Microsoft, Working Title, Boeing, or Universal Avionics. Use at your own risk.
