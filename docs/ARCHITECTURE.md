# Architecture Notes

## Target distinction

The Boeing 707 loads its UNS-1 from:

`html_ui/Pages/VCockpit/Instruments/Airliners/WTB707/WTUns1v2/WTUns1.js`

The generic copy under `NavSystems/WTUns1v2` is not the runtime Boeing 707 target.

## Development principles

1. Prefer narrow, source-supported corrections over broad behavioral rewrites.
2. Preserve original UNS page identity and interface conventions.
3. Keep source confirmation, offline regression, and simulator validation as separate statuses.
4. Use existing Working Title/MSFS architecture first: EventBus, SimVars/LVars, predictor APIs, and native page lifecycle patterns.
5. Do not introduce external dependencies into core flight guidance without evidence they are required.
