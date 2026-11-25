# Installation — v0.1.0 public beta

## Requirements

Windows PC, Microsoft Flight Simulator 2024, and the Boeing 707-320C. This release targets the tested WT2.2.4 instrument. Other aircraft, MSFS 2020 and future simulator versions are not supported unless separately verified.

## Install

1. Download `WTB707-UNS1-Community-Patch-v0.1.0.zip` from [GitHub Releases](https://github.com/dbunds/WTB707-UNS1-Community-Patch/releases) when posted. Do not download the GitHub-generated source-code archive.
2. Close MSFS 2024.
3. Move previous versions of this patch and any conflicting 707 UNS-1 overrides out of Community.
4. Extract the ZIP to a temporary location. Copy the folder `zz-wtb707-uns1-audit-batch-01-cumulative` directly into your actual MSFS 2024 Community folder. Keep the accompanying license and notice with the distribution.
5. Start MSFS 2024 and load the Boeing 707-320C.

No developer mode, VFS mapping, PowerShell or official file modification is necessary.

Correct folder structure:

```text
Community/
  zz-wtb707-uns1-audit-batch-01-cumulative/
    manifest.json
    layout.json
    html_ui/Pages/VCockpit/Instruments/Airliners/WTB707/WTUns1v2/WTUns1.js
```

Avoid double-nesting the package folder. Your actual Community location depends on your installation.

## Verify operation

Before entering passenger and cargo quantities, press FUEL: page 1 opens. Enter both quantities (zero is valid), press NAV, then FUEL: page 2 opens. PREV/NEXT should remain functional. A brief page 1 flash is cosmetic. In flight, PERF and FUEL destination distance should update while displayed.

Optional SHA-256 verification:

- Release ZIP: `F262D9E21A908160726F21514755840111A809C038C721E41E06E9E32C080C71`
- Patched WTUns1.js: `A5450F6E46F7C44A98B38A6C58FDB7CC06AB755AEA8EA066ECC444A994643E2B`

## Uninstall and updates

Close MSFS, remove only the patch folder from Community, and restart MSFS. Official aircraft files are not changed. Remove the override before official simulator or aircraft updates, and do not reinstall until compatibility has been confirmed. Never install multiple packages overriding the same instrument.

If problems occur, check the package folder structure and other overrides, then report simulator version, patch version, reproduction steps and relevant logs (redact personal paths) in GitHub Issues.
