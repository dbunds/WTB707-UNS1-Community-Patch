# Validation Record

## Current baseline

Patched target SHA-256:

`E426D307E0F8765D6F247C50C30276B26C87BF7A53DD3A50F5892C9DCA60F791`

Target runtime file:

`html_ui/Pages/VCockpit/Instruments/Airliners/WTB707/WTUns1v2/WTUns1.js`

## Simulator-confirmed

### A06 — FUEL page lifecycle
Before the fix, Coherent GT logged `RangeError: Maximum call stack size exceeded` following FUEL mode-key navigation after fuel initialization. After the fix, FUEL reopened normally and NAV → FUEL → NAV → FUEL cycling no longer reproduced the stack overflow.

### A04 — PERF destination predictions
Observed in flight: destination distance and ETE updated while the PERF page remained open as aircraft position changed.

### A05 — FUEL destination predictions
Observed in flight: destination distance and fuel predictions updated while the FUEL page remained open as aircraft position changed.

## Broader regression pass

The cumulative patch has been exercised through repeated aircraft/software page cycles without a major regression observed. This is meaningful regression evidence but is not a substitute for individual edge-case validation of every finding.
