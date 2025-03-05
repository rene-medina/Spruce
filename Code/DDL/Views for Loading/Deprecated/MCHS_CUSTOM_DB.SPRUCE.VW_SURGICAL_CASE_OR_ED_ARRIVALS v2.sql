-- MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ED_ARRIVALS v2.sql
-- RM 2025.02.06 - Creation
--               - As per AdaptX specs: Include all Emergency Department arrivals for each patient represented in the surgical cases. 
--                 Include the ED arrival for the surgery itself if the surgical encounter began in the ED, and include all other 
--                 ED arrivals those patients have had.
-- RM 2025.02.07 - There are a few hundred emergencies w/o ACTUAL_ARRIVAL_DT_TM, so I'm complementing with REGISTRATION_DT_TM.
-- RM 2025.02.17 - The following is an intentional Cartessian Product, as ADAPTX asked to repeat the same SURGICAL_CASE_IDENTIFIER on all of the patient's encounters.

--DROP VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ED_ARRIVALS;
CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ED_ARRIVALS AS (
SELECT E.PERSON_ID                           AS NCHS_ONLY_PERSON_ID          -- Private - NCHS USE only
      ,E.ENCOUNTER_MRN                       AS NCHS_ONLY_MRN                -- Private - NCHS USE only
      ,E.ENCOUNTER_ID                        AS NCHS_ONLY_ENCOUNTER_ID       -- Private - NCHS USE only
      ,E.FINANCIAL_NUMBER                    AS NCHS_ONLY_FIN                -- Private - NCHS USE ONLY
      ,COALESCE(E.ACTUAL_ARRIVAL_DT_TM, 
                E.REGISTRATION_DT_TM, 
                E.INPATIENT_ADMIT_DT_TM)     AS NCHS_ONLY_ENCOUNTER_DATE     -- Private - NCHS USE ONLY
      ,SCOR.SURGERY_START_TS                 AS NCHS_ONLY_SURGERY_START_TS   -- Private - NCHS USE ONLY       
      ,DATEDIFF(DAY, 
         NCHS_ONLY_SURGERY_START_TS, 
         NCHS_ONLY_ENCOUNTER_DATE)           AS NCHS_ONLY_DAYS_SINCE_SC      -- Private - NCHS USE ONLY
      ,SCOR.NCHS_ONLY_SURGICAL_CASE_ID       AS NCHS_ONLY_SURGICAL_CASE_ID   -- Private - NCHS USE ONLY
      ,SCOR.SURGICAL_CASE_IDENTIFIER         AS OR_SURGICAL_CASE_IDENTIFIER
      ,E_TOKEN.ENC_REIDENT                   AS OR_ENCOUNTER_IDENTIFIER      -- De-Identified/Tokenized
      ,E_TOKEN.ENC_REIDENT                   AS ED_ENCOUNTER_IDENTIFIER      -- De-Identified/Tokenized
      ,E.ACTUAL_ARRIVAL_DT_TM                AS ED_ARRIVAL_TS
      ,CURRENT_TIMESTAMP                     AS DW_UPDATE_TS
FROM (
      SELECT E.PERSON_ID                 AS PERSON_ID
            ,E.ENCOUNTER_ID              AS ENCOUNTER_ID
            ,COALESCE(E.ACTUAL_ARRIVAL_DT_TM, 
                E.REGISTRATION_DT_TM, 
                E.INPATIENT_ADMIT_DT_TM) AS ENCOUNTER_DATE     
            ,O.SURGERY_START_TS          AS SURGERY_START_TS
            ,LAG(O.SURGERY_START_TS, 1, O.SURGERY_START_TS) 
              OVER(PARTITION BY E.PERSON_ID 
              ORDER BY E.PERSON_ID
                      ,E.ENCOUNTER_ID)   AS PREVIOUS_SURGERY_START_TS
            ,DATEDIFF(DAY, SURGERY_START_TS, 
                      ENCOUNTER_DATE)    AS DAYS_SINCE_SURGERY
            ,DATEDIFF(DAY, PREVIOUS_SURGERY_START_TS, 
                      ENCOUNTER_DATE)    AS DAYS_SINCE_PREVIOUS_SURGERY
      FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR O     
      JOIN MCHS_CUSTOM_DB.ODS.CDS_F_ENCOUNTER     E
        ON O.NCHS_ONLY_PERSON_ID = E.PERSON_ID 
      WHERE E.ADMISSION_TYPE_DESC = 'Emergency'
        AND DAYS_SINCE_SURGERY BETWEEN 0 AND 30
      ORDER BY PERSON_ID 
              ,PREVIOUS_SURGERY_START_TS
    )            DRIVER
JOIN MCHS_CUSTOM_DB.ODS.CDS_F_ENCOUNTER              E
  ON DRIVER.ENCOUNTER_ID = E.ENCOUNTER_ID
-- RM 2025.02.17 - The following is an intentional Cartessian Product, as ADAPTX asked to repeat the same SURGICAL_CASE_IDENTIFIER on all of the patient's encounters.
JOIN MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR SCOR
  ON SCOR.NCHS_ONLY_PERSON_ID = DRIVER.PERSON_ID
LEFT JOIN MCHS_CUSTOM_DB.STG_OTHER.REIDENT_ENCOUNTER E_TOKEN
  ON E_TOKEN.ENCNTR_ID = E.ENCOUNTER_ID
LEFT JOIN MCHS_CUSTOM_DB.RESEARCH.PERSON_HASH_MRN    MRN_TOKEN
  ON MRN_TOKEN.PERSON_ID = E.PERSON_ID
);

-- Validation:
-- The following will no return records, as the ADMISSION_TYPE_DESC = 'Elective' for this surgical case, not 'Emergency'
--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ED_ARRIVALS
--WHERE OR_SURGICAL_CASE_IDENTIFIER = 'MAIN-2024-3835'; 

SELECT *
FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ED_ARRIVALS
WHERE NCHS_ONLY_PERSON_ID = 2575480
ORDER BY NCHS_ONLY_PERSON_ID
        ,ED_ARRIVAL_TS;


-- The specification for this view has several issues:
-- 1. There is no way to tie the encounters to the patient.
-- 2. OR_ENCOUNTER_IDENTIFIER and ED_ENCOUNTER_IDENTIFIER  are the same - we don't have a separate ID for ED encounters.
-- 3. Most of our Surgical Cases are 'Elective' - the ED extract only asks for 'Emergency' encounter types. Very few of the
--    encounters in surgical_case_or will be in this ED view, and, very few of the ED encounters in the view will point back
--    to an encounter in surgical_case_or.

