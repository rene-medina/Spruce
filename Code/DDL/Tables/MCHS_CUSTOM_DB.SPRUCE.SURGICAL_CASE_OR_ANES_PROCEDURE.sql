-- MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ANES_PROCEDURE.sql
-- RM 2025.02.03 - Creation

--DROP TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ANES_PROCEDURE;
CREATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ANES_PROCEDURE (      
   NCHS_ONLY_PERSON_ID                      NUMBER(38,0)      COMMENT 'PERSON_ID - Private - NCHS USE only',
   NCHS_ONLY_MRN                            NUMBER(38,0)      COMMENT 'MEDICAL_RECORD_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_ENCOUNTER_ID                   NUMBER(38,0)      COMMENT 'ENCOUNTER_ID - Private - NCHS USE only',
   NCHS_ONLY_FIN                            VARCHAR(400)      COMMENT 'FINANCIAL_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_SURGICAL_CASE_ID               NUMBER(38,0)      COMMENT 'SURG_CASE_ID - Private - NCHS USE only',
   OR_SURGICAL_CASE_IDENTIFIER              VARCHAR(400)      COMMENT 'Unique surgical case identifier.',
   OR_ENCOUNTER_IDENTIFIER                  VARCHAR(400)      COMMENT 'Unique encounter identifier for the surgical case.',
   CPT_CODE                                 VARCHAR(400)      COMMENT 'CPT code assigned to the encounter.',
   CPT_DESCRIPTION                          VARCHAR(400)      COMMENT 'Description of the CPT code assigned to the encounter.',
   DW_CREATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard creation timestamp',
   DW_UPDATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard update timestamp'
);      

