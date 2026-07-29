# mrson — Medical Reality Scripted Object Notation

**Alpha (v0), subject to review and iteration.** A platform-neutral, schema'd JSON model for
medical-imaging *scenes* — images, transforms, meshes, segmentations, markups, cameras, views,
transfer functions — plus a typed **event** and **operation** vocabulary for live, incremental updates.

mrson draws on decades of [3D Slicer](https://slicer.org)'s MRML but **strips the Slicer/VTK-specific
cruft**: neutral `type` names instead of `vtkMRML…` class names, content-addressed blobs instead of
inline bulk data, and a real type system instead of stringly-typed XML attributes. It is designed to be
read and written by non-Slicer systems, streamed over a network to synchronize places
(Slicer ↔ SlicerLive, SlicerLive ↔ SlicerLive), and shared in memory between cooperating processes.

## What this is (and isn't)

mrson is a **narrow-waist core + pluggable domain profiles**, not a universal medical model. The core
carries only what every scene shares — **identity, typed references, provenance, content-addressed
blob/array handles, coordinate-frame references, and a typed node hierarchy** — and pushes domain
specifics into profiles. It deliberately does **not** own bulk arrays (use OME-Zarr), the clinical
archive/interchange boundary (DICOM, via the **MRCOM** binding), graphics/sim interchange (USD, via
**MRUSD**), or clinical-context handoff (**FHIRcast**) — those are *edges*, not the runtime.

- **Foundation:** mrson / LiveScene (this repo defines mrson; LiveScene is the transport/runtime protocol).
- **Edges (bridges, not foundations):** MRCOM → DICOM · MRUSD → OpenUSD · FHIRcast → clinical context.

See [`docs/naming.md`](docs/naming.md) for the family and [`docs/governance.md`](docs/governance.md)
for versioning + extension rules. The full design rationale lives in the SlicerLive
`docs/MRSON-STRESS-TEST.md` and `docs/MRSON-LIVESCENE.md`.

## Layout

```
schema/
  mrson-core.struct.json     # the neutral node hierarchy + scene envelope
  events.struct.json         # typed event classes (a discriminated union, DOM-Event-style)
  ops.struct.json            # typed operations: put / patch / del / cmd
  mrson.d.ts                 # GENERATED TypeScript types (do not hand-edit)
  profiles/
    spatial.struct.json      # coordinate frames + transform detail (maps to DICOM-LPS / ROS REP-103)
    README.md                # profile mechanism + igt/micro/population status
examples/                    # validated sample scene, event, and op instances
tools/
  struct2ts.mjs              # JSON Structure -> TypeScript emitter (hand-owned; see below)
  validate.sh                # reproducible validation of every schema + example
```

## Why JSON Structure (not JSON Schema)

The schemas are written in **[JSON Structure](https://json-structure.github.io/core/)** (core draft-04),
a *type-definition* language rather than a validation-constraint language. This fits MRML's **type
hierarchy** natively:

- the node class hierarchy maps to `abstract` + `$extends` (`Node → DisplayableNode → ImageNode`);
- the heterogeneous node set is a **discriminated union** — a `choice` with a `type` selector — that
  enforces the closed set of node types (an unknown `type` is rejected);
- 64-bit ints, `uuid`, `datetime`, `decimal`, and fixed-size numeric arrays are real primitives, so
  matrices/vectors stop being space-separated strings.

**Enums are not used for the event vocabulary** — events are typed *classes* in a `choice` union, so an
unknown event type is rejected and each event carries a validated (possibly empty) payload. See
`events.struct.json`.

> Note: JSON Structure's own code generators are broken in the current release, and its JSON-Schema
> down-projection is lossy/one-way. mrson therefore uses the SDK **validators** as canonical and owns a
> tiny **TypeScript emitter** (`tools/struct2ts.mjs`) instead. That is fine — behavior bindings were
> always going to be hand-owned per host.

## Validate

```sh
tools/validate.sh          # sets up a venv, validates every schema + example instance
node tools/struct2ts.mjs schema/mrson-core.struct.json schema/events.struct.json schema/ops.struct.json > schema/mrson.d.ts
```

## Behavior does not live here

mrson defines the **declarative type model** — the data a node/event/op carries. Read/write/copy/observe
behavior (MRML's `ReadXML`/`WriteXML`/`ProcessMRMLEvents`) is a **per-host binding keyed by `type`**
(SlicerLive TS, Slicer C++/Python, Deno). The generated `mrson.d.ts` is the contract those bindings share.
