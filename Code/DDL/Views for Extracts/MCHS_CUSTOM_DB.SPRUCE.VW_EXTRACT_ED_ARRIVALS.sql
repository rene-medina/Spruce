-- MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_ED_ARRIVALS.sql
-- RM 2025.02.05 - Creation

ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = FALSE;

-- PAIN
CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_ED_ARRIVALS AS (
SELECT OR_SURGICAL_CASE_IDENTIFIER            AS "or_surgical_case_identifier"
      ,OR_ENCOUNTER_IDENTIFIER                AS "encounter_identifier"
      ,ED_ENCOUNTER_IDENTIFIER                AS "ed_encounter_identifier"
      ,SUBSTRING(ED_ARRIVAL_TS::STRING,1,19)  AS "ed_arrival_ts" 
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ED_ARRIVALS
);

-- Validation:
--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_ED_ARRIVALS
--WHERE "or_surgical_case_identifier" = 'MAIN-2024-3835';
-- No records came back, as the Surgical Case has a Encounter Type of 'Elective', and the view only returns 'Emergency".'
