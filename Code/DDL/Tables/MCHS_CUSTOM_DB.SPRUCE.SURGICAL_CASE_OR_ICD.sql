-- MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ICD.sql
-- RM 2025.02.05 - Creation
--               - Based on the new version received from AdaptX on 2025.01.15


--DROP TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ICD;
CREATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ICD (       
   NCHS_ONLY_PERSON_ID                      NUMBER(38,0)      COMMENT 'PERSON_ID - Private - NCHS USE only',
   NCHS_ONLY_MRN                            NUMBER(38,0)      COMMENT 'MEDICAL_RECORD_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_ENCOUNTER_ID                   NUMBER(38,0)      COMMENT 'ENCOUNTER_ID - Private - NCHS USE only',
   NCHS_ONLY_FIN                            VARCHAR(400)      COMMENT 'FINANCIAL_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_SURGICAL_CASE_ID               NUMBER(38,0)      COMMENT 'SURGICAL_CASE_ID - Private - NCHS USE only',
   NCHS_ONLY_DIAGNOSIS_ID                   NUMBER(38,0)      COMMENT 'DIAGNOSIS_ID - Private - NCHS USE ONLY',
   NCHS_ONLY_DIAGNOSIS_PROVIDER_ID          NUMBER(38,0)      COMMENT 'DIAG_PRSNL_ID - Private - NCHS USE ONLY',
   NCHS_ONLY_DIAGNOSIS_PROVIDER             VARCHAR(400)      COMMENT 'DIAG_PRSNL_NAME - Private - NCHS USE ONLY',   
   OR_SURGICAL_CASE_IDENTIFIER              VARCHAR(400)      COMMENT 'Unique surgical case identifier.',
   OR_ENCOUNTER_IDENTIFIER                  VARCHAR(400)      COMMENT 'Unique encounter identifier for the surgical case.',
   ICD10_CODE                               VARCHAR(400)      COMMENT 'ICD-10-CM code assigned to the encounter.',
   ICD10_DESCRIPTION                        VARCHAR(400)      COMMENT 'Description of ICD-10-CM code assigned to the encounter.',
   DW_CREATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard creation timestamp',
   DW_UPDATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard update timestamp'
);      
