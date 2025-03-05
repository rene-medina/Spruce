-- Return ED and Hospital Admits after a surgery, with 30-days cap.sql
-- RM 2025.02.17 - Creation

-- Scenarios:
-- 1. The first encounter is not an ED encounter, but the rest are. (Person ID 2575480) - OK
-- 2. There are 2 or more surgeries, with one or more ED encounters afterwards (Repeat the latest surgery encounter - Person ID 2577609)
-- 3. Multiple, previous encounters on the day of the surgery (ENCOUNTER_TS usually preceeds SURGERY_TS Person IDs 2581297, 2602591) 
-- 4. One surgery, multiple EDs afterwards (Person ID 2591973) - OK
-- 5. The surgery encounter and the ED encounter are the same (Person ID 2575480) - OK
-- 6. The same day of the surgery, an ED encounter takes place.
-- 7. 2 or more surgeries on different dates within the same non-ED encounter (Person ID 2602591)


-- Notice that the same encounter may have multiple surgeries on different days
SELECT E.PERSON_ID                    AS PERSON_ID
      ,E.ENCOUNTER_ID                 AS ENCOUNTER_ID
      ,E.ENCOUNTER_TYPE_DESC          AS ENCOUNTER_TYPE_DESC
      ,COALESCE(E.ACTUAL_ARRIVAL_DT_TM, 
          E.REGISTRATION_DT_TM, 
          E.INPATIENT_ADMIT_DT_TM)    AS ENCOUNTER_TS
FROM MCHS_CUSTOM_DB.ODS.CDS_F_ENCOUNTER E
WHERE ENCOUNTER_TS >= '2022-01-01'
  AND E.PERSON_ID = 8717234
ORDER BY ENCOUNTER_TS;

-- Universe of all encounters
SELECT O.NCHS_ONLY_PERSON_ID        AS PERSON_ID
      ,O.NCHS_ONLY_ENCOUNTER_ID     AS ENCOUNTER_ID
      ,O.SURGICAL_CASE_IDENTIFIER   AS SURGICAL_CASE
      ,O.SURGERY_START_TS           AS SURGERY_START
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR O 
WHERE O.NCHS_ONLY_PERSON_ID = 8717234
ORDER BY SURGERY_START;


SELECT E.PERSON_ID                    AS PERSON_ID
      ,E.ENCOUNTER_ID                 AS ENCOUNTER_ID
      ,E.ENCOUNTER_TYPE_DESC          AS ENCOUNTER_TYPE_DESC
      ,COALESCE(E.ACTUAL_ARRIVAL_DT_TM, 
          E.REGISTRATION_DT_TM, 
          E.INPATIENT_ADMIT_DT_TM)    AS ENCOUNTER_TS
FROM MCHS_CUSTOM_DB.ODS.CDS_F_ENCOUNTER E
WHERE E.ENCOUNTER_TYPE_DESC IN ('Inpatient', 'Inpatient Outside Services')
  AND ENCOUNTER_TS >= '2022-01-01'
  AND E.PERSON_ID = 8717234
ORDER BY ENCOUNTER_TS;



-- Cartesian: (2 Inpatient Encounters * 9 Surgical Cases) = 18 records
SELECT E.PERSON_ID                    AS PERSON_ID
      ,E.ENCOUNTER_ID                 AS ENCOUNTER_ID
      ,E.ENCOUNTER_TYPE_DESC          AS ENCOUNTER_TYPE_DESC
      ,COALESCE(E.ACTUAL_ARRIVAL_DT_TM, 
          E.REGISTRATION_DT_TM, 
          E.INPATIENT_ADMIT_DT_TM)    AS ENCOUNTER_TS
      ,O.SURGICAL_CASE_IDENTIFIER     AS SURGICAL_CASE
      ,O.SURGERY_START_TS             AS SURGERY_START
      ,DATEDIFF(DAY, 
         SURGERY_START,
         ENCOUNTER_TS
         )               AS DAYS_SINCE_SURGERY 
FROM MCHS_CUSTOM_DB.ODS.CDS_F_ENCOUNTER E
JOIN MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR O 
  ON O.NCHS_ONLY_PERSON_ID = E.PERSON_ID
WHERE E.ENCOUNTER_TYPE_DESC IN ('Inpatient', 'Inpatient Outside Services')
  AND DAYS_SINCE_SURGERY BETWEEN 0 AND 30
  AND E.PERSON_ID = 8717234
UNION
SELECT E.PERSON_ID                    AS PERSON_ID
      ,E.ENCOUNTER_ID                 AS ENCOUNTER_ID
      ,E.ENCOUNTER_TYPE_DESC          AS ENCOUNTER_TYPE_DESC
      ,COALESCE(E.ACTUAL_ARRIVAL_DT_TM, 
          E.REGISTRATION_DT_TM, 
          E.INPATIENT_ADMIT_DT_TM)    AS ENCOUNTER_TS
      ,O.SURGICAL_CASE_IDENTIFIER     AS SURGICAL_CASE
      ,O.SURGERY_START_TS             AS SURGERY_START
      ,DATEDIFF(DAY, 
         SURGERY_START,
         ENCOUNTER_TS
         )               AS DAYS_SINCE_SURGERY 
FROM MCHS_CUSTOM_DB.ODS.CDS_F_ENCOUNTER E
JOIN MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR O 
  ON O.NCHS_ONLY_PERSON_ID = E.PERSON_ID
 AND O.NCHS_ONLY_ENCOUNTER_ID = E.ENCOUNTER_ID 
   AND E.PERSON_ID = 8717234
ORDER BY PERSON_ID
        ,ENCOUNTER_TS
        ,SURGERY_START;
