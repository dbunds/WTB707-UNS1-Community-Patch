# WTB707 UNS-1 Community Patch

An unofficial, free reliability patch for the Working Title UNS-1 flight management system in the Microsoft Flight Simulator 2024 Boeing 707-320C.

## v0.1.0 — initial public beta (instrument build 0.0.4)

The maintainer has completed ground and extended flight testing of the cumulative 16-fix build. The primary FUEL-page defect is corrected and the original automatic page selection is restored.

### Install

Follow the [installation guide](docs/INSTALLATION.md). The [PowerShell installer](Install-UNS1.ps1) generates a separate Community package from your own compatible stock 707 instrument. No original simulator files are modified. The installer checks the source and resulting SHA-256 and refuses unknown versions.

**Windows PC, MSFS 2024 Boeing 707-320C only.** Not for MSFS 2020, other aircraft, or real-world aviation. The installer itself is a new distribution mechanism and has not yet been executed on Windows; the resulting instrument bytes are the flight-tested target.

### What this fixes

- FUEL page lockout after entering passenger and cargo weights: FUEL opens page 1 until both entries are valid, then page 2 on subsequent requests; zero is valid. PREV/NEXT remain available.
- PERF and FUEL destination distance and dependent predictions now update as the aircraft moves.
- Navigation sensor accuracy formulas, independent sensor positions, and selected GPS receiver indication.
- Flight-plan insertion at index zero, batch close token, imported direct-to segment selection, airway exit selection.
- Simulator-clock ETA anchoring, unique pilot waypoint names, stale destination lookup results, GPS-only message, LDA approach label/runway validation and selected zero-value PERF/FUEL calculations.

See the [changelog](CHANGELOG.md), [validation record](docs/VALIDATION.md), [audit](docs/AUDIT.md) and [finding status](docs/AUDIT-STATUS.csv) for details. A04, A05 and A06 have direct simulator evidence; other included corrections were offline-tested and exercised in the cumulative flight test, not individually proven in every edge case.

### Known limitations

A brief FUEL page 1 flash may occur before page 2 is displayed; it is cosmetic and intentionally unchanged. VNAV, radio tuning, stored routes, STAR/SID transaction reliability and other unimplemented features are outside this release. Do not assume this patch resolves all fuel prediction or aircraft-system issues.

### Why this project exists

A repeatable FUEL-page lockout was traced to recursive navigation from the page's own resume callback, producing a JavaScript stack overflow. The fix removes that reentrant call and chooses the entry page before navigation. A wider audit of the public UNS-1 source then identified 30 engineering work items, including confirmed defects, unfinished features and research topics. This release addresses 16 audit IDs, some only in part.

### Compatibility and source provenance

The tested aircraft-specific file is `html_ui/Pages/VCockpit/Instruments/Airliners/WTB707/WTUns1v2/WTUns1.js`. The installer accepts only the known stock WT2.2.4 file hash and produces the exact validated instrument hash listed in the installation guide. Do not use multiple overrides simultaneously. Remove the patch and re-check compatibility after simulator updates.

The public source lineage is [Microsoft's avionics mirror](https://github.com/microsoft/msfs-avionics-mirror). The shipped instrument is newer; this repository distributes local transformations rather than the complete shipped compiled file. See [redistribution policy](docs/REDISTRIBUTION.md), [LICENSE](LICENSE) and [NOTICE](NOTICE.md).

Report problems through [GitHub Issues](https://github.com/dbunds/WTB707-UNS1-Community-Patch/issues), including simulator version, patch hash, reproducible steps, expected/actual behavior, and relevant logs (remove personal paths).

Unofficial; not endorsed by Microsoft, Working Title, Boeing or Universal Avionics. For simulation only. No warranty.
