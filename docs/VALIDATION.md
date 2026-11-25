# Validation record — v0.1.0 / build 0.0.4

## Frozen instrument

- Stock SHA-256: `1A54D71AAEB6B1A3F2101BF49B1BF1EC918C107732D81914FFAD8967F72230B2`
- Previous cumulative SHA-256: `E426D307E0F8765D6F247C50C30276B26C87BF7A53DD3A50F5892C9DCA60F791`
- Final A06 v2 SHA-256: `A5450F6E46F7C44A98B38A6C58FDB7CC06AB755AEA8EA066ECC444A994643E2B`
- Target: `html_ui/Pages/VCockpit/Instruments/Airliners/WTB707/WTUns1v2/WTUns1.js`

## Evidence

A04 and A05: observed in flight; destination distance and dependent predictions update while PERF/FUEL remains open.

A06 v1: Coherent GT confirmed the pre-fix stack overflow; reopening FUEL worked after recursive navigation was removed. A06 v2 supersedes v1: the FUEL key chooses page 1 or 2 based on valid nonnegative passenger and cargo entries, preserving zero and manual paging. Automated syntax and 24 mock test groups passed, including 100 consecutive FUEL activations. The maintainer reported successful simulator acceptance checks on November 24, 2026 and successful final flight testing on November 25, 2026. Brief page-1 transition flash observed and accepted as cosmetic. No rendering changes made.

The other 13 audit items passed offline transformation/algorithm checks. Successful cumulative operation is not individual edge-case validation.

## Distribution validation

The public ZIP preserves all three original package files byte-for-byte, including manifest.json, layout.json and the final flight-tested instrument. Only LICENSE, NOTICE.txt and INSTALL.txt were added alongside the package. ZIP integrity and instrument SHA-256 were verified. Release archive SHA-256: `F262D9E21A908160726F21514755840111A809C038C721E41E06E9E32C080C71`. The archived manifest contains historical candidate-stage validation wording; this document records the subsequent successful simulator tests.

Public beta; no certification, no guarantee of compatibility with future simulator updates.
