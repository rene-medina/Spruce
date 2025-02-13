-- MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR.sql
-- RM 2025.01.09 - Creation

--CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR AS (
SELECT OR_HEAD.SURGICAL_CASE                          AS SURGICAL_CASE_IDENTIFIER
      ,OR_HEAD.FIN                                    AS ENCOUNTER_IDENTIFIER
      ,OR_HEAD.MRN                                    AS MEDICAL_RECORD_NUMBER
      ,CDS_PAT.GENDER                                 AS PATIENT_GENDER
      ,ROUND(OR_HEAD.AGE_IN_MONTHS/12,1)              AS PATIENT_AGE_IN_YEARS
      ,OR_HEAD.AGE_IN_MONTHS                          AS PATIENT_AGE_IN_MONTHS
      ,CDS_PAT.RACE                                   AS PATIENT_RACE
      ,CDS_PAT.ETHNICITY                              AS PATIENT_ETHNICITY
      ,CDS_PAT.LANGUAGE                               AS PATIENT_LANGUAGE
      ,HT_WT.HEIGHT                                   AS HEIGHT_CM
      ,HT_WT.WEIGHT                                   AS WEIGHT_KG
      ,OR_HEAD.ASA_CLASS                              AS ASA_SCORE
      ,OR_HEAD.ENC_TYPE_DISPLAY                       AS PATIENT_CLASS
      ,OR_HEAD.FINANCIAL_CLASS_DISPLAY                AS PAYOR_DESCRIPTION
      ,CDS_PAT.ZIP_CODE                               AS ZIP_CODE
      ,'?' AS FACILITY_NAME
      ,OR_HEAD.OPERATING_ROOM                         AS OR_ROOM_IDENTIFIER
      ,'?' AS PRIMARY_PROCEDURE_NAME
      ,'?' AS MULTIPLE_PROCEDURES
      ,'?' AS AIRWAY_GRADE
      ,'?' AS SURGERY_START_TS
      ,'?' AS SURGEON_NAME
      ,'?' AS SURGICAL_SPECIALTY
      ,'?' AS WHEELED_INTO_OR_TS
      ,'?' AS SURGERY_CLOSE_TS
      ,'?' AS PACU_DISCHARGE_TS
      ,'?' AS WHEELED_OUT_OF_OR_TS
      ,'?' AS PACU_RESCUE_NAUSEA_MEDS
      ,'?' AS PACU_RESCUE_IV_OPIOIDS
      ,'?' AS PACU_RESCUE_ORAL_OPIOIDS
      ,'?' AS PACU_RESCUE_FENTANYL
      ,'?' AS PACU_RESCUE_MORPHINE
      ,'?' AS PACU_RESCUE_OXYCODONE
      ,'?' AS PACU_RESCUE_HYDROMORPHONE
      ,'?' AS SCHEDULED_START_TS
      ,'?' AS ANESTHESIA_START_TS
      ,'?' AS ANESTHESIA_READY_TS
      ,'?' AS ANESTHESIA_STOP_TS
      ,'?' AS PATIENT_ADMITTED_TO_HOSPITAL_TS
      ,'?' AS HOSPITAL_DISCHARGE_TS
      ,'?' AS PATIENT_FIRST_ADMITTED_TO_ICU_TS
      ,'?' AS PATIENT_FIRST_DISCHARGED_FROM_ICU_TS
      ,'?' AS PATIENT_EXPIRED_TS
      ,'?' AS SCHEDULED_SURGERY_TIME_MIN
FROM (SELECT SAR.RECORD_DESCRIPTION AS SURGICAL_CASE
            ,WE.PERSON_ID
            ,WE.MEDICAL_RECORD_NUMBER AS MRN
            ,WE.BIRTH_DT_TM::DATE AS DOB
            ,ROUND(DATEDIFF(DAY, WE.BIRTH_DT_TM,COALESCE(WE.REG_DT_TM, WE.INPATIENT_ADMIT_DT_TM, WE.ADMIT_ARRIVE_DATE))/(365.24/12),1) AS AGE_IN_MONTHS
            ,WE.REASON_FOR_VISIT
            ,WE.ENCOUNTER_ID
            ,WE.FINANCIAL_NUMBER AS FIN
            ,WE.ENC_TYPE_DISPLAY
            ,WE.FINANCIAL_CLASS_DISPLAY
      --      ,SAR.SURGICAL_CASE_ID 
      --      ,A.SA_ANESTHESIA_RECORD_ID
            ,B.PROC AS PROCEDURES
            ,MAX(CASE WHEN A.CASE_ATTRIBUTE_TYPE_CD = 4056672 THEN CASE_ATTRIBUTE_VALUE END) AS SURGERY_DT_TM
            ,MAX(CASE WHEN A.CASE_ATTRIBUTE_TYPE_CD = 4056669 THEN CASE_ATTRIBUTE_VALUE END) AS PREOP_DIAGNOSIS
            ,MAX(CASE WHEN A.CASE_ATTRIBUTE_TYPE_CD = 4056666 THEN CASE_ATTRIBUTE_VALUE END) AS ASA_CLASS
            ,MAX(CASE WHEN A.CASE_ATTRIBUTE_TYPE_CD = 4056668 THEN CASE_ATTRIBUTE_VALUE END) AS OPERATING_ROOM
            ,MAX(CASE WHEN A.CASE_ATTRIBUTE_TYPE_CD = 4056665 THEN CASE_ATTRIBUTE_VALUE END) AS ANESTHESIA_TYPE
      FROM (SELECT SCA.SA_ANESTHESIA_RECORD_ID
                  ,SCA.SA_CASE_ATTRIBUTE_ID 
                  ,SCA.CASE_ATTRIBUTE_TYPE_CD 
                  ,CV1.DISPLAY AS CASE_ATTRIBUTE_TYPE
                  ,CASE 
                     WHEN SCA.CASE_ATTRIBUTE_TYPE_CD IN (4056665, 4056666, 4056668) 
                       THEN CV2.DISPLAY 
                     WHEN SCA.CASE_ATTRIBUTE_TYPE_CD = 4056672 
                       THEN TRY_TO_TIMESTAMP(SCA.CASE_ATTRIBUTE_VALUE_TXT, 'YYYYMMDDHH24MISSFF')::STRING
                     ELSE SCA.CASE_ATTRIBUTE_VALUE_TXT
                   END AS CASE_ATTRIBUTE_VALUE
            FROM MCHS_DB.MCHS_PROD.SA_CASE_ATTRIBUTE          SCA
            JOIN MCHS_DB.MCHS_PROD.CODE_VALUE                 CV1
              ON CV1.CODE_VALUE = SCA.CASE_ATTRIBUTE_TYPE_CD 
            LEFT JOIN MCHS_DB.MCHS_PROD.CODE_VALUE            CV2
              ON CV2.CODE_VALUE = TRY_TO_NUMBER(SCA.CASE_ATTRIBUTE_VALUE_TXT)
            WHERE SCA.ACTIVE_IND = 1
              AND SCA.ACTIVE_STATUS_CD = 188
              AND SCA.CASE_ATTRIBUTE_TYPE_CD IN (
              --      4056670, -- Procedure
                    4056665, -- Anesthesia Type
                    4056666, -- ASA Class
                    4056668, -- OR
                    4056669, -- PreOp Diagnosis
              --      4056671, -- Surgeon
                    4056672) -- Surgery DATETIME
            QUALIFY RANK() 
              OVER (PARTITION BY SCA.SA_ANESTHESIA_RECORD_ID, SCA.CASE_ATTRIBUTE_TYPE_CD
                    ORDER BY SCA.SA_ANESTHESIA_RECORD_ID, SCA.CASE_ATTRIBUTE_TYPE_CD, 
                             SCA.ACTIVE_STATUS_DT_TM DESC) = 1
            ORDER BY SCA.SA_ANESTHESIA_RECORD_ID
                    ,SCA.CASE_ATTRIBUTE_TYPE_CD)        A
      JOIN (SELECT P.SA_ANESTHESIA_RECORD_ID 
                  ,LISTAGG(P.DISPLAY, '. ') 
                   WITHIN GROUP(ORDER BY P.SA_CASE_ATTRIBUTE_ID) AS PROC  
            FROM (SELECT A.SA_ANESTHESIA_RECORD_ID
                        ,A.SA_CASE_ATTRIBUTE_ID
                        ,CV.DISPLAY
                  FROM MCHS_DB.MCHS_PROD.SA_CASE_ATTRIBUTE  A
                  JOIN MCHS_DB.MCHS_PROD.CODE_VALUE         CV
                    ON CV.CODE_VALUE = A.CASE_ATTRIBUTE_VALUE_TXT
                  WHERE A.CASE_ATTRIBUTE_TYPE_CD = 4056670 -- Procedure
                    AND A.ACTIVE_IND = 1
                    AND A.ACTIVE_STATUS_CD = 188
                  QUALIFY RANK() OVER (PARTITION BY A.SA_ANESTHESIA_RECORD_ID
                                       ORDER BY A.SA_ANESTHESIA_RECORD_ID, A.ACTIVE_STATUS_DT_TM DESC) = 1
                  ORDER BY A.SA_ANESTHESIA_RECORD_ID, A.ACTIVE_STATUS_DT_TM DESC) P
              GROUP BY P.SA_ANESTHESIA_RECORD_ID)       B
        ON A.SA_ANESTHESIA_RECORD_ID = B.SA_ANESTHESIA_RECORD_ID
      JOIN MCHS_DB.MCHS_PROD.SA_ANESTHESIA_RECORD       SAR
        ON A.SA_ANESTHESIA_RECORD_ID = SAR.SA_ANESTHESIA_RECORD_ID
      JOIN MCHS_DB.MCHS_PROD.SURGICAL_CASE              SC
        ON SC.SURG_CASE_ID = SAR.SURGICAL_CASE_ID
      JOIN MCHS_CUSTOM_DB.ODS.VW_W_ENCOUNTER            WE
        ON WE.ENCOUNTER_ID = SC.ENCNTR_ID
      WHERE SAR.RECORD_DESCRIPTION = 'MAIN-2024-3835' -- SURGICAL_CASE
      GROUP BY SAR.RECORD_DESCRIPTION
              ,WE.PERSON_ID
              ,WE.MEDICAL_RECORD_NUMBER
              ,WE.PATIENT
              ,WE.BIRTH_DT_TM::DATE
              ,ROUND(DATEDIFF(DAY, WE.BIRTH_DT_TM,COALESCE(WE.REG_DT_TM, WE.INPATIENT_ADMIT_DT_TM, WE.ADMIT_ARRIVE_DATE))/(365.24/12),1) 
              ,WE.REASON_FOR_VISIT
              ,WE.ENCOUNTER_ID
              ,WE.FINANCIAL_NUMBER
              ,WE.ENC_TYPE_DISPLAY
              ,WE.FINANCIAL_CLASS_DISPLAY
      --        ,SAR.SURGICAL_CASE_ID 
      --        ,A.SA_ANESTHESIA_RECORD_ID
              ,B.PROC) OR_HEAD
JOIN MCHS_CUSTOM_DB.ODS.CDS_D_PATIENT CDS_PAT      
  ON OR_HEAD.PERSON_ID = CDS_PAT.PERSON_ID 
LEFT JOIN (SELECT CE.ENCNTR_ID AS ENCOUNTER_ID
                 ,MAX(CASE WHEN CE.EVENT_CD = 4154126 THEN LTRIM(RTRIM(CE.RESULT_VAL)) ELSE NULL END) AS HEIGHT
                 ,MAX(CASE WHEN CE.EVENT_CD = 4154120 THEN LTRIM(RTRIM(CE.RESULT_VAL)) ELSE NULL END) AS WEIGHT
           FROM MCHS_DB.MCHS_PROD.CLINICAL_EVENT CE 
           WHERE CE.VALID_UNTIL_DT_TM > CURRENT_TIMESTAMP()
             AND CE.RESULT_STATUS_CD = 25 -- Auth (Verified)
             AND CE.EVENT_CD IN (4154126, 4154120)
           GROUP BY CE.ENCNTR_ID) HT_WT
  ON HT_WT.ENCOUNTER_ID = OR_HEAD.ENCOUNTER_ID 

--);