-- MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_PAIN.sql
-- RM 2025.02.05 - Creation
--               - Based on the new version received from AdaptX on 2025.01.15


--DROP TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_PAIN;
CREATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_PAIN (
   NCHS_ONLY_PERSON_ID                      NUMBER(38,0)      COMMENT 'PERSON_ID - Private - NCHS USE only',
   NCHS_ONLY_MRN                            NUMBER(38,0)      COMMENT 'MEDICAL_RECORD_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_ENCOUNTER_ID                   NUMBER(38,0)      COMMENT 'ENCOUNTER_ID - Private - NCHS USE only',
   NCHS_ONLY_FIN                            VARCHAR(400)      COMMENT 'FINANCIAL_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_SURGICAL_CASE_ID               NUMBER(38,0)      COMMENT 'SURG_CASE_ID - Private - NCHS USE only',
   NCHS_ONLY_CLINICAL_EVENT_ID              NUMBER(38,0)      COMMENT 'CLINICAL_EVENT_ID - Private - NCHS USE ONLY',
   NCHS_ONLY_EVENT_CD                       NUMBER(38,0)      COMMENT 'EVENT_CD - Private - NCHS USE ONLY',
   NCHS_ONLY_EVENT                          VARCHAR(400)      COMMENT 'EVENT DISPLAY - Private - NCHS USE ONLY',
   OR_SURGICAL_CASE_IDENTIFIER              VARCHAR(400)      COMMENT 'Unique surgical case identifier.',
   OR_ENCOUNTER_IDENTIFIER                  VARCHAR(400)      COMMENT 'Unique encounter identifier for the surgical case.',
   PAIN_SCORE                               NUMBER(38,0)      COMMENT 'Pain score reported by the patient.',
   PAIN_SCORE_TS                            TIMESTAMP_LTZ(9)  COMMENT 'Date and time the pain score was reported. (Use YYYY-MM-DD HH:MM:SS format.)',
   DW_CREATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard creation timestamp',
   DW_UPDATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard update timestamp'
);      
