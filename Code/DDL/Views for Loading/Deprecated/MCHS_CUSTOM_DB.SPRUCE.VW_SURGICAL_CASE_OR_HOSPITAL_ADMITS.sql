-- MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_HOSPITAL_ADMITS.sql
-- RM 2025.02.06 - Creation
--               - As per AdaptX specs: Include all Emergency Department arrivals for each patient represented in the surgical cases. 
--                 Include the ED arrival for the surgery itself if the surgical encounter began in the ED, and include all other 
--                 ED arrivals those patients have had.


--DROP VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_HOSPITAL_ADMITS;
CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_HOSPITAL_ADMITS AS (
SELECT E.PERSON_ID                           AS NCHS_ONLY_PERSON_ID            -- Private - NCHS USE only
      ,E.ENCOUNTER_MRN                       AS NCHS_ONLY_MRN                  -- Private - NCHS USE only
      ,E.ENCOUNTER_ID                        AS NCHS_ONLY_ENCOUNTER_ID         -- Private - NCHS USE only
      ,E.FINANCIAL_NUMBER                    AS NCHS_ONLY_FIN                  -- Private - NCHS USE ONLY
      ,SCOR.NCHS_ONLY_SURGICAL_CASE_ID       AS NCHS_ONLY_SURGICAL_CASE_ID     -- Private - NCHS USE ONLY
      ,SCOR.SURGICAL_CASE_IDENTIFIER         AS OR_SURGICAL_CASE_IDENTIFIER
      ,E_TOKEN.ENC_REIDENT                   AS OR_ENCOUNTER_IDENTIFIER        -- De-Identified/Tokenized
      ,E_TOKEN.ENC_REIDENT                   AS HOSPITAL_ENCOUNTER_IDENTIFIER  -- De-Identified/Tokenized
      ,E.INPATIENT_ADMIT_DT_TM               AS HOSPITAL_ADMIT_INPATIENT_TS
      ,CURRENT_TIMESTAMP                     AS DW_UPDATE_TS
FROM MCHS_CUSTOM_DB.ODS.CDS_F_ENCOUNTER                  E
JOIN (SELECT DISTINCT NCHS_ONLY_PERSON_ID AS PERSON_ID
      FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR)       DRIVER
  ON DRIVER.PERSON_ID = E.PERSON_ID
LEFT JOIN MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR         SCOR
  ON SCOR.NCHS_ONLY_ENCOUNTER_ID = E.ENCOUNTER_ID
LEFT JOIN MCHS_CUSTOM_DB.STG_OTHER.REIDENT_ENCOUNTER     E_TOKEN
  ON E_TOKEN.ENCNTR_ID = E.ENCOUNTER_ID
LEFT JOIN MCHS_CUSTOM_DB.RESEARCH.PERSON_HASH_MRN        MRN_TOKEN
  ON MRN_TOKEN.PERSON_ID = E.PERSON_ID
WHERE E.ENCOUNTER_TYPE_DESC IN ('Inpatient', 'Inpatient Outside Services')
  AND COALESCE(E.INPATIENT_ADMIT_DT_TM, E.REGISTRATION_DT_TM) >= '2022-01-01'
);

-- Validation:
-- The following will no return records, as the ADMISSION_TYPE_DESC = 'Elective' for this surgical case, not 'Emergency'
-- A large number of surgeries are 'Outpatient'
--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_HOSPITAL_ADMITS
--WHERE OR_SURGICAL_CASE_IDENTIFIER = 'MAIN-2024-3835'; -- (ENCOUNTER_ID = 62298688)

--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR
--WHERE SURGICAL_CASE_IDENTIFIER = 'MAIN-2024-3835'; 
-- ENCOUNTER_ID       : 62298688
-- ANESTHESIA_START_TS: 2024-09-12 13:13:46
-- OR_ROOM_NAME       : OR 8
-- PATIENT_CLASS      : Outpatient in a Bed
-- SCHEDULED_START_TS : 2024-09-12 11:30:00
-- SURGERY_START_TS   : 2024-09-12 14:01:00

--SELECT *
--FROM MCHS_CUSTOM_DB.ODS.CDS_F_ENCOUNTER
--WHERE ENCOUNTER_ID = 62298688;
-- ACTUAL_ARRIVAL_DT_TM  : NULL
-- ADMISSION_TYPE_DESC   : Elective
-- CLASSIFICATION_DESC   : Outpatient
-- ENCOUNTER_TYPE_DESC   : Outpatient in a Bed
-- ESTIMATE_ARRIVAL_DT_TM: 2024-09-12 11:30:00
-- INPATIENT_ADMIT_DT_TM : NULL
-- REGISTRATION_DT_TM    : 2024-09-12 09:45:05

--SELECT DISTINCT E.ENCOUNTER_TYPE_DESC 
--FROM MCHS_CUSTOM_DB.ODS.CDS_F_ENCOUNTER                  E
--ORDER BY 1;
-- ENCOUNTER_TYPE_DESC
-- 
-- Ambulatory
-- ED Outside Services
-- Emergency
-- Global Health Services
-- History
-- History only for AP and BB
-- Inpatient
-- Inpatient Outside Services
-- OP/OBS Outside Services
-- Observation
-- Outpatient
-- Outpatient in a Bed
-- Physician Visit
-- PreAdmit
-- PrePhysician Visit
-- PreRecurring
-- PreRegistrant
-- Recurring
-- Results Only
-- Urgent

--SELECT DISTINCT E.ADMISSION_TYPE_DESC 
--FROM MCHS_CUSTOM_DB.ODS.CDS_F_ENCOUNTER                  E
--ORDER BY 1;
--    ADMISSION_TYPE_DESC
--     
--    Elective
--    Emergency
--    Information Not Available
--    Newborn
--    Trauma
--    Urgent


--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_HOSPITAL_ADMITS
--ORDER BY NCHS_ONLY_PERSON_ID
--        ,HOSPITAL_ADMIT_INPATIENT_TS; -- 19,041 on 2025.02.07


-- The specification for this view has several issues:
-- 1. There is no way to tie the encounters to the patient.
-- 2. OR_ENCOUNTER_IDENTIFIER and ED_ENCOUNTER_IDENTIFIER  are the same - we don't have a separate ID for ED encounters.
-- 3. Most of our Surgical Cases are 'Elective' - the ED extract only asks for 'Emergency' encounter types. Very few of the
--    encounters in surgical_case_or will be in this ED view, and, very few of the ED encounters in the view will point back
--    to an encounter in surgical_case_or.
