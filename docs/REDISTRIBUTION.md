# Redistribution and Provenance

## The licensing distinction

Microsoft's public `msfs-avionics-mirror` explicitly publishes the UNS-1 source under an MIT-style license with an addendum restricting the software and derivative works to use in Microsoft Flight Simulator.

That license clearly permits modification and redistribution of derivatives of the code actually published under that license, provided the copyright and license notices are preserved and the MSFS-only restriction is followed.

The project's current tested Boeing 707 patch, however, was produced against the newer **shipped WT2.2.4 Boeing 707 `WTUns1.js`**, which is newer than the public source snapshot used for the audit.

Until the exact redistribution status of that newer shipped file is established, the public-source license should **not automatically be assumed** to license every line of the newer shipped compiled file for redistribution.

## What is unquestionably publishable

The following project material is safe to publish as our own work or as commentary on licensed public source:

- audit reports and findings,
- validation records,
- original test procedures,
- original build/patch tooling,
- source transformations/diffs which do not reproduce substantial unlicensed code,
- documentation,
- GitHub issues and engineering notes.

## Release paths

### Preferred path A — build from licensed public source

Port the fixes into the publicly licensed UNS-1 source and produce the release artifact from that source.

Use this route if the public-source build can be shown compatible with the shipped Boeing 707 target.

Advantages:
- cleanest provenance,
- simplest open-source development model,
- full source can remain reviewable.

### Preferred path B — local hash-gated patch generation

If the shipped WT2.2.4 file contains necessary code not present in the public source, distribute a patch/build tool instead of redistributing the full newer shipped file.

The tool should:

1. locate or accept the user's locally installed Boeing 707 UNS-1 file;
2. require an exact known SHA-256 before making changes;
3. apply only the project transformations;
4. generate a separate Community-package override;
5. never modify Microsoft's installed file in place;
6. fail closed on any unknown simulator update.

This lets users create the patched derivative from the copy they already lawfully possess without the project redistributing the complete newer Microsoft file.

### Path C — explicit permission / license confirmation

If Microsoft or Working Title confirms that the newer shipped WT2.2.4 UNS-1 file is distributed under the same public avionics license, the complete Community-package override may be redistributed subject to those terms.

## Release gate

No GitHub Release or Flightsim.to package containing the complete newer shipped `WTUns1.js` should be published until one of the following is true:

- the release artifact is demonstrably built from the publicly licensed source; or
- the newer shipped file's redistribution license has been verified; or
- the release uses the local hash-gated patch-generation model and does not redistribute the full newer file.

This is a provenance/release-engineering precaution, not a finding that distribution is prohibited.
