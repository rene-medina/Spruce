-- MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_HOSPITAL_ADMITS.sql
-- RM 2025.02.07 - Creation

ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = FALSE;

-- HOSPITAL_ADMITS
CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_HOSPITAL_ADMITS AS (
SELECT OR_SURGICAL_CASE_IDENTIFIER                          AS "or_surgical_case_identifier"
      ,OR_ENCOUNTER_IDENTIFIER                              AS "encounter_identifier"
      ,HOSPITAL_ENCOUNTER_IDENTIFIER                        AS "hospital_encounter_identifier" 
      ,SUBSTRING(HOSPITAL_ADMIT_INPATIENT_TS::STRING,1,19)  AS "hospital_admit_inpatient_ts" 
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_HOSPITAL_ADMITS
);

-- Validation:
SELECT *
FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_HOSPITAL_ADMITS
WHERE "or_surgical_case_identifier" = 'MAIN-2024-3835';
-- No records came back, as the Surgical Case has a Encounter Type of 'Elective', and the view only returns 'Inpatient' and 'Inpatient Outside Services'.

SELECT *
FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_HOSPITAL_ADMITS;
