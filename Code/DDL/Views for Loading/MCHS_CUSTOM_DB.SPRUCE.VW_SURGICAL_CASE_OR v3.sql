-- MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR v3.sql
-- RM 2025.01.20 - Creation
-- RM 2025.01.27 - Added NCHS-only fields, DW_UPDATE_TS and the de-identified/tokenized IDs, 
--                 using the tables suggested by Carlos today. 
-- RM 2025.01.28 - Added SURG_CASE_ID
-- RM 2005.02.06 - Added the SC.SURGERY_START_TS > '2022-01-01' filter here too (it was only in the INSERT script)
-- RM 2025.02.07 - Added a MRN filter in the join, as PERSON_HASH_MRN includes Active and Inactive MRNs, but it does 
--                 not tell which is the active one.

CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR AS (
SELECT PAT.PERSON_ID                                   AS NCHS_ONLY_PERSON_ID        -- Private - NCHS USE only
      ,PAT.MRN                                         AS NCHS_ONLY_MRN              -- Private - NCHS USE only
      ,SC.ENCOUNTER_ID                                 AS NCHS_ONLY_ENCOUNTER_ID     -- Private - NCHS USE only
      ,E.FINANCIAL_NUMBER                              AS NCHS_ONLY_FIN              -- Private - NCHS USE ONLY
      ,SC.SURG_CASE_ID                                 AS NCHS_ONLY_SURGICAL_CASE_ID -- Private - NCHS USE ONLY
      ,SC.CASE_NUM                                     AS SURGICAL_CASE_IDENTIFIER   -- Only NCHS ID field shared with ADAPTX
      ,E_TOKEN.ENC_REIDENT                             AS ENCOUNTER_IDENTIFIER       -- De-Identified/Tokenized
      ,MRN_TOKEN.HASH_MRN                              AS MEDICAL_RECORD_NUMBER      -- De-Identified/Tokenized
      ,PAT.GENDER                                      AS LEGAL_SEX
      ,PAT.RACE                                        AS RACE
      ,PAT.ETHNICITY                                   AS ETHNICITY
      ,PAT.LANGUAGE                                    AS LANGUAGE
      ,PAT.ZIP_CODE                                    AS ZIP_CODE
      ,HT_WT.HEIGHT                                    AS HEIGHT_CM
      ,HT_WT.WEIGHT                                    AS WEIGHT_KG
      ,SC.SURG_AREA                                    AS FACILITY_NAME
      ,ROUND(DATEDIFF(DAY, PAT.BIRTH_DATE, 
         SC.SURG_START_DT_TM)/365.24,1)                AS PATIENT_AGE_IN_YEARS
      ,ROUND(DATEDIFF(DAY, PAT.BIRTH_DATE, 
         SC.SURG_START_DT_TM)/(365.24/12),1)           AS PATIENT_AGE_IN_MONTHS
      ,HP.PAYER_NAME                                   AS PRIMARY_PAYOR_NAME
      ,E.FINANCIAL_CLASS_DESC                          AS PRIMARY_PAYOR_FINANCIAL_CLASS
      ,E.ENCOUNTER_TYPE_DESC                           AS PATIENT_CLASS -- E.ENCOUNTER_TYPE_DESC is the final Type, at discharge.
      ,SC.ROOM                                         AS OR_ROOM_NAME
      ,SC.PRIMARY_PROCEDURE                            AS PRIMARY_PROCEDURE_NAME
      ,SCA.NBR_PROCS                                   AS PROCEDURE_COUNT
      ,CASE
         WHEN E.ADMISSION_TYPE_DESC = 'Elective' 
           THEN 'Yes' 
         ELSE 'No'
       END                                             AS CASE_ELECTIVE
      ,SC.SCH_START_DT_TM                              AS SCHEDULED_START_TS
      ,SC.PRIMARY_SURGEON                              AS PRIMARY_SURGEON_NAME
      ,SC.SURG_SPECIALTY                               AS SURGICAL_SPECIALTY
      ,SC.PT_IN_ROOM_DT_TM                             AS WHEELED_INTO_OR_TS 
      ,SC.SURG_START_DT_TM                             AS SURGERY_START_TS
      ,SC.SURG_STOP_DT_TM                              AS SURGICAL_CLOSE_TS
      ,SC.PT_OUT_ROOM_DT_TM                            AS WHEELED_OUT_OF_OR_TS
      ,COALESCE(E.INPATIENT_ADMIT_DT_TM, 
                E.ACTUAL_ARRIVAL_DT_TM, 
                E.REGISTRATION_DT_TM)                  AS HOSPITAL_ADMIT_INPATIENT_TS
      ,E.DISCHARGE_DT_TM                               AS HOSPITAL_DISCHARGE_TS
      ,SCA.ASA_CLASS                                   AS ASA_SCORE
      ,'<UNKNOWN>'                                     AS AIRWAY_GRADE
      ,SC.ANESTHESIA_START_DT_TM                       AS ANESTHESIA_START_TS
      ,SC.ANESTHESIA_READY_DT_TM                       AS ANESTHESIA_READY_TS
      ,SC.ANESTHESIA_STOP_DT_TM                        AS ANESTHESIA_STOP_TS
      ,SC.PT_IN_PACUI_DT_TM                            AS PACU_1_ADMIT_TS
      ,SC.PT_DISCH_PACUI_DT_TM                         AS PACU_1_DISCHARGE_TS
      ,SC.PT_IN_PACUII_DT_TM                           AS PACU_2_ADMIT_TS
      ,SC.PT_DISCH_PACUII_DT_TM                        AS PACU_2_DISCHARGE_TS
      ,CURRENT_TIMESTAMP                               AS DW_UPDATE_TS 
FROM MCHS_CUSTOM_DB.ODS.CDS_F_SURGERY_CASE    SC
JOIN MCHS_CUSTOM_DB.ODS.CDS_F_ENCOUNTER       E
  ON SC.ENCOUNTER_ID = E.ENCOUNTER_ID
JOIN MCHS_CUSTOM_DB.ODS.CDS_D_PATIENT         PAT
  ON SC.PERSON_ID = PAT.PERSON_ID 
JOIN MCHS_CUSTOM_DB.ODS.CDS_D_HEALTH_PLAN     HP
  ON E.PRIMARY_HEALTH_PLAN_ID = HP.HEALTH_PLAN_ID
JOIN MCHS_DB.MCHS_PROD.SA_ANESTHESIA_RECORD   SAR
  ON SC.SURG_CASE_ID = SAR.SURGICAL_CASE_ID
JOIN (SELECT A.SA_ANESTHESIA_RECORD_ID
            ,MAX(CASE 
                   WHEN A.CASE_ATTRIBUTE_TYPE_CD = 4056666 THEN V.DISPLAY 
                   ELSE NULL
                 END) AS ASA_CLASS
            ,SUM(CASE 
                   WHEN A.CASE_ATTRIBUTE_TYPE_CD = 4056670 THEN 1
                   ELSE 0
                 END) AS NBR_PROCS
      FROM MCHS_DB.MCHS_PROD.SA_CASE_ATTRIBUTE A
      LEFT JOIN MCHS_DB.MCHS_PROD.CODE_VALUE   V
        ON V.CODE_VALUE = TRY_TO_NUMBER(A.CASE_ATTRIBUTE_VALUE_TXT)
       AND A.CASE_ATTRIBUTE_TYPE_CD = 4056666
      WHERE A.CASE_ATTRIBUTE_TYPE_CD IN (
                4056666, -- ASA Class
                4056670) -- Procedure
        AND A.ACTIVE_IND = 1
        AND A.ACTIVE_STATUS_CD = 188
      GROUP BY A.SA_ANESTHESIA_RECORD_ID)    SCA
  ON SCA.SA_ANESTHESIA_RECORD_ID = SAR.SA_ANESTHESIA_RECORD_ID
LEFT JOIN (SELECT CE.ENCNTR_ID AS ENCOUNTER_ID
                 ,MAX(CASE WHEN CE.EVENT_CD = 4154126 THEN LTRIM(RTRIM(CE.RESULT_VAL)) ELSE NULL END) AS HEIGHT
                 ,MAX(CASE WHEN CE.EVENT_CD = 4154120 THEN LTRIM(RTRIM(CE.RESULT_VAL)) ELSE NULL END) AS WEIGHT
           FROM MCHS_DB.MCHS_PROD.CLINICAL_EVENT CE 
           WHERE CE.VALID_UNTIL_DT_TM > CURRENT_TIMESTAMP()
             AND CE.RESULT_STATUS_CD = 25 -- Auth (Verified)
             AND CE.EVENT_CD IN (4154126, 4154120)
           GROUP BY CE.ENCNTR_ID)             HT_WT
  ON HT_WT.ENCOUNTER_ID = SC.ENCOUNTER_ID 
LEFT JOIN MCHS_CUSTOM_DB.STG_OTHER.REIDENT_ENCOUNTER E_TOKEN
  ON E_TOKEN.ENCNTR_ID = E.ENCOUNTER_ID
LEFT JOIN MCHS_CUSTOM_DB.RESEARCH.PERSON_HASH_MRN MRN_TOKEN
  ON MRN_TOKEN.PERSON_ID = E.PERSON_ID
-- RM 2025.02.07 - Added a MRN filter in the join, as PERSON_HASH_MRN includes Active and Inactive MRNs, but it does 
--                 not tell which is the active one.
 AND MRN_TOKEN.MRN = E.ENCOUNTER_MRN
-- RM 2005.02.06 - Added the SC.SURGERY_START_TS > '2022-01-01' filter here too (it was only in the INSERT script)
WHERE SC.SURG_START_DT_TM > '2022-01-01'
);

SELECT *
FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR
--WHERE SURGICAL_CASE_IDENTIFIER = 'MAIN-2024-3835';
WHERE HOSPITAL_ADMIT_INPATIENT_TS <= '2022-01-01';

-- 
--SELECT COUNT(*)
--FROM STG_OTHER.REIDENT_ENCOUNTER -- 13,736,734
--FROM MCHS_CUSTOM_DB.ODS.CDS_F_ENCOUNTER -- 13,661,425

--SELECT COUNT(*)
--FROM RESEARCH.PERSON_HASH_MRN -- 1,824,633
--FROM MCHS_CUSTOM_DB.ODS.CDS_D_PATIENT -- 1,802,311

--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR
--WHERE SURGICAL_CASE_IDENTIFIER = 'MAIN-2023-1668'; -- Has 3 values in MCHS_CUSTOM_DB.RESEARCH.PERSON_HASH_MRN: 569066583627050, 8555150818381560746 and 902651166623897
--
--SELECT *
--FROM MCHS_CUSTOM_DB.RESEARCH.PERSON_HASH_MRN 
--WHERE PERSON_ID = 4705281; -- 3 MRNs, including some probably merged, but the table doesn't keep an active flag.
