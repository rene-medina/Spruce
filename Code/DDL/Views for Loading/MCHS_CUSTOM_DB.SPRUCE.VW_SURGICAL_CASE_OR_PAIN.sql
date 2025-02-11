-- MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_PAIN.sql
-- RM 2025.02.05 - Creation
--               - Notice that I can't use MCHS_CUSTOM_DB.ODS.T_PAIN_SCORE_COMPLIANCE, because it only contains 
--                 Pain Scores between 4 and 10.

CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_PAIN AS (
SELECT SCOR.NCHS_ONLY_PERSON_ID                        AS NCHS_ONLY_PERSON_ID            -- Private - NCHS USE only
      ,SCOR.NCHS_ONLY_MRN                              AS NCHS_ONLY_MRN                  -- Private - NCHS USE only
      ,SCOR.NCHS_ONLY_ENCOUNTER_ID                     AS NCHS_ONLY_ENCOUNTER_ID         -- Private - NCHS USE only
      ,SCOR.NCHS_ONLY_FIN                              AS NCHS_ONLY_FIN                  -- Private - NCHS USE ONLY
      ,SCOR.NCHS_ONLY_SURGICAL_CASE_ID                 AS NCHS_ONLY_SURGICAL_CASE_ID     -- Private - NCHS USE ONLY
      ,CE.CLINICAL_EVENT_ID                            AS NCHS_ONLY_CLINICAL_EVENT_ID    -- Private - NCHS USE ONLY
      ,CE.EVENT_CD                                     AS NCHS_ONLY_EVENT_CD             -- Private - NCHS USE ONLY 
      ,CV.DISPLAY                                      AS NCHS_ONLY_EVENT                -- Private - NCHS USE ONLY
      ,SCOR.SURGICAL_CASE_IDENTIFIER                   AS OR_SURGICAL_CASE_IDENTIFIER   
      ,SCOR.ENCOUNTER_IDENTIFIER                       AS OR_ENCOUNTER_IDENTIFIER       
      ,CE.RESULT_VAL                                   AS PAIN_SCORE
      ,CE.EVENT_END_DT_TM                              AS PAIN_SCORE_TS
      ,CURRENT_TIMESTAMP                               AS DW_UPDATE_TS
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR     SCOR
JOIN MCHS_DB.MCHS_PROD.CLINICAL_EVENT      CE
  ON SCOR.NCHS_ONLY_ENCOUNTER_ID = CE.ENCNTR_ID
JOIN MCHS_DB.MCHS_PROD.CODE_VALUE          CV
  ON CV.CODE_VALUE = CE.EVENT_CD 
WHERE CE.EVENT_CD IN (18847235  -- CRIES, Score
                     ,18769219  -- FACES Pain Score
                     ,18847194  -- FLACCr, Score
                     ,4247435)  -- Numeric Pain Score
  AND CE.RESULT_STATUS_CD = 25  -- Valid
  AND CE.RESULT_VAL IS NOT NULL 
);

-- Validation
-- SELECT *
-- FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_PAIN
-- WHERE OR_SURGICAL_CASE_IDENTIFIER = 'MAIN-2024-3835'
-- ORDER BY OR_SURGICAL_CASE_IDENTIFIER,
--          PAIN_SCORE_TS;
--
--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_PAIN
--WHERE PAIN_SCORE < 0 OR PAIN_SCORE > 10; -- No records returned
--
--SELECT DISTINCT PAIN_SCORE
--FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_PAIN
--ORDER BY 1;
