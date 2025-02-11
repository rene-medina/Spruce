-- MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_ADMIN_MEDS.sql
-- RM 2025.02.04 - Creation

ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = FALSE;

-- OR
CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_ADMIN_MEDS AS (
SELECT OR_SURGICAL_CASE_IDENTIFIER                          AS "or_surgical_case_identifier"
      ,OR_ENCOUNTER_IDENTIFIER                              AS "or_encounter_identifier" 
      ,MEDICATION_NAME                                      AS "medication_name"
      ,MEDICATION_ROUTE                                     AS "medication_route"
      ,MEDICATION_ROUTE_MAPPED                              AS "medication_route_mapped"
      ,SUBSTRING(MEDICATION_ADMINISTRATION_TS::STRING,1,19) AS "medication_administration_ts"
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ADMIN_MEDS
);

--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_ADMIN_MEDS
--WHERE "or_surgical_case_identifier" = 'MAIN-2024-3835';


