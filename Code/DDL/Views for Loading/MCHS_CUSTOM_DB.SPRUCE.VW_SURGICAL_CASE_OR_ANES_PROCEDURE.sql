-- MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ANES_PROCEDURE.sql
-- RM 2025.02.03 - Creation


--DROP VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ANES_PROCEDURE;
CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ANES_PROCEDURE AS (
SELECT SCOR.NCHS_ONLY_PERSON_ID              AS NCHS_ONLY_PERSON_ID 
      ,SCOR.NCHS_ONLY_MRN                    AS NCHS_ONLY_MRN 
      ,SCOR.NCHS_ONLY_ENCOUNTER_ID           AS NCHS_ONLY_ENCOUNTER_ID 
      ,SCOR.NCHS_ONLY_FIN                    AS NCHS_ONLY_FIN
      ,SCOR.NCHS_ONLY_SURGICAL_CASE_ID       AS NCHS_ONLY_SURGICAL_CASE_ID
      ,SCOR.SURGICAL_CASE_IDENTIFIER         AS OR_SURGICAL_CASE_IDENTIFIER
      ,SCOR.ENCOUNTER_IDENTIFIER             AS OR_ENCOUNTER_IDENTIFIER
      ,PROC.PROCEDURE_CODE                   AS CPT_CODE
      ,PROC.PROCEDURE_DESC                   AS CPT_DESCRIPTION
      ,CURRENT_TIMESTAMP                     AS DW_UPDATE_TS
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR SCOR
JOIN MCHS_CUSTOM_DB.ODS.CDS_F_PROCEDURE     PROC
  ON PROC.ENCOUNTER_ID = SCOR.NCHS_ONLY_ENCOUNTER_ID 
WHERE PROC.SOURCE_VOCABULARY_DESC = 'CPT4'  
);

-- Validation:
--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ANES_PROCEDURE
--WHERE OR_SURGICAL_CASE_IDENTIFIER = 'MAIN-2024-3835';

