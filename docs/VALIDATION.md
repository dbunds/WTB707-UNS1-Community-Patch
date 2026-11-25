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

The stock hash was reconstructed by reversing the prior A04/A05/A06 edits and matched the original recorded stock SHA-256. The 30 line-range transformations were tested against that exact input in Python, generating the identical final JavaScript bytes. The new PowerShell installer has not been executed end-to-end on Windows/MSFS in this environment. Its input and output hashes are fail-closed. Manifest/layout metadata are generated locally and differ from the original test ZIP; instrument bytes must match exactly.

Public beta; no certification, no guarantee of compatibility with future simulator updates.
