# mrson governance — versioning, extensions, ignore-safety

Decided up front because the failure mode of every minimal-core + profiles ecosystem is **governance,
not minimalism** (FHIR's measured "profiliferation" across 1,300+ packages; OpenUSD's admittedly
unsolved-and-un-retrofittable schema versioning). The rules below exist so mrson does not repeat those.

## Versioning

- **Per-artifact version in the `$id`** (`…/core/v0`, `…/events/v0`). Bump the version segment on a
  breaking change; keep additive changes within a version.
- Scene documents carry a top-level `"mrson": <int>` version. Readers reject a major version they don't
  support rather than guess.
- **Migrations are hand-written**, per version step, and live in each host's type registry — never
  assumed to be automatic (this is the specific thing USD proved you cannot code-generate).
- JSON Structure's meta-schema is still `v0`; treat a `v0 → v1` meta-schema change as a known migration
  point and pin the draft (core draft-04, validation draft-03) in CI.

## Extensions & ignore-safety (better than a single "must-understand" bit)

New data enters through **profiles** (new node/event/op `type`s or new typed fields), never by mutating
the core. Two safety mechanisms, borrowed from the systems that got this right:

1. **Declared requirement, glTF-style.** A document may declare `extensionsUsed` / `extensionsRequired`
   (profile ids). A reader that doesn't implement a *required* profile refuses the whole document up
   front; unknown *used-but-not-required* profiles are preserved and ignored.
2. **Meaning-changing markers, FHIR-style.** A field or op that *changes how existing data must be
   interpreted* (not merely adds to it) must be marked so a reader that doesn't understand it fails
   loudly rather than silently misreading. (Additive, ignorable metadata needs no marker.)

## Registry & reuse

- Profiles are versioned, named, and listed (a reuse registry), so a second team finds and reuses a
  profile instead of minting a redundant one. Un-curated, permissionless extension is the documented
  road to fragmentation.
- Terminology uses code tuples `{scheme, value, meaning}` (DICOM/SNOMED/RadLex-shaped), not free text.

## Conventions fixed by the type system (verified against the JSON Structure SDK)

- **64-bit integers serialize as JSON strings** (`int64`/`uint64` safe-int rule). Applies to voxel
  counts, large logical times, byte sizes.
- **JSON Pointers use the URI-fragment form** (`#/segments/0/color`), not bare RFC-6901 (`/segments/…`).
- **Node identity** is the scene-local `id` string; cross-document identity and content integrity come
  from content-addressed blob **hashes**. (FHIR's logical-id vs business-identifier split is the model.)
- **Coordinate frames are RAS internally**; the mapping to DICOM-LPS and ROS REP-103 happens only at the
  MRCOM/robotics boundary, never in the runtime.
