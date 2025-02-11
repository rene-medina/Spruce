-- MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_ICD.sql
-- RM 2025.02.05 - Creation

ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = FALSE;

-- ICD
-- RM 2025.02.05 - Notice that the same diagnosis can be given on an encounter multiple times (at admission, discharge, etc.),
--                 but since there is no timestamp of diagnosis type in the extract, I added a DISTINCT to remove duplicates.
CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_ICD AS (
SELECT DISTINCT
       OR_SURGICAL_CASE_IDENTIFIER    AS "or_surgical_case_identifier"
      ,OR_ENCOUNTER_IDENTIFIER        AS "encounter_identifier"
      ,ICD10_CODE                     AS "icd10_code"
      ,ICD10_DESCRIPTION              AS "icd10_description"
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ICD
);

SELECT *
FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_ICD
WHERE "or_surgical_case_identifier" = 'MAIN-2024-3835';

