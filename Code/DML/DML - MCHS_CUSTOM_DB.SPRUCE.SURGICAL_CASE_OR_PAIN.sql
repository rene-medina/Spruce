-- DML - MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_PAIN.sql
-- Initial population of MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ADMIN_MEDS
-- RM 2025.02.05 - Creation


--TRUNCATE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_PAIN;
INSERT INTO MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_PAIN
SELECT NCHS_ONLY_PERSON_ID
      ,NCHS_ONLY_MRN
      ,NCHS_ONLY_ENCOUNTER_ID
      ,NCHS_ONLY_FIN
      ,NCHS_ONLY_SURGICAL_CASE_ID
      ,NCHS_ONLY_CLINICAL_EVENT_ID
      ,NCHS_ONLY_EVENT_CD
      ,NCHS_ONLY_EVENT
      ,OR_SURGICAL_CASE_IDENTIFIER
      ,OR_ENCOUNTER_IDENTIFIER
      ,PAIN_SCORE
      ,PAIN_SCORE_TS
      ,DW_UPDATE_TS AS DW_CREATE_TS
      ,DW_UPDATE_TS AS DW_UPDATE_TS
FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_PAIN
ORDER BY OR_SURGICAL_CASE_IDENTIFIER,
         PAIN_SCORE_TS;

-- Successful 2025.02.10
-- Updated Rows    3,251,350
-- Execute time    00:00:10
-- Start time  Mon Feb 10 14:38:49 EST 2025
-- Finish time Mon Feb 10 14:39:00 EST 2025