-- MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_STAFF.sql
-- RM 2025.01.28 - Creation
-- RM 2025.02.26 - Added new role mappings using AdaptX' email of 2025.02.25 

CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_STAFF AS (
SELECT DISTINCT
       SCOR.NCHS_ONLY_PERSON_ID                        AS NCHS_ONLY_PERSON_ID            -- Private - NCHS USE only
      ,SCOR.NCHS_ONLY_MRN                              AS NCHS_ONLY_MRN                  -- Private - NCHS USE only
      ,SCOR.NCHS_ONLY_ENCOUNTER_ID                     AS NCHS_ONLY_ENCOUNTER_ID         -- Private - NCHS USE only
      ,SCOR.NCHS_ONLY_FIN                              AS NCHS_ONLY_FIN                  -- Private - NCHS USE ONLY
      ,SCOR.NCHS_ONLY_SURGICAL_CASE_ID                 AS NCHS_ONLY_SURGICAL_CASE_ID     -- Private - NCHS USE ONLY
      ,CAT.CASE_ATTENDEE_ID                            AS NCHS_ONLY_PROVIDER_ID          -- Private - NCHS USE only
      ,CAT.ROLE_PERF_CD                                AS NCHS_ONLY_ROLE_PERFORMED_CD    -- Private - NCHS USE ONLY   
      ,CV.DISPLAY                                      AS NCHS_ONLY_STAFF_ROLE_PERFORMED -- Private - NCHS USE ONLY
      ,SCOR.SURGICAL_CASE_IDENTIFIER                   AS OR_SURGICAL_CASE_IDENTIFIER
      ,SCOR.ENCOUNTER_IDENTIFIER                       AS OR_ENCOUNTER_IDENTIFIER
      ,TRIM(REPLACE(REPLACE(REPLACE(CDS_HP.FULL_NAME,
        CHR(00),''),CHR(13),''),CHR(10),''))           AS STAFF_NAME
      ,CASE CV.DISPLAY
         WHEN 'Anesthesiologist of Record' THEN 'Anesthesiologist'
         WHEN 'Assistant - Anesthesia'     THEN 'CRNA'
         WHEN 'Assistant - Surgical'       THEN 'Surgical Tech'
         WHEN 'CRNA'                       THEN 'CRNA'  
         WHEN 'Circulator - Other'         THEN 'Circulating Nurse'
         WHEN 'Circulator - Primary'       THEN 'Circulating Nurse'
         WHEN 'Circulator - Relief'        THEN 'Circulating Nurse'
         WHEN 'Co-Surgeon'                 THEN 'Surgeon'
         WHEN 'Fellow - Anesthesia'        THEN 'Anesthesia Fellow'
         WHEN 'Nurse - PACU I'             THEN 'PACU Nurse'
         WHEN 'Nurse - PACU II'            THEN 'PACU Nurse'
         WHEN 'Nurse - PreOp'              THEN 'Pre-op Nurse'
         WHEN 'Primary Surgeon'            THEN 'Attending Surgeon'
         WHEN 'Resident - Anesthesia'      THEN 'Anesthesia Resident'
         WHEN 'Resident - Surgical'        THEN 'Surgery Resident'
         WHEN 'Scrub - Other'              THEN 'Surgical Tech'
         WHEN 'Scrub - Primary'            THEN 'Surgical Tech'
         WHEN 'Scrub - Private'            THEN 'Surgical Tech'
         WHEN 'Scrub - Relief'             THEN 'Surgical Tech'
         WHEN 'Surgeon - Other'            THEN 'Surgeon'
         WHEN 'Tech - Anesthesia'          THEN 'Anesthesia Tech'
         ELSE '<UNKNOWN>'
       END                                             AS STAFF_ROLE
      ,CURRENT_TIMESTAMP                               AS DW_UPDATE_TS 
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR            SCOR
-- RM 2025.01.28 - Can't use CDS_F_SURGERY_CASE for staff, as ADAPTX is asking for additional and/or more 
--                 granular roles than the ones in this CDS table.
JOIN MCHS_DB.MCHS_PROD.CASE_ATTENDANCE                  CAT
  ON SCOR.NCHS_ONLY_SURGICAL_CASE_ID = CAT.SURG_CASE_ID
 AND CAT.ACTIVE_IND = 1
JOIN MCHS_DB.MCHS_PROD.PRSNL                            PRSNL
  ON CAT.CASE_ATTENDEE_ID = PRSNL.PERSON_ID
 AND CAT.ACTIVE_IND = 1
 AND PRSNL.ACTIVE_IND = 1
JOIN MCHS_CUSTOM_DB.ODS.CDS_D_HEALTHCARE_PROFESSIONAL   CDS_HP
  ON CDS_HP.PERSON_ID = PRSNL.PERSON_ID 
JOIN MCHS_DB.MCHS_PROD.CODE_VALUE CV
  ON CV.CODE_VALUE = CAT.ROLE_PERF_CD
WHERE LEN(TRIM(CV.DISPLAY)) > 1 
);

SELECT *
FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_STAFF
WHERE OR_SURGICAL_CASE_IDENTIFIER = 'MAIN-2024-3835'

