-- MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ANES_ACTIONS.sql
-- RM 2025.01.20 - Creation
--               - Based on the new version received from AdaptX on 2025.01.15
-- RM 2025.02.03 - Added several NCHS_ONLY fields to store Cerner IDs to be kept private because of PHI

--DROP TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ANES_ACTIONS;
CREATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ANES_ACTIONS (      
   NCHS_ONLY_PERSON_ID                      NUMBER(38,0)      COMMENT 'PERSON_ID - Private - NCHS USE only',
   NCHS_ONLY_MRN                            NUMBER(38,0)      COMMENT 'MEDICAL_RECORD_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_ENCOUNTER_ID                   NUMBER(38,0)      COMMENT 'ENCOUNTER_ID - Private - NCHS USE only',
   NCHS_ONLY_FIN                            VARCHAR(400)      COMMENT 'FINANCIAL_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_SURGICAL_CASE_ID               NUMBER(38,0)      COMMENT 'SURG_CASE_ID - Private - NCHS USE only',
   NCHS_ONLY_ACTION_DT_TM                   TIMESTAMP_LTZ(9)  COMMENT 'ACTION_DT_TM - Private - NCHS USE only',
   NCHS_ONLY_SA_ACTION_ID                   NUMBER(38,0)      COMMENT 'SA_ACTION_ID - Private - NCHS USE only',
   NCHS_ONLY_EVENT_ID                       NUMBER(38,0)      COMMENT 'CLINICAL_EVENT.EVENT_ID - Private - NCHS USE only',
   OR_SURGICAL_CASE_IDENTIFIER              VARCHAR(400)      COMMENT 'Unique surgical case identifier.',
   OR_ENCOUNTER_IDENTIFIER                  VARCHAR(400)      COMMENT 'Unique encounter identifier for the surgical case.',
   ANESTHESIA_ACTION                        VARCHAR(400)      COMMENT 'Anesthesia action performed (line placement, intubation, etc.)',
   DW_CREATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard creation timestamp',
   DW_UPDATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard update timestamp'
);      

