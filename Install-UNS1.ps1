# WTB707 UNS-1 Community Patch v0.1.0 (instrument build 0.0.4).
# Uses only a local, hash-verified stock instrument. No original game files are modified.
# See LICENSE and docs/REDISTRIBUTION.md. MSFS use only.
[CmdletBinding()]
param(
    [string]$SourceFile,
    [string]$CommunityFolder
)
$ErrorActionPreference = 'Stop'
$stockHash = '1A54D71AAEB6B1A3F2101BF49B1BF1EC918C107732D81914FFAD8967F72230B2'
$targetHash = 'A5450F6E46F7C44A98B38A6C58FDB7CC06AB755AEA8EA066ECC444A994643E2B'
$relative = 'html_ui/Pages/VCockpit/Instruments/Airliners/WTB707/WTUns1v2/WTUns1.js'
$package = 'zz-wtb707-uns1-audit-batch-01-cumulative'
$utf8 = New-Object System.Text.UTF8Encoding($false, $true)
if (-not $SourceFile) {
    $default = Join-Path $env:APPDATA ('Microsoft Flight Simulator 2024/VFSProjection/' + $relative)
    $SourceFile = Read-Host "Enter the path to your STOCK WTUns1.js (Enter for $default)"
    if (-not $SourceFile) { $SourceFile = $default }
}
if (-not $CommunityFolder) { $CommunityFolder = Read-Host 'Enter your MSFS 2024 Community folder path' }
$SourceFile = $SourceFile.Trim('"')
$CommunityFolder = $CommunityFolder.Trim('"')
if (-not (Test-Path -LiteralPath $SourceFile -PathType Leaf)) { throw 'Stock file not found. See installation instructions for VFS projection.' }
if (-not (Test-Path -LiteralPath $CommunityFolder -PathType Container)) { throw 'Community folder not found.' }
$CommunityFolder = (Resolve-Path -LiteralPath $CommunityFolder).Path
if ((Get-Item -LiteralPath $CommunityFolder).Name -ne 'Community') { throw 'Select the actual Community folder.' }
$final = Join-Path $CommunityFolder $package
if (Test-Path -LiteralPath $final) { throw 'Existing patch found. Move it out of Community before installing.' }
foreach ($dir in Get-ChildItem -LiteralPath $CommunityFolder -Directory -Force) {
    if (Test-Path -LiteralPath (Join-Path $dir.FullName $relative)) {
        throw ('Conflicting instrument override: ' + $dir.FullName)
    }
}
$bytes = [IO.File]::ReadAllBytes((Resolve-Path -LiteralPath $SourceFile).Path)
$sha = [Security.Cryptography.SHA256]::Create()
try { $actual = [BitConverter]::ToString($sha.ComputeHash($bytes)).Replace('-', '') } finally { $sha.Dispose() }
if ($actual -ne $stockHash) { throw "Unsupported or already patched instrument. Expected $stockHash; got $actual. Nothing installed." }
$patchJson = @'
[
  {
    "start": 780,
    "remove": 1,
    "lines": [
      "        [UnsMessageID.GPS_ONLY_NAV, new Message(['GPS ONLY NAV'], UnsMessageColor.White)],"
    ]
  },
  {
    "start": 2819,
    "remove": 1,
    "lines": [
      "            const newPos = new msfsSdk.GeoPoint(fmsPosition.lat, fmsPosition.lon)"
    ]
  },
  {
    "start": 2841,
    "remove": 2,
    "lines": [
      "            const airError = (0.0125 * distance) ** 2;",
      "            return 0.05 ** 2 + Math.max(0.085 ** 2, airError);"
    ]
  },
  {
    "start": 2892,
    "remove": 2,
    "lines": [
      "            const airError = (0.0125 * distance) ** 2;",
      "            return (0.0122 * distance) ** 2 + (0.0175 * distance) ** 2 + 0.05 ** 2 + Math.max(0.085 ** 2, airError);"
    ]
  },
  {
    "start": 2981,
    "remove": 1,
    "lines": [
      "                const newPos = new msfsSdk.GeoPoint(fmsPosition.lat, fmsPosition.lon)"
    ]
  },
  {
    "start": 3008,
    "remove": 1,
    "lines": [
      "            return Math.sqrt((pdop * STANDARD_DEVIATION_OF_USER_EQUIVALENT_RANGE_ERROR) ** 2 + ESTIMATED_NUMERICAL_ERROR ** 2);"
    ]
  },
  {
    "start": 3095,
    "remove": 1,
    "lines": [
      "            this.publisher.pub('uns_active_gps', activeGps);"
    ]
  },
  {
    "start": 5951,
    "remove": 3,
    "lines": [
      "            this.distanceToDestination = msfsSdk.MappedSubject.create(([facility, ppos]) => {",
      "                return facility === null ? null : msfsSdk.UnitType.NMILE.convertFrom(ppos.distance(facility), msfsSdk.UnitType.GA_RADIAN);",
      "            }, this.destinationFacilityProxy, this.fms.pposSub);"
    ]
  },
  {
    "start": 5956,
    "remove": 1,
    "lines": [
      "                return (distance === null || groundSpeed < 30) ? null : distance / groundSpeed;"
    ]
  },
  {
    "start": 6450,
    "remove": 3,
    "lines": [
      "            // A06: Do not navigate within onResume(); prevents recursive FUEL navigation."
    ]
  },
  {
    "start": 9519,
    "remove": 2,
    "lines": [
      "                            const absoluteIndex = this.store.getIndexFromAirwayListIdent(input);",
      "                            const pageStart = (this.displayedSubPageIndex.get() - 1) * 12;",
      "                            return absoluteIndex >= pageStart && absoluteIndex < pageStart + 12",
      "                                ? absoluteIndex - pageStart + 1 : null;"
    ]
  },
  {
    "start": 9801,
    "remove": 3,
    "lines": [
      "            this.distanceToDestination = msfsSdk.MappedSubject.create(([facility, ppos]) => {",
      "                return facility === null ? null : msfsSdk.UnitType.NMILE.convertFrom(ppos.distance(facility), msfsSdk.UnitType.GA_RADIAN);",
      "            }, this.destinationFacility, this.fms.pposSub);"
    ]
  },
  {
    "start": 9806,
    "remove": 1,
    "lines": [
      "                return (distance === null || groundSpeed < 30) ? null : distance / groundSpeed;"
    ]
  },
  {
    "start": 9823,
    "remove": 1,
    "lines": [
      "                return zfw !== null ? zfw + fuelOnboard : null;"
    ]
  },
  {
    "start": 9904,
    "remove": 1,
    "lines": [
      "                        return `DIST[cyan s-text]  ${distance !== null ? INT_ROUND_DOWN_FORMATTER(distance).padStart(3, ' ') : '---'}[d-text]`;"
    ]
  },
  {
    "start": 9956,
    "remove": 1,
    "lines": [
      "                return zfw !== null && fuelOverhead !== null ? zfw + fuelOverhead : null;"
    ]
  },
  {
    "start": 9986,
    "remove": 1,
    "lines": [
      "                return endurance !== null && ete !== null ? clampToZero(endurance - ete) : null;"
    ]
  },
  {
    "start": 10003,
    "remove": 1,
    "lines": [
      "                return range !== null && dist !== null ? clampToZero(range - dist) : null;"
    ]
  },
  {
    "start": 11417,
    "remove": 3,
    "lines": [
      "                case 'FUEL': {",
      "                    // A06 v2: Choose the FUEL entry page before navigation, not in onResume().",
      "                    const perfPlan = this.props.fms.activePerformancePlan;",
      "                    const paxQuantity = perfPlan.paxQuantity.get();",
      "                    const cargoWeight = perfPlan.cargoWeight.get();",
      "                    const initialized = Number.isFinite(paxQuantity) && paxQuantity >= 0",
      "                        && Number.isFinite(cargoWeight) && cargoWeight >= 0;",
      "                    this.fmcScreen.navigateTo(initialized ? '/fuel#2' : '/fuel');"
    ]
  },
  {
    "start": 11421,
    "remove": 0,
    "lines": [
      "                }"
    ]
  },
  {
    "start": 11932,
    "remove": 1,
    "lines": [
      "                    type = 'LDA';"
    ]
  },
  {
    "start": 11957,
    "remove": 1,
    "lines": [
      "            if (Number.isFinite(approach.runwayNumber) && Number.isFinite(approach.runwayDesignator)) {"
    ]
  },
  {
    "start": 13551,
    "remove": 1,
    "lines": [
      "                    plan.closeBatch(batch);"
    ]
  },
  {
    "start": 15827,
    "remove": 1,
    "lines": [
      "                if (segmentIndex < activeSegmentIndex || (index !== undefined && segmentIndex == activeSegmentIndex && index < activeLegIndex)) {"
    ]
  },
  {
    "start": 18813,
    "remove": 6,
    "lines": [
      "            const prefix = ident.substring(0, 3);",
      "            const used = new Set(facilities.map(facility => msfsSdk.ICAO.getIdent(facility.icao)));",
      "            for (let suffix = 1; suffix <= 99; suffix++) {",
      "                const candidate = `${prefix}${suffix.toString().padStart(2, '0')}`;",
      "                if (!used.has(candidate)) {",
      "                    return candidate;"
    ]
  },
  {
    "start": 18821,
    "remove": 1,
    "lines": [
      "            throw new Error(`No available user waypoint suffix for ${prefix}`);"
    ]
  },
  {
    "start": 18980,
    "remove": 1,
    "lines": [
      "                    const lastEnrouteSegment = msfsSdk.ArrayUtils.peekLast(Array.from(plan.segmentsOfType(msfsSdk.FlightPlanSegmentType.Enroute)));"
    ]
  },
  {
    "start": 19740,
    "remove": 0,
    "lines": [
      "            this.simTimeMs = msfsSdk.ConsumerSubject.create(bus.getSubscriber().on('simTime'), Date.now());"
    ]
  },
  {
    "start": 19821,
    "remove": 1,
    "lines": [
      "            const currentUnix = this.simTimeMs.get();"
    ]
  },
  {
    "start": 20048,
    "remove": 0,
    "lines": [
      "                    if (this.flightPlanner.getFlightPlan(UnsFlightPlans.Active).destinationAirport !== destinationIcao) {",
      "                        return;",
      "                    }"
    ]
  }
]
'@
$edits = ConvertFrom-Json -InputObject $patchJson
$lines = [System.Collections.Generic.List[string]]::new()
$lines.AddRange([string[]]($utf8.GetString($bytes).Split([char]10)))
for ($i = $edits.Count - 1; $i -ge 0; $i--) {
    $e = $edits[$i]
    $lines.RemoveRange([int]$e.start, [int]$e.remove)
    $lines.InsertRange([int]$e.start, [string[]]$e.lines)
}
$patched = $utf8.GetBytes([string]::Join([string][char]10, $lines))
$sha = [Security.Cryptography.SHA256]::Create()
try { $actual = [BitConverter]::ToString($sha.ComputeHash($patched)).Replace('-', '') } finally { $sha.Dispose() }
if ($actual -ne $targetHash) { throw "Patch verification failed: $actual. Nothing installed." }
$stage = Join-Path (Split-Path -Parent $CommunityFolder) ('.uns1-stage-' + [Guid]::NewGuid().ToString('N'))
try {
    $dest = Join-Path $stage $relative
    [IO.Directory]::CreateDirectory((Split-Path -Parent $dest)) | Out-Null
    [IO.File]::WriteAllBytes($dest, $patched)
    $manifest = [ordered]@{
        dependencies = @()
        content_type = 'INSTRUMENTS'
        title = 'WT Boeing 707 UNS-1 cumulative bugfix - A06 v2 + Audit Batch 01'
        manufacturer = ''
        creator = 'UNS-1 Advanced Development'
        package_version = '0.0.4'
        minimum_game_version = '1.1.7'
        export_type = 'Community'
        builder = 'Microsoft Flight Simulator 2024'
        package_order_hint = 'INSTRUMENT_PATCH'
        globally_overriden_base_sim_files = @($relative)
        release_notes = @{ neutral = @{ LastUpdate = 'A06 v2 and 15 retained fixes; maintainer flight tested.'; OlderHistory = '' } }
    }
    $layout = @{ content = @(@{ path = $relative; size = $patched.Length; date = [IO.File]::GetLastWriteTimeUtc($dest).ToFileTimeUtc() }) }
    [IO.File]::WriteAllText((Join-Path $stage 'manifest.json'), ($manifest | ConvertTo-Json -Depth 8), $utf8)
    [IO.File]::WriteAllText((Join-Path $stage 'layout.json'), ($layout | ConvertTo-Json -Depth 8), $utf8)
    if (Test-Path -LiteralPath $final) { throw 'Destination already exists.' }
    [IO.Directory]::Move($stage, $final)
    Write-Host "Installed: $final"
    Write-Host "Verified instrument SHA-256: $actual"
    Write-Host 'Restart MSFS 2024. Remove this Community folder to uninstall.'
} finally {
    if (Test-Path -LiteralPath $stage) { Remove-Item -LiteralPath $stage -Recurse -Force }
}
