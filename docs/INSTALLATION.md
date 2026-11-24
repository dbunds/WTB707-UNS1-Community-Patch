# Installation

Public installation instructions will be finalized with the first GitHub Release package.

## Critical rule

Only one Community package replacing the Boeing 707 UNS-1 `WTUns1.js` should be installed at a time.

## Runtime verification

The projected simulator file can be verified with PowerShell:

```powershell
Get-FileHash "C:\Users\<USER>\AppData\Roaming\Microsoft Flight Simulator 2024\VFSProjection\html_ui\Pages\VCockpit\Instruments\Airliners\WTB707\WTUns1v2\WTUns1.js" -Algorithm SHA256
```

For the current baseline, the expected hash is:

`E426D307E0F8765D6F247C50C30276B26C87BF7A53DD3A50F5892C9DCA60F791`
