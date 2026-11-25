# Installation — v0.1.0 public beta

## Requirements

- Windows PC with Microsoft Flight Simulator 2024 and its Boeing 707-320C installed/available.
- The exact supported stock aircraft-specific UNS-1 instrument (WT2.2.4).
- Windows PowerShell 5.1 or PowerShell 7. No additional dependencies.

The installer generates build 0.0.4 locally, without modifying official files or downloading Microsoft's compiled code. The instrument has passed maintainer flight testing; this new PowerShell installation path still needs a Windows end-to-end test.

## 1. Obtain the stock instrument

Remove any previous 707 UNS-1 override from Community, then start MSFS 2024 and load the Boeing 707. In Developer Mode, use the virtual file system (VFS) projection if needed to expose the aircraft's files. Copy the stock instrument to a temporary folder outside Community before closing MSFS.

The projected file on the maintainer's installation was under:

`%APPDATA%\Microsoft Flight Simulator 2024\VFSProjection\html_ui\Pages\VCockpit\Instruments\Airliners\WTB707\WTUns1v2\WTUns1.js`

Actual projection location may vary. Do not select the generic NavSystems instrument or a previously patched file. The installer requires stock SHA-256:

`1A54D71AAEB6B1A3F2101BF49B1BF1EC918C107732D81914FFAD8967F72230B2`

## 2. Download and install

1. Download [Install-UNS1.ps1](../Install-UNS1.ps1) using GitHub's Raw/download control. Keep the repository license and notices with the downloaded patch.
2. Locate your actual MSFS 2024 Community folder (check your simulator's package settings; installation paths vary).
3. Close MSFS 2024. Open PowerShell in the folder containing the script. Inspect the script before running it.
4. Run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\Install-UNS1.ps1"
```

The execution policy option applies only to this PowerShell process. Do not bypass organizational restrictions. When prompted, enter the path to the stock WTUns1.js copy and the actual Community folder. Alternatively use the script parameters -SourceFile and -CommunityFolder.

The installer checks compatibility, rejects known conflicting instrument overrides, and creates only:

```text
Community/
  zz-wtb707-uns1-audit-batch-01-cumulative/
    manifest.json
    layout.json
    html_ui/Pages/VCockpit/Instruments/Airliners/WTB707/WTUns1v2/WTUns1.js
```

If it reports an unsupported hash or conflict, stop. Do not disable the hash check. No source file is edited.

## 3. Verify

The installer must report this resulting instrument SHA-256:

`A5450F6E46F7C44A98B38A6C58FDB7CC06AB755AEA8EA066ECC444A994643E2B`

Restart MSFS and load the 707. With weights uninitialized, press FUEL: page 1 should appear. Enter passengers and cargo (zero is valid), press NAV, then FUEL: page 2 should appear. PREV/NEXT should still work. In flight, check that PERF and FUEL distance update while displayed.

## Uninstall / update

Close MSFS. Remove only the generated package folder from Community, then restart the simulator. The original aircraft remains untouched. After an official update, remove the override and verify the stock hash before reinstalling. Never install multiple versions.

## Troubleshooting

If the FUEL page still locks up, check for competing overrides and verify the projected aircraft-specific instrument SHA-256 with Get-FileHash. If the installer rejects a hash, report it through GitHub Issues rather than editing the script. Include simulator version and reproduction steps, but redact personal file paths.
