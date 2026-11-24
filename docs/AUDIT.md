# Working Title UNS-1Lw 2.1.11 — Published-Source Audit
**Date:** 23 November 2026  
**Purpose:** baseline source audit for public UNS-1 Advanced MSFS 2024 fork.  
**Primary input:** user-supplied `msfs-avionics-mirror-main.zip`, a copy of the publicly published Microsoft repository (May 2026).
**Scope / limitations:** Static source inspection across all 90 TypeScript/TSX/configuration/web files, with detailed traces through key navigation, position, route-editing, arrival, performance, predictions, messages, and lifecycle paths, and cross-checks against published Microsoft SDK implementations for `GeoPoint.offset`, core prediction time and flight-plan batch handling. No edits to source; **no build, instrumented tests, or flight-test results** in this audit. Findings are **not** claims about what was changed in any later MSFS binary release. Source supports a defect or suspicion, but operational severity requires testing. This is an actionable first comprehensive pass, not a proof that every execution path is defect-free.

## Executive assessment
- Reviewed inventory: **90 files; 28,099 source/configuration lines** in the UNS-1 project (excluding four non-code assets and separate shared SDK).
- Registered **30 findings / engineering work items**: HIGH: 10, LOW: 6, MEDIUM: 12, RESEARCH: 2. Items include already known issues, new defects, intentionally unfinished features and integration research; **do not interpret all 30 as confirmed runtime bugs**.
- Best-supported new defects: bitwise XOR in ANP math; mutating reference position across sensors; wrong GPS receiver number; airway typed-selection indexing; mixing simulation and real-world time in predicted ETAs; duplicate-prone pilot waypoint names.
- Important pilot-observed problems: cannot reopen FUEL after setup; PERF DIST frozen until page change; STAR/approach selection apparently accepted but not inserted mid-flight. Reproducible observations are real; proposed code-level causes still need targeted build/run validation.
- Original design remains sound. Recommendation: fix reliability and correctness with small tests and minimal UI changes; do not alter traditional UNS-1 insertion or menu semantics.

## Source coverage by area
| Area | Files scanned |
|---|---:|
| Aircraft configuration | 6 |
| Application and packaging | 9 |
| Autopilot integration | 3 |
| CDU editing controls | 6 |
| CDU lifecycle and navigation | 7 |
| CDU operating pages | 29 |
| Core FMS and prediction | 9 |
| Fuel and performance instruments | 3 |
| Messages and alerts | 3 |
| Navigation, positioning and steering | 11 |
| Route import/export/synchronization | 3 |
| Settings | 1 |

### Evidence terminology
**Confirmed source defect** = deterministic code error or evident mismatch with library contract. **Confirmed design/handling weakness** = source allows silent failure, stale data, or unprotected mutation, but in-sim manifestation not yet proven. **High-confidence suspected runtime cause** = source strongly matches pilot-observed behavior, requires execution confirmation. **Incomplete** = deliberately missing feature, not necessarily a defect. **Research** = interface or integration limit unconfirmed by public artifacts.

## Findings register
### A01 — Navigation sensor accuracy (HIGH)
**Classification:** Confirmed source defect  
**Source:** `Fms/Navigation/UnsPositionSystems.ts`, lines 278-279, 335-337, 398-402.
**Evidence / effect:** Uses JavaScript bitwise XOR (^) instead of exponentiation (**) in several position-variance and ANP formulas.
**Proposed remedy:** Replace ^ with **, add numerical unit tests against published reference equations.
**Regression test:** Station range sweep and sensor-accuracy/ANP display checks.

### A02 — Navigation sensor state (HIGH)
**Classification:** Confirmed source defect  
**Source:** `Fms/Navigation/UnsPositionSystems.ts`, lines 250-258, 464-479, 570-593.
**Evidence / effect:** Uses mutating GeoPoint.offset() on a shared origin passed to several GPS/VOR/DME sensor simulators; later sensors inherit prior noise.
**Proposed remedy:** Copy position before offset or supply a separate GeoPoint output.
**Regression test:** Check original input unchanged and independent sensor outputs; no unexplained accumulation.

### A03 — GPS source indication (MEDIUM)
**Classification:** Confirmed source defect  
**Source:** `Fms/Navigation/UnsPositionSystems.ts`, lines 587-601.
**Evidence / effect:** GPS receiver selection is assigned index+1 but publication adds 1 again.
**Proposed remedy:** Publish activeGps without another increment; define behavior when none are valid.
**Regression test:** Force each receiver as best ANP and verify displayed ID.

### A04 — PERF destination predictions (HIGH)
**Classification:** Confirmed source defect  
**Source:** `CduDisplay/Pages/UnsPerfPage.ts`, lines 36-45, 75-85.
**Evidence / effect:** DIST depends only on destinationFacility although it imperatively reads continuously changing pposSub; ETE and fuel/weight/endurance/range predictions inherit stale DIST.
**Proposed remedy:** Map destinationFacility and pposSub together; use robust null and zero handling.
**Regression test:** Keep PERF open in flight: DIST and derived predictions change without navigation.

### A05 — FUEL destination predictions (HIGH)
**Classification:** Confirmed source defect  
**Source:** `CduDisplay/Pages/UnsFuelPage.ts`, lines 49-65, 106-151.
**Evidence / effect:** Same stale-DIST dependency as PERF; can distort predicted arrival fuel.
**Proposed remedy:** Reuse shared validated distance/prediction service with position dependency.
**Regression test:** Keep FUEL page open: DIST and derived values recalculate.

### A06 — FUEL page lifecycle (HIGH)
**Classification:** High-confidence suspected runtime cause  
**Source:** `CduDisplay/Pages/UnsFuelPage.ts`, lines 255-259.
**Evidence / effect:** onResume() triggers screen.navigateTo(/fuel#2) depending on current index, potentially reentering navigation. Reproduced symptom: cannot reopen after fuel initialization.
**Proposed remedy:** Remove navigation from onResume; implement a non-recursive post-resume default subpage selection.
**Regression test:** Initialize FUEL, leave, return repeatedly from NAV, PERF and FPL.

### A07 — STAR/approach insertion (HIGH)
**Classification:** Confirmed design/handling defect  
**Source:** `CduDisplay/Pages/UnsArrivalPage.ts`, lines 165-229, 382-432, 674-685.
**Evidence / effect:** Async plan changes are fired without awaiting; selections can launch overlapping edits and ignore insertArrival/insertApproach boolean failure.
**Proposed remedy:** Serialize edits, await completion, verify active plan and display error on failure.
**Regression test:** Ground and airborne STAR/approach entry, rapid transition changes.

### A08 — SID insertion (HIGH)
**Classification:** Confirmed design/handling defect  
**Source:** `CduDisplay/Pages/UnsDeparturePage.ts`, lines Selection/modification handlers.
**Evidence / effect:** Similar nonserialized asynchronous procedure editing pattern to ARRIVAL; inspect exact event chain before patch.
**Proposed remedy:** Use common flight-plan-edit transaction layer for SID and STAR, with completion and rollback.
**Regression test:** Rapid SID/runway/transition changes and in-flight reprogramming.

### A09 — Waypoint insertion UI (HIGH)
**Classification:** Confirmed source defect  
**Source:** `CduDisplay/Pages/UnsFplPage.ts`, lines 533-547, 835-843.
**Evidence / effect:** Insertion return status discarded; UI handlers return success without confirming new leg exists.
**Proposed remedy:** Return/await real result and validate resulting flight-plan leg.
**Regression test:** Insert duplicate, invalid, airway, beginning and active-plan waypoints.

### A10 — Active-leg preservation (HIGH)
**Classification:** Confirmed source defect, runtime effect untested  
**Source:** `Fms/UnsFms.ts`, lines 3596-3628.
**Evidence / effect:** The condition (index && ...) fails when index is zero, potentially bypassing preservation of the active target after an insertion.
**Proposed remedy:** Use index !== undefined and identify active leg by stable reference when possible.
**Regression test:** Insert at index 0 before active waypoint while LNAV active; verify target unchanged.

### A11 — Flight-plan batch management (MEDIUM)
**Classification:** Confirmed source defect  
**Source:** `Fms/UnsFms.ts`, lines 811-846.
**Evidence / effect:** An early rejection closes a batch using a constructed string instead of the UUID returned by openBatch.
**Proposed remedy:** Close using returned identifier and wrap mutation in try/finally.
**Regression test:** Repeated failed inserts followed by successful modifications; inspect batch notifications.

### A12 — Route import/EFB (HIGH)
**Classification:** Confirmed data-loss risk  
**Source:** `Fms/Route/UnsFlightPlanRouteLoader.ts`, lines ~110-265.
**Evidence / effect:** Active plan is cleared before all imported components are validated; failures can leave a partial plan; some missing data are logged only.
**Proposed remedy:** Stage/validate a candidate plan and commit transactionally or restore prior plan on failure.
**Regression test:** Inject missing facility/airway, abort mid-import; preserve existing active route.

### A13 — Imported direct-to (MEDIUM)
**Classification:** Confirmed source defect  
**Source:** `Fms/Route/UnsFlightPlanRouteLoader.ts`, lines 227-245.
**Evidence / effect:** Code comment says last enroute segment but searches segmentsOfType(Approach) while reconstructing imported direct-to.
**Proposed remedy:** Use correct Enroute type, then verify DTO reconstruction semantics.
**Regression test:** EFB route import containing PPOS/direct-to with approach present and absent.

### A14 — Airway exit selection (MEDIUM)
**Classification:** Confirmed source defect  
**Source:** `CduDisplay/Pages/UnsNormalListPage.ts`, lines 293-305, 626-670.
**Evidence / effect:** Global index modulo 12 rejects zero remainders (including first on each 12-item page); selection occurs relative to current page with no page-bound check.
**Proposed remedy:** Find absolute match, validate page membership, convert to 1-based page-local index; verify inserted airway.
**Regression test:** Select first/last airway exit on each page by ident and number.

### A15 — Waypoint ETA date (MEDIUM)
**Classification:** Confirmed source defect  
**Source:** `Fms/UnsFlightPlanPredictor.ts`, lines 128-143.
**Evidence / effect:** Wrapper anchors ETA to computer real-world midnight via Date.now(); core published SDK predictor supplies simulator UTC seconds-of-day.
**Proposed remedy:** Use simulator clock to construct day anchor; define day rollover.
**Regression test:** Simulator date unlike OS date; midnight crossing, acceleration and replay.

### A16 — Custom/pilot waypoints (MEDIUM)
**Classification:** Confirmed source defect  
**Source:** `Fms/UnsPilotWaypointUtils.ts`, lines 16-27.
**Evidence / effect:** Auto-naming counts existing prefix matches instead of finding first unused suffix; non-contiguous names can cause collisions.
**Proposed remedy:** Use anchored matching and first available suffix 01..99; explicit exhaustion response.
**Regression test:** Facilities ABC01 and ABC03; repeated route imports.

### A17 — Waypoint constraints (MEDIUM)
**Classification:** Confirmed data-handling weakness  
**Source:** `CduDisplay/Pages/UnsFplPage.ts`, lines 614, 719-762, 854-894.
**Evidence / effect:** Vertical-data LegEventType.Changed branch TODO; altitude edit sets speed constraint fields to unused.
**Proposed remedy:** Preserve speed constraints, handle leg-data-change event and test UI refresh.
**Regression test:** Edit STAR altitude and verify speed restriction retained and displayed.

### A18 — Flight-plan mutation notifications (MEDIUM)
**Classification:** Confirmed source risk  
**Source:** `Fms/UnsFms.ts`, lines 4293-4305.
**Evidence / effect:** Merges duplicate legs by directly changing leg2.leg; source explicitly warns events will not fire.
**Proposed remedy:** Change through flight-plan API with appropriate leg-changed notifications.
**Regression test:** Merge procedure/enroute duplicate and verify FPL and predictors refresh.

### A19 — Destination facility async updates (MEDIUM)
**Classification:** Confirmed source behavior  
**Source:** `WTUns1FsInstrument.tsx`, lines 365-383.
**Evidence / effect:** Async facility load does not verify destination is still the requested airport before publishing, risking old result after rapid changes.
**Proposed remedy:** Use request token or compare current ICAO when promise resolves.
**Regression test:** Change destination twice under delayed facility resolution.

### A20 — Prediction API (MEDIUM)
**Classification:** Confirmed incomplete interface  
**Source:** `Fms/UnsFlightPlanPredictor.ts`, lines 60-119.
**Evidence / effect:** Six interface methods throw Not yet implemented; actual per-leg and destination predictions do function.
**Proposed remedy:** Implement selectively when required; explicit feature gates, never call unimplemented methods in flight.
**Regression test:** Call each API in test harness; validate results and failure messages.

### A21 — FPL waypoint ETA/ETE (MEDIUM)
**Classification:** Confirmed incomplete feature  
**Source:** `CduDisplay/Pages/UnsFplPage.ts`, lines ~674.
**Evidence / effect:** Flight-plan page contains TODO for ETA/ETE even though per-leg predictor exists and updates periodically.
**Proposed remedy:** Bind existing predictions to conventional FPL display, respect original UI.
**Regression test:** Compare FPL leg ETA/ETE with NAV and simulation clock.

### A22 — FPL functions (LOW)
**Classification:** Confirmed incomplete feature  
**Source:** `CduDisplay/Pages/UnsFplMenuPage.ts`, lines 33-47.
**Evidence / effect:** COMPRESSED, STORE FPL, CLEARANCE, PPOS TO WPT, RAIM PRED are explicitly disabled.
**Proposed remedy:** Implement original Universal semantics one feature at a time; STORE FPL as pilot route database separate from active plan.
**Regression test:** Store/recall route without changing active route; view modes.

### A23 — VNAV/TUNE (LOW)
**Classification:** Confirmed incomplete feature  
**Source:** `CduDisplay/Pages/UnsVnavPathPage.ts; CduDisplay/Pages/UnsTunePage.ts`, lines 10-30; 1-32.
**Evidence / effect:** VNAV shows NOT AVAILABLE; TUNE is placeholder; neither is a minor bug fix.
**Proposed remedy:** Preserve original page identity, introduce passive VNAV first, then optional active guidance after validation.
**Regression test:** VNAV advisory tests with STAR altitude constraints; approach glidepath regression.

### A24 — FMS messages (MEDIUM)
**Classification:** Confirmed completeness gap  
**Source:** `Fms/Message/MessageDefinitions.ts; Fms/Navigation/UnsNavDataComputer.ts`, lines 25-110; 240-262.
**Evidence / effect:** ~40 message definitions but only one direct post call in current UNS source (NEXT_LEG_UNDEFINED). Defined alerts do not imply operational monitoring.
**Proposed remedy:** Build event-to-message coverage matrix; add targeted alerts with suppression and priority.
**Regression test:** Provoke leg discontinuity, sensor degrade, predicted fuel warning.

### A25 — Message descriptions (LOW)
**Classification:** Confirmed source defect  
**Source:** `Fms/Message/MessageDefinitions.ts; CduDisplay/Pages/UnsMessagePage.ts`, lines 88-89; 29-49.
**Evidence / effect:** GPS_ONLY_NAV message incorrectly renders GNSS 3 DESELECT; list dedupes on text and alphabetic-sort implementation contradicts timestamp comment.
**Proposed remedy:** Correct text and order/dedupe by ID/priority or event time as appropriate.
**Regression test:** Post distinct same-text messages and check ordering and clearing.

### A26 — Approach labels (LOW)
**Classification:** Confirmed source defect  
**Source:** `Fms/UnsFmsUtils.ts`, lines 529-554.
**Evidence / effect:** LDA approach is labeled SDF; runway number validation inadvertently checks designator twice.
**Proposed remedy:** Correct LDA label and validate runway number and designator independently.
**Regression test:** Display LDA and SDF procedures with runway identifiers.

### A27 — PERF/FUEL numeric formatting (LOW)
**Classification:** Confirmed edge-case defect  
**Source:** `CduDisplay/Pages/UnsPerfPage.ts; CduDisplay/Pages/UnsFuelPage.ts`, lines various.
**Evidence / effect:** Several truthiness checks treat legitimate zero values as unavailable, including PERF DIST/ETE and projected quantities.
**Proposed remedy:** Use explicit null/undefined/finite tests, preserve zero.
**Regression test:** 0 NM at destination, exact zero fuel excess, 0 endurance.

### A28 — ESAD/flight accumulation (LOW)
**Classification:** Potential lifecycle defect  
**Source:** `Fms/Performance/UnsFuelComputerInstrument.ts`, lines Accumulator and initialization sections.
**Evidence / effect:** Total true-air-miles accumulator initializes once and may persist across flights without full instrument reinitialization.
**Proposed remedy:** Define flight-reset lifecycle and test same-simulator multiple flights.
**Regression test:** Fly leg A, land, taxi/takeoff B; inspect ESAD reset.

### A29 — Autopilot and approach guidance (RESEARCH)
**Classification:** Integration boundary  
**Source:** `Autopilot/UnsAPConfig.ts; Fms/Navigation/UnsLnavSteeringController.ts`, lines 49-58; 94-175.
**Evidence / effect:** Generic pitch/VS/GP/GS and LNAV steering are present; this does not prove 707 custom pitch wheel or managed VNAV command is available.
**Proposed remedy:** Document actual published 707/SDK interface before building active VNAV.
**Regression test:** Read-only steering command log; verify handoff and altitude capture.

### A30 — VFE, diagnostics and web server (RESEARCH)
**Classification:** Integration boundary  
**Source:** `WTUns1FsInstrument.tsx; published SDK SimConnect/CommBus`, lines Application interface.
**Evidence / effect:** UNS source excludes 707 virtual flight engineer implementation; standard SimVars are not proof that every custom switch and callout is observable.
**Proposed remedy:** Build independent read-only telemetry logger; correlate VFE actions with exposed states.
**Regression test:** A/B ground tests VFE off/on, then safe airborne monitoring.

## Proposed development sequence
**Phase 0 — Reproducible stock build / safe deployment gate**: archive unmodified source, retain upstream license and copyright notices, compile the published baseline, package with documented instrument-patch mechanism, confirm compatibility with current simulator, and test rollback. The published source may be older than the current shipped instrument. Stop deployment if baseline cannot be shown compatible; do not reverse-engineer unpublished binaries.
**Phase 1 — Navigation and state invariants**: add unit tests and fix A01–A03, A10–A11, A14–A16. These include numeric corrections, isolated sensor inputs, active waypoint preservation, airway indexing and time semantics.
**Phase 2 — Flight-plan transaction safety**: A07–A09, A12–A13, A17–A19. Edits should be serialized, verified against the resulting active flight plan, report failure and leave the previous plan safe. Preserve manufacturer keypad/menu behavior; avoid introducing EXEC by default.
**Phase 3 — PERF/FUEL**: A04–A06, A27–A28, shared predictor service; first fix live DIST and page reentry, then independently validate destination fuel math and any later performance model from recorded test-flight data.
**Phase 4 — Feature completion**: A20–A23, A24–A26. Wire existing predictor to waypoint ETA/ETE, implement traditional stored pilot routes, expand messages and introduce passive VNAV behind a compatible original UI.
**Phase 5 — Advanced systems**: A29–A30; external read-only SimConnect recorder, flight-engineer monitoring, local web server, voice co-pilot. Only advance to controlled VNAV/autothrottle after published interface and safety testing.

## Minimum high-value regression suite
- R01: Fuel initialization → NAV/PERF/FPL → FUEL repeated 10×, before and after gross weight entry.
- R02: Keep PERF displayed through 50+ NM flight; check DIST monotonically trends with movement and ETE/fuel projections stay coherent.
- R03: STAR and approach insertions on ground and during cruise; rapid transition changes; verify *actual* legs and active leg.
- R04: SID edits, failed facility lookup, and concurrent key presses; ensure no unclosed edit batch.
- R05: Insert an enroute waypoint at index 0, before current TO, after current TO, and inside airway; verify same intended TO fix remains active.
- R06: Enter airway exit by ident on positions 1, 12, 13, 24, 25 of a multi-page list.
- R07: Import valid route, missing waypoint, missing airway, and direct-to; failed import preserves prior valid plan.
- R08: Simulate ANP range inputs and verify result against squared-formula reference, never XOR integers.
- R09: Feed identical reference position to multiple sensors; assert the reference object is not modified.
- R10: Force GPS 1/2/3 to best ANP and verify active receiver indicated correctly.
- R11: Simulated time differs from OS date and crosses midnight; ETA uses the simulated clock.
- R12: Existing pilot waypoints ABC01, ABC03; auto-name next unique waypoint without collision.
- R13: Edit STAR altitude while preserving published speed constraint and verifying changed FPL row refresh.
- R14: GPS/glidepath approach with GS AUTO and LNAV; ensure new VNAV advisory does not affect existing approach guidance.
- R15: Two sequential flights in one simulator session; verify fuel and ESAD resets as designed.
- R16: Post warnings from different origins; verify correct message ID/text, clear action, audible priority as appropriate.
- R17: Disable Community patch and confirm stock UNS-1 loads; no original Microsoft files modified.

## What this audit does **not** establish
- No claim the Microsoft 707 shipped today still has every issue found in May 2026 source.
- No build or Microsoft Flight Simulator runtime tests were conducted here; potential failure paths require validation.
- No proof that the proprietary 707 flight-engineer scripts or every autopilot pitch-wheel behavior can be directly accessed from the published UNS-1 code.
- No recommendation to change the original waypoint-entry convention by default. User-facing redesign must be opt-in and backward compatible.

## Files supplied alongside this report
- `UNS1_Audit_Findings.csv` — machine-readable prioritized findings, source locations, remedies, tests.
- `UNS1_Source_File_Inventory.csv` — every source/configuration file, path, line count, TODO/FIXME count and SHA-256 for a reproducible baseline.

## Copyright and distribution note
This report comments on the user-provided Microsoft-published source without redistributing the full source. A public derivative must preserve Microsoft’s applicable modified MIT license and MSFS-only condition, include upstream copyright notices, and avoid misleading project branding. All changes described here are proposals, not installed patches.
