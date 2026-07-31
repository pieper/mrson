# mrson profiles

Domain semantics live here, not in the core (the narrow-waist rule). A profile adds new node/event/op
`type`s or new typed fields. Profiles are versioned and listed here so they get reused, not re-minted.

In v0 each profile schema is **self-contained** (it repeats the few shared primitives it needs) so it
validates standalone with the JSON Structure SDK. A later composed build will use the JSON Structure
**Import** companion to pull in `mrson-core` and tighten cross-references to `core.AnyNode`.

| Profile | File | Status | Scope |
|---|---|---|---|
| **spatial** | `spatial.struct.json` | drafted + validated | Coordinate frames (RAS default; `parent`/`toParent` tf2-style tree) and full transform detail — linear / grid / bspline, deformation fields in content-addressed blobs. Maps to DICOM-LPS and ROS REP-103 (documented, enforced at the boundary). |
| **igt** | _todo_ | planned | Image-guided-therapy: devices, tools, tracking streams, therapy plans, robot kinematics. Decide tree-vs-graph deliberately (URDF's tree can't express closed-loop mechanisms; SDF went to a graph). |
| **micro** | _todo_ | planned | Cellular / tissue-microenvironment: OME-NGFF multiscale pyramids, spatial-omics; SBML/CellML *referenced*, not absorbed. |
| **population** | `population.md` | map-to only | Population health (OMOP CDM / FHIR Bulk / i2b2) is `(identity × concept × time)` fact rows with **no shared coordinate frame** — mrson can *feed* it (subject id + codes) but does not model it as a scene. |
