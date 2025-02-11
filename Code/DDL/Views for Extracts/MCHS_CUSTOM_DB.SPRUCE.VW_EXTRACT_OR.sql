-- MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR.sql
-- RM 2025.01.31 - Creation

ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = FALSE;

-- OR
CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR AS (
SELECT SURGICAL_CASE_IDENTIFIER                             AS "surgical_case_identifier"
      ,ENCOUNTER_IDENTIFIER                                 AS "encounter_identifier" 
      ,MEDICAL_RECORD_NUMBER                                AS "medical_record_number" 
      ,LEGAL_SEX                                            AS "legal_sex" 
      ,RACE                                                 AS "race" 
      ,ETHNICITY                                            AS "ethnicity" 
      ,LANGUAGE                                             AS "language" 
      ,ZIP_CODE                                             AS "zip_code" 
      ,HEIGHT_CM                                            AS "height_cm" 
      ,WEIGHT_KG                                            AS "weight_kg" 
      ,FACILITY_NAME                                        AS "facility_name" 
      ,PATIENT_AGE_IN_YEARS                                 AS "patient_age_in_years" 
      ,PATIENT_AGE_IN_MONTHS                                AS "patient_age_in_months" 
      ,PRIMARY_PAYOR_NAME                                   AS "primary_payor_name" 
      ,PRIMARY_PAYOR_FINANCIAL_CLASS                        AS "primary_payor_financial_class" 
      ,PATIENT_CLASS                                        AS "patient_class" 
      ,OR_ROOM_NAME                                         AS "or_room_name" 
      ,PRIMARY_PROCEDURE_NAME                               AS "primary_procedure_name" 
      ,PROCEDURE_COUNT                                      AS "procedure_count" 
      ,CASE_ELECTIVE                                        AS "case_elective" 
      ,SUBSTRING(SCHEDULED_START_TS::STRING,1,19)           AS "scheduled_start_ts" 
      ,PRIMARY_SURGEON_NAME                                 AS "primary_surgeon_name"
      ,SURGICAL_SPECIALTY                                   AS "surgical_specialty"
      ,SUBSTRING(WHEELED_INTO_OR_TS::STRING,1,19)           AS "wheeled_into_or_ts" 
      ,SUBSTRING(SURGERY_START_TS::STRING,1,19)             AS "surgery_start_ts"
      ,SUBSTRING(SURGICAL_CLOSE_TS::STRING,1,19)            AS "surgical_close_ts"
      ,SUBSTRING(WHEELED_OUT_OF_OR_TS::STRING,1,19)         AS "wheeled_out_of_or_ts"
      ,SUBSTRING(HOSPITAL_ADMIT_INPATIENT_TS::STRING,1,19)  AS "hospital_admit_inpatient_ts"
      ,SUBSTRING(HOSPITAL_DISCHARGE_TS::STRING,1,19)        AS "hospital_discharge_ts"
      ,ASA_SCORE                                            AS "asa_score"
      ,AIRWAY_GRADE                                         AS "airway_grade"
      ,SUBSTRING(ANESTHESIA_START_TS::STRING,1,19)          AS "anesthesia_start_ts"
      ,SUBSTRING(ANESTHESIA_READY_TS::STRING,1,19)          AS "anesthesia_ready_ts"
      ,SUBSTRING(ANESTHESIA_STOP_TS::STRING,1,19)           AS "anesthesia_stop_ts"
      ,SUBSTRING(PACU_1_ADMIT_TS::STRING,1,19)              AS "pacu_1_admit_ts"
      ,SUBSTRING(PACU_1_DISCHARGE_TS::STRING,1,19)          AS "pacu_1_discharge_ts"
      ,SUBSTRING(PACU_2_ADMIT_TS::STRING,1,19)              AS "pacu_2_admit_ts"
      ,SUBSTRING(PACU_2_DISCHARGE_TS::STRING,1,19)          AS "pacu_2_discharge_ts"
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR
);

--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR
--WHERE "surgical_case_identifier" = 'MAIN-2024-3835';
