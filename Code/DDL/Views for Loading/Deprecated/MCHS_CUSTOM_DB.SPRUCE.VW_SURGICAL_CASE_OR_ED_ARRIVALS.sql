-- MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ED_ARRIVALS.sql
-- RM 2025.02.06 - Creation
--               - As per AdaptX specs: Include all Emergency Department arrivals for each patient represented in the surgical cases. 
--                 Include the ED arrival for the surgery itself if the surgical encounter began in the ED, and include all other 
--                 ED arrivals those patients have had.
-- RM 2025.02.07 - There are a few hundred emergencies w/o ACTUAL_ARRIVAL_DT_TM, so I'm complementing with REGISTRATION_DT_TM.

--DROP VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ED_ARRIVALS;
CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ED_ARRIVALS AS (
SELECT E.PERSON_ID                           AS NCHS_ONLY_PERSON_ID          -- Private - NCHS USE only
      ,E.ENCOUNTER_MRN                       AS NCHS_ONLY_MRN                -- Private - NCHS USE only
      ,E.ENCOUNTER_ID                        AS NCHS_ONLY_ENCOUNTER_ID       -- Private - NCHS USE only
      ,E.FINANCIAL_NUMBER                    AS NCHS_ONLY_FIN                -- Private - NCHS USE ONLY
      ,SCOR.NCHS_ONLY_SURGICAL_CASE_ID       AS NCHS_ONLY_SURGICAL_CASE_ID   -- Private - NCHS USE ONLY
      ,SCOR.SURGICAL_CASE_IDENTIFIER         AS OR_SURGICAL_CASE_IDENTIFIER
      ,E_TOKEN.ENC_REIDENT                   AS OR_ENCOUNTER_IDENTIFIER      -- De-Identified/Tokenized
      ,E_TOKEN.ENC_REIDENT                   AS ED_ENCOUNTER_IDENTIFIER      -- De-Identified/Tokenized
      ,E.ACTUAL_ARRIVAL_DT_TM                AS ED_ARRIVAL_TS
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
WHERE E.ADMISSION_TYPE_DESC = 'Emergency'
-- RM 2025.02.07 - There are a few hundred emergencies w/o ACTUAL_ARRIVAL_DT_TM, so I'm complementing with REGISTRATION_DT_TM.
  AND COALESCE(E.ACTUAL_ARRIVAL_DT_TM, E.REGISTRATION_DT_TM) >= '2022-01-01'  
);

-- Validation:
-- The following will no return records, as the ADMISSION_TYPE_DESC = 'Elective' for this surgical case, not 'Emergency'
--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ED_ARRIVALS
--WHERE OR_SURGICAL_CASE_IDENTIFIER = 'MAIN-2024-3835'; 

SELECT *
FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ED_ARRIVALS
ORDER BY NCHS_ONLY_PERSON_ID
        ,ED_ARRIVAL_TS;


-- The specification for this view has several issues:
-- 1. There is no way to tie the encounters to the patient.
-- 2. OR_ENCOUNTER_IDENTIFIER and ED_ENCOUNTER_IDENTIFIER  are the same - we don't have a separate ID for ED encounters.
-- 3. Most of our Surgical Cases are 'Elective' - the ED extract only asks for 'Emergency' encounter types. Very few of the
--    encounters in surgical_case_or will be in this ED view, and, very few of the ED encounters in the view will point back
--    to an encounter in surgical_case_or.

