# CitiBike Analytics — Microsoft Fabric End-to-End Project

A complete data engineering and analytics pipeline built on Microsoft Fabric, using real-world NYC Citi Bike trip data. This project demonstrates ingestion, transformation, dimensional modeling, semantic modeling, and BI reporting, with a full Dev → Prod deployment lifecycle managed through Git integration and Fabric Deployment Pipelines.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Data Source](#data-source)
4. [Fabric Workspace & Governance Setup](#fabric-workspace--governance-setup)
5. [Bronze Layer — Dataflow Gen2](#bronze-layer--dataflow-gen2)
6. [Gold Layer — Warehouse](#gold-layer--warehouse)
7. [Star Schema](#star-schema)
8. [Semantic Model & DAX](#semantic-model--dax)
9. [Power BI Report](#power-bi-report)
10. [Git Integration & CI/CD](#git-integration--cicd)
11. [Deployment Pipeline (Dev → Prod)](#deployment-pipeline-dev--prod)
12. [Key Decisions & Known Limitations](#key-decisions--known-limitations)
13. [Tools & Fabric Features Demonstrated](#tools--fabric-features-demonstrated)

---

## Project Overview

This project ingests, cleans, models, and visualizes one month (June 2026) of NYC Citi Bike trip data — over 5.3 million individual bike trips — using a modern medallion-style architecture entirely within Microsoft Fabric.

**What this project achieves:**
- A fully working, end-to-end Fabric pipeline: public data → cleaned Bronze layer → dimensionally modeled Gold layer → semantic model → interactive Power BI dashboard
- A real Dev/Prod environment split, with Git-based version control and a working Deployment Pipeline promoting every item (Lakehouse, Dataflow, Warehouse, semantic model, report) between environments
- A genuinely broad demonstration of Fabric Warehouse capability — not just tables, but parameterized stored procedures, a scalar function, MERGE-based upserts, and declared (though unenforced) primary/foreign keys
- A semantic model with intermediate-to-advanced DAX (USERELATIONSHIP, ALL vs. ALLSELECTED, RANKX, rolling time intelligence), rather than just basic SUM/COUNT measures
- A documented, honest record of the real platform constraints and quirks encountered along the way (Fabric Warehouse's T-SQL limitations, Dataflow Gen2's ZIP-handling and static-connection limitations, Lakehouse data not being covered by deployment pipelines) — the kind of hands-on knowledge that only comes from actually building something end-to-end, not just following a clean tutorial

**Goals of this project:**
- Build a production-style Fabric pipeline from scratch, covering ingestion through reporting
- Demonstrate Dataflow Gen2, Fabric Warehouse (stored procedures, functions, MERGE), semantic modeling with advanced DAX, and Power BI reporting
- Implement real CI/CD practices: Git integration, Dev/Prod workspace separation, and Fabric Deployment Pipelines
- Apply Fabric governance features: Domains

<img width="468" height="542" alt="image" src="https://github.com/user-attachments/assets/25532837-48a3-4628-be1b-6b62cef84612" />

---

## Architecture

```
Citi Bike S3 (public, no auth)
        │
        ▼
Dataflow Gen2  ──►  Lakehouse (Bronze)
  - Combine 6 monthly CSV files          bronze.bronze_citibike_trips
  - Clean types, trim text
  - Remove null ride_id
        │
        ▼
Fabric Warehouse (Gold)
  - Stored procedures (MERGE-based loads)
  - Scalar function
  - Star schema: fact_trip + 3 dimensions
        │
        ▼
Semantic Model (Direct Lake on SQL)
  - Relationships, DAX measures
        │
        ▼
Power BI Report
  - KPI cards, trend charts, station map, breakdowns
```

**Design note:** Bronze and Silver responsibilities were intentionally combined into a single Dataflow Gen2 layer for this project, given the moderate data volume and complexity. All row-level cleaning (type casting, trimming, null filtering) happens in Bronze; all business/dimensional modeling happens in Gold.


<img width="1440" height="730" alt="image" src="https://github.com/user-attachments/assets/ec19e963-16fe-463b-8383-c737b2b98608" />

<img width="1440" height="808" alt="image" src="https://github.com/user-attachments/assets/edadd35f-de99-46ad-be44-bc8773daaa26" />

<img width="1438" height="806" alt="image" src="https://github.com/user-attachments/assets/0bbb37b7-cb17-4afe-a983-8455f5514fcc" />

<img width="1440" height="804" alt="image" src="https://github.com/user-attachments/assets/7216c795-ca11-40ed-9920-e756cdd3906b" />


---

## Data Source

### About Citi Bike

Citi Bike is New York City's official bike-share system, operated by Lyft. Riders can unlock a bike (classic pedal or electric) from any docking station across the city and return it to any other station — used both by daily commuters (via monthly/annual memberships) and casual/tourist riders (via single-ride or day passes). The system spans hundreds of stations across Manhattan, Brooklyn, Queens, and Jersey City, and has grown substantially over the years, now handling several million rides per month during peak season.

Every completed trip is logged with its start/end time, start/end station, and rider type, and Lyft publishes this data publicly and free of charge as part of Citi Bike's open data program — genuinely used by urban planners, researchers, journalists, and analysts, not just as a tutorial dataset.

### Dataset details

**Citi Bike System Data** — published monthly as public, unauthenticated CSV files.

- **Official system data page:** https://citibikenyc.com/system-data
- **Direct file index (all available months, all history):** https://s3.amazonaws.com/tripdata/index.html
- **File used in this project:** Zip file downloaded for June 2026, which contains 6 split CSV files due to file size
- **Note:** Files prefixed `JC-` are Jersey City data (a separate deployment of the same system) and were excluded here to keep this project scoped to NYC only

**Raw columns:** `ride_id`, `rideable_type`, `started_at`, `ended_at`, `start_station_name`, `start_station_id`, `end_station_name`, `end_station_id`, `start_lat`, `start_lng`, `end_lat`, `end_lng`, `member_casual`

<img width="1416" height="812" alt="image" src="https://github.com/user-attachments/assets/eca2ae2e-0917-4928-89ac-63c082acbaa5" />

<img width="1424" height="808" alt="image" src="https://github.com/user-attachments/assets/71d573d4-a32d-48ae-ad3d-c5b51dd232aa" />

---

## Fabric Workspace & Governance Setup

| Component | Detail |
|---|---|
| **Dev workspace** | `ws_citibike_dev` |
| **Prod workspace** | `ws_citibike_prod` |
| **Domain** | *Bike Share Analytics* — a dedicated Fabric Domain created for this project, with both workspaces assigned to it |

<img width="1440" height="806" alt="image" src="https://github.com/user-attachments/assets/dace6690-95f9-440d-b6a2-437f55238934" />

---

## Bronze Layer — Dataflow Gen2

**Item:** `DF_CitiBike_Ingest_Transform`

**Process:**
1. Connected to Lakehouse Files (`citibike_raw` folder) containing 6 manually-staged CSVs
2. Combined all 6 files into a single query
3. Promoted headers, corrected data types (Date/Time, Decimal)
4. Removed rows with null/blank `ride_id`
5. Trimmed and standardized station name text (proper case)
6. Added derived columns: `trip_duration_minutes`, `start_date`, `start_hour`
7. Published output to Lakehouse → **bronze** schema → `bronze_citibike_trips`

**Known platform limitation encountered:** Power Query's Web connector cannot natively unzip `.zip` files — there is no built-in unzip function, and community-built custom M functions for this are fragile, especially against live web URLs. **Resolution:** CSV files were manually downloaded, unzipped, and staged into the Lakehouse Files area before Dataflow Gen2 processing — Dataflow Gen2's role was scoped to cleaning and transformation rather than raw file-format handling.

**Another limitation encountered:** Dataflow Gen2's "Fast Copy" optimization does not support certain transformations (e.g., custom columns using `Duration.TotalMinutes`). **Resolution:** the raw append/land step and the derived-column step were split into two separate queries.

<img width="1440" height="806" alt="image" src="https://github.com/user-attachments/assets/f7ccce8f-af8c-4267-802c-9f96859f9d6b" />

---

## Gold Layer — Warehouse

**Item:** `DW_CitiBike`

The Gold layer was built entirely with T-SQL inside the Fabric Warehouse, deliberately using a range of Warehouse-native features:

| Feature | Object(s) |
|---|---|
| **Physical tables with surrogate keys** | `dim_station`, `dim_rider_type`, `dim_date`, `fact_trip` |
| **Stored procedures (load/ETL)** | `sp_load_dim_station`, `sp_load_dim_rider_type`, `sp_populate_dim_date`, `sp_load_fact_trip` |
| **MERGE (upsert pattern)** | Used in `sp_load_fact_trip` for idempotent, re-runnable loads |
| **Scalar function** | `fn_classify_trip_duration()` — classifies trips as short/medium/long |
| **Primary & Foreign Keys (NOT ENFORCED)** | Declared on all Gold tables — not validated at insert time (a Fabric Warehouse constraint), but used as metadata so Power BI auto-detects relationships |

<img width="1424" height="804" alt="image" src="https://github.com/user-attachments/assets/78258d00-9630-4f8e-9354-9ae89fdc406c" />


### Fabric Warehouse T-SQL constraints discovered during this build
These are genuine platform limitations (not bugs) that shaped the final SQL:
- No `IDENTITY` columns → surrogate keys generated via `ROW_NUMBER()`
- No `CREATE INDEX` → replaced with `CREATE STATISTICS`
- Recursive CTEs are unreliable → date dimension built using a `VALUES`-based number generator instead
- `nvarchar` output (e.g., from `DATENAME()`) is not supported → explicitly cast to `VARCHAR`
- `ALTER COLUMN` cannot change nullability once a table is created → tables must declare `NOT NULL` at creation time
- `TRUNCATE TABLE` is blocked by any referencing foreign key, even when declared `NOT ENFORCED` → constraints must be dropped before truncating, then re-added afterward

---

## Star Schema

```
                    ┌───────────────┐
                    │   dim_date    │
                    └───────┬───────┘
                            │
┌───────────────┐   ┌───────▼───────┐   ┌──────────────────┐
│  dim_station   │◄──┤   fact_trip   ├──►│  dim_rider_type  │
│ (start & end)  │   └───────────────┘   └──────────────────┘
└────────────────┘
```

**Grain of `fact_trip`:** one row per bike trip

| Table | Key Columns |
|---|---|
| `fact_trip` | `ride_id`, `rideable_type`, `start_station_key`, `end_station_key`, `rider_type_key`, `trip_date`, `start_hour`, `trip_duration_minutes`, `duration_category` |
| `dim_station` | `station_key`, `station_name`, `latitude`, `longitude` (deduplicated union of start + end stations) |
| `dim_rider_type` | `rider_type_key`, `rider_type` (member / casual) |
| `dim_date` | `date_key`, `year`, `month`, `month_name`, `day`, `quarter`, `day_name`, `is_weekend` |

**Note on `end_station_key`:** since `fact_trip` connects to `dim_station` twice (once for pickup, once for drop-off), only the **start station** relationship is active by default. The end-station relationship is marked **inactive** and activated on demand via `USERELATIONSHIP()` in DAX.

<img width="1440" height="810" alt="image" src="https://github.com/user-attachments/assets/ad1ad4fb-498c-4edd-9c56-9303db38fc2d" />

---

## Semantic Model & DAX

**Item:** `SM_CitiBike` — Direct Lake on SQL, built on the Warehouse's Gold tables.

<img width="1440" height="810" alt="image" src="https://github.com/user-attachments/assets/dbcdc76e-d30c-4f6c-900f-e2403e2d4b9b" />


### Measures (organized under a dedicated `_Measures` table)

| Measure | Technique Demonstrated |
|---|---|
| `Total Trips` | Basic aggregation (`COUNTROWS`) |
| `Avg Trip Duration` | Basic aggregation (`AVERAGE`) |
| `% Member Rides` | `DIVIDE` with a filtered `CALCULATE` |
| `trips_ending_at_station` | `USERELATIONSHIP()` — activates the inactive end-station relationship |
| `pct_of_filtered_total` | `ALLSELECTED()` — respects report/slicer filters |
| `pct_of_grand_total` | `ALL()` — ignores all filters for a true grand total |
| `station_rank` | `RANKX()` with `ALLSELECTED()` |
| `Avg_Duration_vs_Overall` | `VAR`/`RETURN` pattern comparing filtered vs. overall average |
| `Rolling_7Day_Avg_Trips` | Time intelligence via `DATESINPERIOD()` |

**Design note:** classic time intelligence functions like `SAMEPERIODLASTYEAR()` were not used, since the dataset only covers a single month (June 2026) with no prior-year data to compare against. A 7-day rolling average was used instead as a more appropriate fit for the available date range.

---

## Power BI Report

**Item:** `RPT_CitiBike_Analytics`

**Visuals included:**
- KPI cards: Total Trips, Avg Trip Duration, % Member Rides
- Line chart: Trips by day (June 2026)
- Bar chart: Top stations by trip count (start station)
- Bar chart: Trips ending at station (drop-off hotspots, via `USERELATIONSHIP`)
- Donut chart: Rideable type (classic vs. electric bike)
- Donut chart: Rider type (member vs. casual)
- Map: Station activity by location, bubble-sized by trip volume

<img width="1440" height="806" alt="image" src="https://github.com/user-attachments/assets/3c3220e9-2cc0-4acd-b877-7141b664e5e6" />
---

## Git Integration & CI/CD

- **Dev workspace** connected to GitHub, branch: `dev`
- **Prod workspace** connected to GitHub, branch: `main`
- **Workflow:** changes are built in the Dev workspace and committed to the `dev` branch → the Dev workspace is promoted to the Prod workspace via the Fabric Deployment Pipeline → the resulting Prod workspace state is then committed to the `main` branch, keeping Git history in sync with what's actually running in Production

<img width="1434" height="810" alt="image" src="https://github.com/user-attachments/assets/73d5a67f-50a4-4d0e-b91d-396f69cbf348" />

<img width="1440" height="804" alt="image" src="https://github.com/user-attachments/assets/70019984-0a24-4f61-b98c-ade4aaab07e3" />


<img width="1432" height="588" alt="image" src="https://github.com/user-attachments/assets/09b399da-d54e-4431-b9c1-bed4a11b9c3f" />

<img width="1436" height="586" alt="image" src="https://github.com/user-attachments/assets/a0b71632-29dd-4c54-930d-9d646bc9e98f" />

---

## Deployment Pipeline (Dev → Prod)

**Pipeline:** `CitiBike Deployment Pipeline` — 2 stages (Development, Production)

**Items promoted:** Lakehouse, Dataflow Gen2, Warehouse, Semantic Model, Report

<img width="1440" height="808" alt="image" src="https://github.com/user-attachments/assets/22ea2f90-7fac-487c-91bb-3acd8ac88d29" />

<img width="1440" height="808" alt="image" src="https://github.com/user-attachments/assets/b45076fb-b176-4009-8b84-b0ced0d4139f" />


### Real deployment limitations encountered and resolved

1. **Lakehouse data does not deploy.** Deployment pipelines only recreate the Lakehouse *item* — internal folder structure, table schemas, and data are not tracked or promoted at all. **Resolution:** the Dataflow Gen2 was manually re-pointed (via Advanced Editor, updating `workspaceId`/`lakehouseId`) to run independently against Prod's own Lakehouse.

2. **Warehouse DDL deploys, but not data.** Table/procedure/view/function *definitions* promote correctly, but all tables land empty. **Resolution:** all `sp_load_*` stored procedures were explicitly executed in Prod after deployment.

3. **Dataflow Gen2 has hardcoded, non-parameterized references.** Per Microsoft's own documentation, deployment rules do not support altering Dataflow Gen2 connections, and connections are "statically bound." **Resolution:** manually edited the Dataflow's M code (Advanced Editor) to point at Prod's workspace/Lakehouse IDs. *(The fully correct long-term solution — not implemented here — is to rebuild the Dataflow using Public Parameters mode, allowing workspace/Lakehouse IDs to be passed at runtime via a Pipeline's Dataflow activity.)*

4. **Direct Lake semantic models retain their original Lakehouse/Warehouse binding after deployment.** Deployment rules **do** support semantic models (unlike Dataflow Gen2), so a data source rule was configured in the pipeline's Production stage, mapping the Dev Warehouse's Database/Server values to Prod's, followed by a redeploy.

<img width="1440" height="808" alt="image" src="https://github.com/user-attachments/assets/c641ea1b-f503-404c-b7d4-d7302a63b917" />

---

## Key Decisions & Known Limitations

- **Single-month scope:** Only June 2026 data was ingested (5.3M+ trips), chosen deliberately to keep iteration cycles fast while building. The architecture supports extending to additional months via the same ingestion pattern.
- **Station keys use station *name*, not ID:** `start_station_id`/`end_station_id` were dropped early in the Dataflow Gen2 build; all station matching uses `station_name` instead. This is a reasonable simplification for this dataset, though ID-based keys would be more robust in a system with less consistent naming.
- **Dev and Prod intentionally use the same public data.** Since Citi Bike data is public and non-sensitive, there was no need to simulate Dev/Prod data separation the way an enterprise system with sensitive data would require.

---

## Tools & Fabric Features Demonstrated

`Dataflow Gen2` · `Fabric Warehouse (tables, stored procedures, scalar functions, MERGE)` · `Direct Lake semantic model` · `Power BI report authoring` · `Git integration (GitHub)` · `Fabric Deployment Pipelines & deployment rules` · `Fabric Domains` · `DAX (USERELATIONSHIP, ALL, ALLSELECTED, RANKX, time intelligence)`
