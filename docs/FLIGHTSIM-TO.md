# Flightsim.to Release Plan

## Target listing

**Title:** Boeing 707-320C UNS-1 Community Patch

**Simulator:** Microsoft Flight Simulator 2024

**Category:** Aircraft Enhancements

**Affiliation / Base Product:** Microsoft Boeing 707-320C

**Release version:** 0.9.0-beta.1

**Pricing:** Freeware

## Short description

Reliability and correctness patch for the Working Title UNS-1 in the Microsoft Boeing 707-320C for MSFS 2024. Fixes confirmed navigation, PERF/FUEL, flight-plan, ETA, airway-selection, and display defects while preserving the existing UNS-1 interface.

## Full description

### Boeing 707-320C UNS-1 Community Patch

This is an unofficial community reliability and correctness patch for the Working Title UNS-1 flight-management system used by the Microsoft Boeing 707-320C in Microsoft Flight Simulator 2024.

The project focuses on narrow, source-supported fixes while preserving the aircraft's existing UNS-1 interface and familiar operating behavior.

### Current beta fixes

Version 0.9.0-beta.1 includes fixes for 16 audited findings:

- Navigation-sensor variance/ANP calculations using JavaScript bitwise XOR where exponentiation was required.
- Shared mutable position state between simulated navigation sensors.
- Incorrect active-GPS receiver numbering.
- PERF destination distance and derived predictions not updating continuously while the aircraft moves.
- FUEL destination distance and derived predictions not updating continuously while the aircraft moves.
- FUEL page recursive resume/navigation failure which could prevent reopening the page.
- Active-leg preservation when inserting at flight-plan index zero.
- Incorrect flight-plan batch closing token.
- Imported direct-to reconstruction using the wrong segment type.
- Airway-exit selection errors at page boundaries.
- ETA prediction anchoring to the computer's real-world date instead of simulator time.
- Pilot-waypoint automatic naming collisions.
- Stale asynchronous destination-facility results.
- Incorrect GPS-only message text.
- LDA approach labeling and runway validation errors.
- Legitimate zero values being treated as unavailable on PERF/FUEL pages.

### Validation status

The FUEL lifecycle fix and the live PERF/FUEL destination prediction fixes have been verified directly in MSFS 2024.

The other included fixes have passed targeted source-level and extracted-algorithm regression tests. Not every obscure edge case has yet been individually demonstrated in the simulator, which is why this release is labeled beta.

The cumulative patched target used for this release has SHA-256:

`E426D307E0F8765D6F247C50C30276B26C87BF7A53DD3A50F5892C9DCA60F791`

### Requirements

- Microsoft Flight Simulator 2024
- Microsoft Boeing 707-320C / Famous Flyer 10
- Working Title UNS-1 navigation option selected in the aircraft

This package is not for the Aeroplane Heaven Boeing 707 and is not intended for MSFS 2020.

### Installation

1. Close Microsoft Flight Simulator 2024.
2. Extract the included add-on folder directly into your MSFS 2024 Community folder.
3. Make sure the extracted add-on folder contains `manifest.json` and `layout.json` at its root.
4. Remove any older version of this UNS-1 patch before installing a new one.
5. Start MSFS 2024 and load the Microsoft Boeing 707-320C.

Do **not** install multiple Community packages which replace the same Boeing 707 UNS-1 JavaScript file at the same time.

### Uninstall

Close MSFS 2024 and remove the patch folder from the Community folder. No original simulator files are modified.

### Known limitations

- This release does not yet fix every item in the source audit.
- STAR/approach and SID transaction handling, waypoint insertion result propagation, and transactional route-import safety remain planned work.
- FPL waypoint ETA/ETE display is planned.
- The TUNE page remains unavailable in this release.
- Telemetry / waypoint fuel logging is planned but not included.

### Disclaimer

This is an unofficial community project and is not affiliated with or endorsed by Microsoft, Working Title, Boeing, iniBuilds, or Universal Avionics.

The project incorporates and modifies software distributed under Microsoft's applicable license for Microsoft Flight Simulator derivatives. The required license and notices are included in the package.

## Flightsim.to upload checklist

- [ ] Freeze the tested Community-package ZIP for 0.9.0-beta.1.
- [ ] Verify package root contains `manifest.json` and `layout.json`.
- [ ] Confirm the package loads with only this override installed.
- [ ] Verify cumulative target SHA-256.
- [ ] Confirm license/provenance for every redistributed file in the ZIP.
- [ ] Scan the final ZIP with VirusTotal and obtain zero detections.
- [ ] Capture at least two in-simulator screenshots, minimum 512x512.
- [ ] Include one screenshot clearly showing the UNS-1 in the Boeing 707 cockpit.
- [ ] Include a second screenshot showing a patched functional page (PERF or FUEL preferred).
- [ ] Upload ZIP directly to Flightsim.to; do not make GitHub an essential download dependency.
- [ ] Select Aircraft Enhancements.
- [ ] Select affiliation Microsoft Boeing 707-320C.
- [ ] Select MSFS 2024 only.
- [ ] Set version to 0.9.0-beta.1.
- [ ] Paste the self-contained description above.
- [ ] Review the listing before submission.

## Updating

Future versions must update the existing Flightsim.to listing rather than creating a new listing for each release. Keep Flightsim.to version numbers synchronized with GitHub releases.
