# population — map-to only, not a scene profile

Population-health data (OMOP CDM, FHIR Bulk Data / "Flat FHIR", i2b2) is fundamentally
**`(identity × concept × time)` fact rows** — person-keyed, event-per-row, statistical/relational.
There is **no coordinate frame shared across patients**, so a "scene" abstraction has no purchase here;
even geospatial epidemiology enters as another categorical dimension to group by, not a rendered frame.

Therefore mrson does **not** model population health as a scene. The only credible integration is a
**map-to at the edge**: an mrson scene/subject carries a stable subject identifier and terminology code
tuples (`{scheme, value, meaning}`) so an ETL can flatten a cohort of scenes into OMOP `PERSON` /
`OBSERVATION` / `MEASUREMENT` rows or FHIR resources for cohort context. mrson feeds population health;
it is not a population-health format.

No schema is defined for this profile — it is a documented boundary, like MRCOM for DICOM.
