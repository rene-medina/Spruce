-- MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR.sql
-- RM 2024.09.10 - Creation
-- RM 2024.09.17 - Added NOT NULL constraints


USE DATABASE MCHS_CUSTOM_DB;
--CREATE SCHEMA SPRUCE;
--DROP TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR;

CREATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR (
      SURGICAL_CASE_IDENTIFIER                VARCHAR(400) COMMENT 'Unique surgical case identifier',
      ENCOUNTER_IDENTIFIER                    VARCHAR(400) COMMENT 'Unique patient encounter identifier',
      MEDICAL_RECORD_NUMBER                   VARCHAR(400) COMMENT 'Unique patient identifier',
      PATIENT_GENDER                          VARCHAR(400) COMMENT 'Gender',
      PATIENT_AGE_IN_YEARS                    NUMBER(38,0) COMMENT 'Age in years at the time of the surgical case',
      PATIENT_AGE_IN_MONTHS                   NUMBER(38,0) COMMENT 'Age in months at the time of the surgical case',
      PATIENT_RACE                            VARCHAR(400) COMMENT 'Race',
      PATIENT_ETHNICITY                       VARCHAR(400) COMMENT 'Ethnicity',
      PATIENT_LANGUAGE                        VARCHAR(400) COMMENT 'Patient Language',
      HEIGHT_CM                               NUMBER(38,0) COMMENT 'Height in cm',
      WEIGHT_KG                               NUMBER(38,0) COMMENT 'Weight in kg',
      ASA_SCORE                               VARCHAR(400) COMMENT 'American Society of Anesthesiologists classification',
      PATIENT_CLASS                           VARCHAR(400) COMMENT 'Patient encounter classification (inpatient, outpatient, observation)',
      PAYOR_DESCRIPTION                       VARCHAR(400) COMMENT 'Patient primary payor description',
      ZIP_CODE                                VARCHAR(400) COMMENT 'Patient Zip code',
      FACILITY_NAME                           VARCHAR(400) COMMENT 'Site of service where surgery was performed',
      OR_ROOM_IDENTIFIER                      VARCHAR(400) COMMENT 'Room name/number where surgery was performed',
      PRIMARY_PROCEDURE_NAME                  VARCHAR(400) COMMENT 'Internal procedure name',
      MULTIPLE_PROCEDURES                     VARCHAR(400) COMMENT 'Indicates multiple procedures performed during the same case',
      AIRWAY_GRADE                            VARCHAR(400) COMMENT 'Airway Grade',
      SURGERY_START_TS                        TIMESTAMP_LTZ(9) COMMENT 'Surgery Start TS',
      SURGEON_NAME                            VARCHAR(400) COMMENT 'Primary surgeon',
      SURGICAL_SPECIALTY                      VARCHAR(400) COMMENT 'Primary Surgical specialty',
      WHEELED_INTO_OR_TS                      TIMESTAMP_LTZ(9) COMMENT 'Patient wheeled into the OR TS',
      SURGERY_CLOSE_TS                        TIMESTAMP_LTZ(9) COMMENT 'Surgery close TS',
      PACU_DISCHARGE_TS                       TIMESTAMP_LTZ(9) COMMENT 'Patient discharged from the PACU TS',
      WHEELED_OUT_OF_OR_TS                    TIMESTAMP_LTZ(9) COMMENT 'Patient wheeled out of the OR TS',
      PACU_RESCUE_NAUSEA_MEDS                 VARCHAR(400) COMMENT 'Indicates an administration of a nausea med in the PACU (Metoclopramide, Ondansetron, Diphenhydramine, etc.)',
      PACU_RESCUE_IV_OPIOIDS                  VARCHAR(400) COMMENT 'Indicates an administration of an IV opioid in the PACU (Fentanyl, Morphine, Hydromorphone, etc.)',
      PACU_RESCUE_ORAL_OPIOIDS                VARCHAR(400) COMMENT 'Indicates an administration of an oral opioids in the PACU (Oxycodone, Vicodin, etc.)',
      PACU_RESCUE_FENTANYL                    VARCHAR(400) COMMENT 'Indicates an administration of fentanyl in the PACU',
      PACU_RESCUE_MORPHINE                    VARCHAR(400) COMMENT 'Indicates an administration of morphine in the PACU',
      PACU_RESCUE_OXYCODONE                   VARCHAR(400) COMMENT 'Indicates an administration of oxycodone in PACU',
      PACU_RESCUE_HYDROMORPHONE               VARCHAR(400) COMMENT 'Indicates an administration of hydromorphone in the PACU',
      SCHEDULED_START_TS                      TIMESTAMP_LTZ(9) COMMENT 'Surgery scheduled start TS',
      ANESTHESIA_START_TS                     TIMESTAMP_LTZ(9) COMMENT 'Anesthesia start TS',
      ANESTHESIA_READY_TS                     TIMESTAMP_LTZ(9) COMMENT 'Anesthetized patient is ready for surgery prep TS',
      ANESTHESIA_STOP_TS                      TIMESTAMP_LTZ(9) COMMENT 'Anesthesia stop TS',
      PATIENT_ADMITTED_TO_HOSPITAL_TS         TIMESTAMP_LTZ(9) COMMENT 'Patient admitted to the hospital TS',
      HOSPITAL_DISCHARGE_TS                   TIMESTAMP_LTZ(9) COMMENT 'Patient discharged from the hospital TS',
      PATIENT_FIRST_ADMITTED_TO_ICU_TS        TIMESTAMP_LTZ(9) COMMENT 'Patients first post-operative admit to the ICU TS',
      PATIENT_FIRST_DISCHARGED_FROM_ICU_TS    TIMESTAMP_LTZ(9) COMMENT 'Patients first post-operative discharge from the ICU TS',
      PATIENT_EXPIRED_TS                      TIMESTAMP_LTZ(9) COMMENT 'Patient expired TS',
      SCHEDULED_SURGERY_TIME_MIN              NUMBER(38,0) COMMENT 'Time in minutes surgery is scheduled to take'
);


ALTER TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR
MODIFY (COLUMN SURGICAL_CASE_IDENTIFIER SET NOT NULL,
        COLUMN ENCOUNTER_IDENTIFIER SET NOT NULL,
        COLUMN MEDICAL_RECORD_NUMBER SET NOT NULL);
