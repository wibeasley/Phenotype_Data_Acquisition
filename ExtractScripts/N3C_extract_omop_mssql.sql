--OMOP v5.3.1 extraction code for N3C
--Written by Kristin Kostka, OHDSI
--Code written for MS SQL Server
--This extract purposefully excludes the following OMOP tables: PERSON, OBSERVATION_PERIOD, VISIT_OCCURRENCE, CONDITION_OCCURRENCE, DRUG_EXPOSURE, PROCEDURE_OCCURRENCE, MEASUREMENT, OBSERVATION, LOCATION, CARE_SITE, PROVIDER,
--Currently this script extracts the derived tables for DRUG_ERA, DOSE_ERA, CONDITION_ERA as well (could be modified we run these in Palantir instead)
--Assumptions:
--	1. You have already built the N3C_COHORT table (with that name) prior to running this extract
--	2. You are extracting data with a lookback period to 1-1-2018

-- To run, you will need to find and replace @cdmDatabaseSchema and @resultsDatabaseSchema with your local OMOP schema details

--PERSON
--OUTPUT_FILE: PERSON.csv
SELECT
   p.PERSON_ID,
   GENDER_CONCEPT_ID,
   YEAR_OF_BIRTH,
   MONTH_OF_BIRTH,
   RACE_CONCEPT_ID,
   ETHNICITY_CONCEPT_ID,
   LOCATION_ID,
   PROVIDER_ID,
   CARE_SITE_ID,
   PERSON_SOURCE_VALUE,
   GENDER_SOURCE_VALUE,
   RACE_SOURCE_VALUE,
   RACE_SOURCE_CONCEPT_ID,
   ETHNICITY_SOURCE_VALUE,
   ETHNICITY_SOURCE_CONCEPT_ID
  FROM @cdmDatabaseSchema.PERSON p
  JOIN @resultsDatabaseSchema.N3C_COHORT n
    ON p.PERSON_ID = n.PERSON_ID;

--OBSERVATION_PERIOD
--OUTPUT_FILE: OBSERVATION_PERIOD.csv
SELECT
   OBSERVATION_PERIOD_ID,
   p.PERSON_ID,
   CONVERT(VARCHAR(20),OBSERVATION_PERIOD_START_DATE, 120) as OBSERVATION_PERIOD_START_DATE,
   CONVERT(VARCHAR(20),OBSERVATION_PERIOD_END_DATE, 120) as OBSERVATION_PERIOD_END_DATE,
   PERIOD_TYPE_CONCEPT_ID
 FROM @cdmDatabaseSchema.OBSERVATION_PERIOD p
 JOIN @resultsDatabaseSchema.N3C_COHORT n
   ON p.PERSON_ID = n.PERSON_ID;

--VISIT_OCCURRENCE
--OUTPUT_FILE: VISIT_OCCURRENCE.csv
SELECT
   VISIT_OCCURRENCE_ID,
   n.PERSON_ID,
   VISIT_CONCEPT_ID,
   CONVERT(VARCHAR(20),VISIT_START_DATE, 120) as VISIT_START_DATE,
   CONVERT(VARCHAR(20),VISIT_START_DATETIME, 120) as VISIT_START_DATETIME,
   CONVERT(VARCHAR(20),VISIT_END_DATE, 120) as VISIT_END_DATE,
   CONVERT(VARCHAR(20),VISIT_END_DATETIME, 120) as VISIT_END_DATETIME,
   VISIT_TYPE_CONCEPT_ID,
   PROVIDER_ID,
   CARE_SITE_ID,
   VISIT_SOURCE_VALUE,
   VISIT_SOURCE_CONCEPT_ID,
   ADMITTING_SOURCE_CONCEPT_ID,
   ADMITTING_SOURCE_VALUE,
   DISCHARGE_TO_CONCEPT_ID,
   DISCHARGE_TO_SOURCE_VALUE,
   PRECEDING_VISIT_OCCURRENCE_ID
FROM @cdmDatabaseSchema.VISIT_OCCURRENCE v
JOIN @resultsDatabaseSchema.N3C_COHORT n
  ON v.PERSON_ID = n.PERSON_ID
WHERE v.VISIT_START_DATE >= '1/1/2018';

--CONDITION_OCCURRENCE
--OUTPUT_FILE: CONDITION_OCCURRENCE.csv
SELECT
   CONDITION_OCCURRENCE_ID,
   n.PERSON_ID,
   CONDITION_CONCEPT_ID,
   CONVERT(VARCHAR(20),CONDITION_START_DATE, 120) as CONDITION_START_DATE,
   CONVERT(VARCHAR(20),CONDITION_START_DATETIME, 120) as CONDITION_START_DATETIME,
   CONVERT(VARCHAR(20),CONDITION_END_DATE, 120) as CONDITION_END_DATE,
   CONVERT(VARCHAR(20),CONDITION_END_DATETIME, 120) as CONDITION_END_DATETIME,
   CONDITION_TYPE_CONCEPT_ID,
   CONDITION_STATUS_CONCEPT_ID,
   NULL as STOP_REASON,
   VISIT_OCCURRENCE_ID,
   NULL as VISIT_DETAIL_ID,
   CONDITION_SOURCE_VALUE,
   CONDITION_SOURCE_CONCEPT_ID,
   NULL as CONDITION_STATUS_SOURCE_VALUE
FROM @cdmDatabaseSchema.CONDITION_OCCURRENCE co
JOIN @resultsDatabaseSchema.N3C_COHORT n
  ON CO.person_id = n.person_id
WHERE co.CONDITION_START_DATE >= '1/1/2018';

--DRUG_EXPOSURE
--OUTPUT_FILE: DRUG_EXPOSURE.csv
SELECT
   DRUG_EXPOSURE_ID,
   n.PERSON_ID,
   DRUG_CONCEPT_ID,
   CONVERT(VARCHAR(20),DRUG_EXPOSURE_START_DATE, 120) as DRUG_EXPOSURE_START_DATE,
   CONVERT(VARCHAR(20),DRUG_EXPOSURE_START_DATETIME, 120) as DRUG_EXPOSURE_START_DATETIME,
   CONVERT(VARCHAR(20),DRUG_EXPOSURE_END_DATE, 120) as DRUG_EXPOSURE_END_DATE,
   CONVERT(VARCHAR(20),DRUG_EXPOSURE_END_DATETIME, 120) as DRUG_EXPOSURE_END_DATETIME,
   DRUG_TYPE_CONCEPT_ID,
   NULL as STOP_REASON,
   REFILLS,
   QUANTITY,
   DAYS_SUPPLY,
   NULL as SIG,
   ROUTE_CONCEPT_ID,
   LOT_NUMBER,
   PROVIDER_ID,
   VISIT_OCCURRENCE_ID,
   null as VISIT_DETAIL_ID,
   DRUG_SOURCE_VALUE,
   DRUG_SOURCE_CONCEPT_ID,
   ROUTE_SOURCE_VALUE,
   DOSE_UNIT_SOURCE_VALUE
FROM @cdmDatabaseSchema.DRUG_EXPOSURE de
JOIN @resultsDatabaseSchema.N3C_COHORT n
  ON de.PERSON_ID = n.PERSON_ID
WHERE de.DRUG_EXPOSURE_START_DATE >= '1/1/2018';

--PROCEDURE_OCCURRENCE
--OUTPUT_FILE: PROCEDURE_OCCURRENCE.csv
SELECT
   PROCEDURE_OCCURRENCE_ID,
   n.PERSON_ID,
   PROCEDURE_CONCEPT_ID,
   CONVERT(VARCHAR(20),PROCEDURE_DATE, 120) as PROCEDURE_DATE,
   CONVERT(VARCHAR(20),PROCEDURE_DATETIME, 120) as PROCEDURE_DATETIME,
   PROCEDURE_TYPE_CONCEPT_ID,
   MODIFIER_CONCEPT_ID,
   QUANTITY,
   PROVIDER_ID,
   VISIT_OCCURRENCE_ID,
   NULL as VISIT_DETAIL_ID,
   PROCEDURE_SOURCE_VALUE,
   PROCEDURE_SOURCE_CONCEPT_ID,
   NULL as MODIFIER_SOURCE_VALUE
FROM @cdmDatabaseSchema.PROCEDURE_OCCURRENCE po
JOIN @resultsDatabaseSchema.N3C_COHORT n
  ON PO.PERSON_ID = N.PERSON_ID
WHERE po.PROCEDURE_DATE >= '1/1/2018';

--MEASUREMENT
--OUTPUT_FILE: MEASUREMENT.csv
SELECT
   MEASUREMENT_ID,
   n.PERSON_ID,
   MEASUREMENT_CONCEPT_ID,
   CONVERT(VARCHAR(20),MEASUREMENT_DATE, 120) as MEASUREMENT_DATE,
   CONVERT(VARCHAR(20),MEASUREMENT_DATETIME, 120) as MEASUREMENT_DATETIME,
   NULL as MEASUREMENT_TIME,
   MEASUREMENT_TYPE_CONCEPT_ID,
   OPERATOR_CONCEPT_ID,
   VALUE_AS_NUMBER,
   VALUE_AS_CONCEPT_ID,
   UNIT_CONCEPT_ID,
   RANGE_LOW,
   RANGE_HIGH,
   PROVIDER_ID,
   VISIT_OCCURRENCE_ID,
   NULL as VISIT_DETAIL_ID,
   MEASUREMENT_SOURCE_VALUE,
   MEASUREMENT_SOURCE_CONCEPT_ID,
   NULL as UNIT_SOURCE_VALUE,
   NULL as VALUE_SOURCE_VALUE
FROM @cdmDatabaseSchema.MEASUREMENT m
JOIN @resultsDatabaseSchema.N3C_COHORT n
  ON M.PERSON_ID = N.PERSON_ID
WHERE m.MEASUREMENT_DATE >= '1/1/2018';

--OBSERVATION
--OUTPUT_FILE: OBSERVATION.csv
SELECT
   OBSERVATION_ID,
   n.PERSON_ID,
   OBSERVATION_CONCEPT_ID,
   CONVERT(VARCHAR(20),OBSERVATION_DATE, 120) as OBSERVATION_DATE,
   CONVERT(VARCHAR(20),OBSERVATION_DATETIME, 120) as OBSERVATION_DATETIME,
   OBSERVATION_TYPE_CONCEPT_ID,
   VALUE_AS_NUMBER,
   VALUE_AS_STRING,
   VALUE_AS_CONCEPT_ID,
   QUALIFIER_CONCEPT_ID,
   UNIT_CONCEPT_ID,
   PROVIDER_ID,
   VISIT_OCCURRENCE_ID,
   NULL as VISIT_DETAIL_ID,
   OBSERVATION_SOURCE_VALUE,
   OBSERVATION_SOURCE_CONCEPT_ID,
   NULL as UNIT_SOURCE_VALUE,
   NULL as QUALIFIER_SOURCE_VALUE
FROM @cdmDatabaseSchema.OBSERVATION o
JOIN @resultsDatabaseSchema.N3C_COHORT n
  ON O.PERSON_ID = N.PERSON_ID
WHERE o.OBSERVATION_DATE >= '1/1/2018';

--LOCATION
--OUTPUT_FILE: LOCATION.csv
SELECT
   l.LOCATION_ID,
   null as ADDRESS_1, -- to avoid identifying information
   null as ADDRESS_2, -- to avoid identifying information
   CITY,
   STATE,
   ZIP,
   COUNTY,
   NULL as LOCATION_SOURCE_VALUE
FROM @cdmDatabaseSchema.LOCATION l
JOIN (
        SELECT DISTINCT cs.LOCATION_ID
        FROM @cdmDatabaseSchema.VISIT_OCCURRENCE vo
        JOIN @resultsDatabaseSchema.N3C_COHORT n
          ON vo.person_id = n.person_id
        JOIN @cdmDatabaseSchema.CARE_SITE cs
          ON vo.care_site_id = cs.care_site_id
        UNION
        SELECT DISTINCT p.LOCATION_ID
        FROM @cdmDatabaseSchema.PERSON p
        JOIN @resultsDatabaseSchema.N3C_COHORT n
          ON p.person_id = n.person_id
      ) a
  ON l.location_id = a.location_id
;

--CARE_SITE
--OUTPUT_FILE: CARE_SITE.csv
SELECT
   cs.CARE_SITE_ID,
   CARE_SITE_NAME,
   PLACE_OF_SERVICE_CONCEPT_ID,
   LOCATION_ID,
   NULL as CARE_SITE_SOURCE_VALUE,
   NULL as PLACE_OF_SERVICE_SOURCE_VALUE
FROM @cdmDatabaseSchema.CARE_SITE cs
JOIN (
        SELECT DISTINCT CARE_SITE_ID
        FROM @cdmDatabaseSchema.VISIT_OCCURRENCE vo
        JOIN @resultsDatabaseSchema.N3C_COHORT n
          ON vo.person_id = n.person_id
      ) a
  ON cs.CARE_SITE_ID = a.CARE_SITE_ID
;

--PROVIDER
--OUTPUT_FILE: PROVIDER.csv
SELECT
   pr.PROVIDER_ID,
   null as PROVIDER_NAME, -- to avoid accidentally identifying sites
   null as NPI, -- to avoid accidentally identifying sites
   null as DEA, -- to avoid accidentally identifying sites
   SPECIALTY_CONCEPT_ID,
   CARE_SITE_ID,
   null as YEAR_OF_BIRTH,
   GENDER_CONCEPT_ID,
   null as PROVIDER_SOURCE_VALUE, -- to avoid accidentally identifying sites
   SPECIALTY_SOURCE_VALUE,
   SPECIALTY_SOURCE_CONCEPT_ID,
   GENDER_SOURCE_VALUE,
   GENDER_SOURCE_CONCEPT_ID
FROM @cdmDatabaseSchema.PROVIDER pr
JOIN (
       SELECT DISTINCT PROVIDER_ID
       FROM @cdmDatabaseSchema.VISIT_OCCURRENCE vo
       JOIN @resultsDatabaseSchema.N3C_COHORT n
          ON vo.PERSON_ID = n.PERSON_ID
       UNION
       SELECT DISTINCT PROVIDER_ID
       FROM @cdmDatabaseSchema.DRUG_EXPOSURE de
       JOIN @resultsDatabaseSchema.N3C_COHORT n
          ON de.PERSON_ID = n.PERSON_ID
       UNION
       SELECT DISTINCT PROVIDER_ID
       FROM @cdmDatabaseSchema.MEASUREMENT m
       JOIN @resultsDatabaseSchema.N3C_COHORT n
          ON m.PERSON_ID = n.PERSON_ID
       UNION
       SELECT DISTINCT PROVIDER_ID
       FROM @cdmDatabaseSchema.PROCEDURE_OCCURRENCE po
       JOIN @resultsDatabaseSchema.N3C_COHORT n
          ON po.PERSON_ID = n.PERSON_ID
       UNION
       SELECT DISTINCT PROVIDER_ID
       FROM @cdmDatabaseSchema.OBSERVATION o
       JOIN @resultsDatabaseSchema.N3C_COHORT n
          ON o.PERSON_ID = n.PERSON_ID
     ) a
 ON pr.PROVIDER_ID = a.PROVIDER_ID
;

--Note: it has yet to be decided if Era tables will be constructured downstream in Palantir platform.
-- If it is decided that eras will be reconstructed, these three tables will be omitted.

--DRUG_ERA
--OUTPUT_FILE: DRUG_ERA.csv
SELECT
   DRUG_ERA_ID,
   n.PERSON_ID,
   DRUG_CONCEPT_ID,
   CONVERT(VARCHAR(20),DRUG_ERA_START_DATE, 120) as DRUG_ERA_START_DATE,
   CONVERT(VARCHAR(20),DRUG_ERA_END_DATE, 120) as DRUG_ERA_END_DATE,
   DRUG_EXPOSURE_COUNT,
   GAP_DAYS
FROM @cdmDatabaseSchema.DRUG_ERA dre
JOIN @resultsDatabaseSchema.N3C_COHORT n
  ON DRE.PERSON_ID = N.PERSON_ID
WHERE DRUG_ERA_START_DATE >= '1/1/2018';

--DOSE_ERA
--OUTPUT_FILE: DOSE_ERA.csv

SELECT
   DOSE_ERA_ID,
   n.PERSON_ID,
   DRUG_CONCEPT_ID,
   UNIT_CONCEPT_ID,
   DOSE_VALUE,
   CONVERT(VARCHAR(20),DOSE_ERA_START_DATE, 120) as DOSE_ERA_START_DATE,
   CONVERT(VARCHAR(20),DOSE_ERA_END_DATE, 120) as DOSE_ERA_END_DATE
FROM @cdmDatabaseSchema.DOSE_ERA y JOIN @resultsDatabaseSchema.N3C_COHORT n ON y.PERSON_ID = N.PERSON_ID
WHERE y.DOSE_ERA_START_DATE >= '1/1/2018';


--CONDITION_ERA
--OUTPUT_FILE: CONDITION_ERA.csv
SELECT
   CONDITION_ERA_ID,
   n.PERSON_ID,
   CONDITION_CONCEPT_ID,
   CONVERT(VARCHAR(20),CONDITION_ERA_START_DATE, 120) as CONDITION_ERA_START_DATE,
   CONVERT(VARCHAR(20),CONDITION_ERA_END_DATE, 120) as CONDITION_ERA_END_DATE,
   CONDITION_OCCURRENCE_COUNT
FROM @cdmDatabaseSchema.CONDITION_ERA ce JOIN @resultsDatabaseSchema.N3C_COHORT n ON CE.PERSON_ID = N.PERSON_ID
WHERE CONDITION_ERA_START_DATE >= '1/1/2018';

--DATA_COUNTS TABLE
--OUTPUT_FILE: DATA_COUNTS.csv
SELECT * from
(select
   'PERSON' as TABLE_NAME,
   (select count(*) from @cdmDatabaseSchema.PERSON p JOIN @resultsDatabaseSchema.N3C_COHORT n ON p.PERSON_ID = n.PERSON_ID) as ROW_COUNT

UNION

select
   'OBSERVATION_PERIOD' as TABLE_NAME,
   (select count(*) from @cdmDatabaseSchema.OBSERVATION_PERIOD op JOIN @resultsDatabaseSchema.N3C_COHORT n ON op.PERSON_ID = n.PERSON_ID AND OBSERVATION_PERIOD_START_DATE >= '1/1/2018') as ROW_COUNT

UNION

select
   'VISIT_OCCURRENCE' as TABLE_NAME,
   (select count(*) from @cdmDatabaseSchema.VISIT_OCCURRENCE vo JOIN @resultsDatabaseSchema.N3C_COHORT n ON vo.PERSON_ID = n.PERSON_ID AND VISIT_START_DATE >= '1/1/2018') as ROW_COUNT

UNION

select
   'CONDITION_OCCURRENCE' as TABLE_NAME,
   (select count(*) from @cdmDatabaseSchema.CONDITION_OCCURRENCE co JOIN @resultsDatabaseSchema.N3C_COHORT n ON co.PERSON_ID = n.PERSON_ID AND CONDITION_START_DATE >= '1/1/2018') as ROW_COUNT

UNION

select
   'DRUG_EXPOSURE' as TABLE_NAME,
   (select count(*) from @cdmDatabaseSchema.DRUG_EXPOSURE de JOIN @resultsDatabaseSchema.N3C_COHORT n ON de.PERSON_ID = n.PERSON_ID AND DRUG_EXPOSURE_START_DATE >= '1/1/2018') as ROW_COUNT

UNION

select
   'PROCEDURE_OCCURRENCE' as TABLE_NAME,
   (select count(*) from @cdmDatabaseSchema.PROCEDURE_OCCURRENCE po JOIN @resultsDatabaseSchema.N3C_COHORT n ON po.PERSON_ID = n.PERSON_ID AND PROCEDURE_DATE >= '1/1/2018') as ROW_COUNT

UNION

select
   'MEASUREMENT' as TABLE_NAME,
   (select count(*) from @cdmDatabaseSchema.MEASUREMENT m JOIN @resultsDatabaseSchema.N3C_COHORT n ON m.PERSON_ID = n.PERSON_ID AND MEASUREMENT_DATE >= '1/1/2018') as ROW_COUNT

UNION

select
   'OBSERVATION' as TABLE_NAME,
   (select count(*) from @cdmDatabaseSchema.OBSERVATION o JOIN @resultsDatabaseSchema.N3C_COHORT n ON o.PERSON_ID = n.PERSON_ID AND OBSERVATION_DATE >= '1/1/2018') as ROW_COUNT

UNION

--OMOP does not have PERSON_ID for Location, Care Site and Provider tables so we need to determine the applicability of this check
--We could re-engineer the cohort table to include the JOIN variables
select
   'LOCATION' as TABLE_NAME,
   (select count(*) from @cdmDatabaseSchema.LOCATION) as ROW_COUNT

UNION

select
   'CARE_SITE' as TABLE_NAME,
   (select count(*) from @cdmDatabaseSchema.CARE_SITE) as ROW_COUNT

UNION

 select
   'PROVIDER' as TABLE_NAME,
   (select count(*) from @cdmDatabaseSchema.PROVIDER) as ROW_COUNT

UNION

select
   'DRUG_ERA' as TABLE_NAME,
   (select count(*) from @cdmDatabaseSchema.DRUG_ERA de JOIN @resultsDatabaseSchema.N3C_COHORT n ON de.PERSON_ID = n.PERSON_ID AND DRUG_ERA_START_DATE >= '1/1/2018') as ROW_COUNT
   /**
UNION

select
   'DOSE_ERA' as TABLE_NAME,
   (select count(*) from DOSE_ERA ds JOIN @resultsDatabaseSchema.N3C_COHORT n ON ds.PERSON_ID = n.PERSON_ID AND DOSE_ERA_START_DATE >= '1/1/2018') as ROW_COUNT
   **/
UNION

select
   'CONDITION_ERA' as TABLE_NAME,
   (select count(*) from @cdmDatabaseSchema.CONDITION_ERA JOIN @resultsDatabaseSchema.N3C_COHORT ON CONDITION_ERA.PERSON_ID = N3C_COHORT.PERSON_ID AND CONDITION_ERA_START_DATE >= '1/1/2018') as ROW_COUNT
) s;

--MANIFEST TABLE: CHANGE PER YOUR SITE'S SPECS
--OUTPUT_FILE: MANIFEST.csv
select
   'OHDSI' as SITE_ABBREV,
   'Jane Doe' as CONTACT_NAME,
   'jane_doe@OHDSI.edu' as CONTACT_EMAIL,
   'OMOP' as CDM_NAME,
   '5.3.1' as CDM_VERSION,
   'Y' as N3C_PHENOTYPE_YN,
   '1.3' as N3C_PHENOTYPE_VERSION,
   CONVERT(VARCHAR(20), GETDATE(), 120) as RUN_DATE,
   CONVERT(VARCHAR(20), GETDATE() -2, 120) as UPDATE_DATE,		--change integer based on your site's data latency
   CONVERT(VARCHAR(20), GETDATE() +3, 120) as NEXT_SUBMISSION_DATE;
