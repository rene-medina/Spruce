-- MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_HOSPITAL_ADMITS.sql
-- RM 2025.01.20 - Creation
--               - Based on the new version received from AdaptX on 2025.01.15
-- RM 2025.02.06 - Added several NCHS_ONLY columns for internal use only         


DROP TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_HOSPITAL_ADMITS;
CREATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_HOSPITAL_ADMITS (      
   NCHS_ONLY_PERSON_ID                      NUMBER(38,0)      COMMENT 'PERSON_ID - Private - NCHS USE only',
   NCHS_ONLY_MRN                            NUMBER(38,0)      COMMENT 'MEDICAL_RECORD_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_ENCOUNTER_ID                   NUMBER(38,0)      COMMENT 'ENCOUNTER_ID - Private - NCHS USE only',
   NCHS_ONLY_FIN                            VARCHAR(400)      COMMENT 'FINANCIAL_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_SURGICAL_CASE_ID               NUMBER(38,0)      COMMENT 'SURG_CASE_ID - Private - NCHS USE only',
   OR_SURGICAL_CASE_IDENTIFIER              VARCHAR(400)      COMMENT 'Unique surgical case identifier.',
   OR_ENCOUNTER_IDENTIFIER                  VARCHAR(400)      COMMENT 'Unique encounter identifier for the surgical case.',
   HOSPITAL_ENCOUNTER_IDENTIFIER            VARCHAR(400)      COMMENT 'Unique encounter identifier for the hospital admission.',
   HOSPITAL_ADMIT_INPATIENT_TS              TIMESTAMP_LTZ(9)  COMMENT 'Date and time the patient first had an inpatient admitted hospital status. (Use YYYY-MM-DD HH:MM:SS format.)',
   DW_CREATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard creation timestamp',
   DW_UPDATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard update timestamp'
);      
