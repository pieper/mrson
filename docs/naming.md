# The Medical Reality family

One runtime foundation, three boundary bindings. The core runs; the edges import/export/coexist. No
edge reaches into the runtime.

| Name | Expands to | Role |
|---|---|---|
| **mrson** | Medical Reality Scripted Object Notation | The **format** — this repo. A schema'd, platform-neutral JSON scene + event + op model. |
| **LiveScene** | — | The **protocol/runtime** that transports mrson: node-state channel + content-addressed blob channel + a Lamport-LWW op/event stream (HTTP-bucket, WebSocket hot-channel, shared-memory, p2p bindings). |
| **MRCOM** | Medical Reality Communications | The **DICOM boundary**. Directly-mappable subset (image→CT/MR/SEG, segmentation→SEG/RTSTRUCT, markup→SR/GSPS, …) + coercion of the surplus into DICOM-legal carriers; rides VNA / DIMSE / dicomWeb. Import / hand-off / archival, not runtime. |
| **MRUSD** | Medical Reality USD | The **OpenUSD boundary**. Export the declarative renderable snapshot (meshes→UsdGeom, transforms→Xformable, camera→UsdGeomCamera, TF→UsdShade) for Isaac / Omniverse / usdview / DCC. A bridge, not a foundation. |
| **FHIRcast** | (HL7) | **Clinical-context coexistence.** FHIRcast establishes *which case* is on screen (patient/study/report) across the workstation; mrson drives *the live scene of that case*. Bridge finalized clinical results (measurements, ROIs) up to FHIRcast; keep the interactive scene stream on mrson's own channel. |
| **mr.md** | Medical Reality Markdown | The **authoring language** for narrated "LiveStory" content: CommonMark + YAML frontmatter binding a scene, `mrson:<id>` links, and fenced `mr-scene` blocks whose body is literal mrson ops. |

Naming intent: **mrson : LiveScene :: JSON : HTTP** (a format vs the protocol that moves it), and
**MRCOM : DICOM** deliberately parallels *Digital Imaging and Communications in Medicine*.
