-- MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_STAFF.sql
-- RM 2025.01.20 - Creation
--               - Based on the new version received from AdaptX on 2025.01.15

--DROP TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_STAFF;
CREATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_STAFF (  
   NCHS_ONLY_PERSON_ID                      NUMBER(38,0)      COMMENT 'PERSON_ID - Private - NCHS USE only',
   NCHS_ONLY_MRN                            NUMBER(38,0)      COMMENT 'MEDICAL_RECORD_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_ENCOUNTER_ID                   NUMBER(38,0)      COMMENT 'ENCOUNTER_ID - Private - NCHS USE only',
   NCHS_ONLY_FIN                            VARCHAR(400)      COMMENT 'FINANCIAL_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_SURGICAL_CASE_ID               NUMBER(38,0)      COMMENT 'SURGICAL_CASE_ID - Private - NCHS USE only',
   NCHS_ONLY_PROVIDER_ID                    NUMBER(38,0)      COMMENT 'PROVIDER_ID -- Private - NCHS USE only',
   NCHS_ONLY_ROLE_PERFORMED_CD              VARCHAR(400)      COMMENT 'ROLE PERFORMED CD -- Private - NCHS USE only',
   NCHS_ONLY_STAFF_ROLE_PERFORMED           VARCHAR(400)      COMMENT 'ROLE PERFORMED -- Private - NCHS USE only',
   OR_SURGICAL_CASE_IDENTIFIER              VARCHAR(400)      COMMENT 'Unique surgical case identifier.',
   OR_ENCOUNTER_IDENTIFIER                  VARCHAR(400)      COMMENT 'Unique encounter identifier for the surgical case.',
   STAFF_NAME                               VARCHAR(400)      COMMENT 'Full name of the staff member who participated in the encounter.',
   STAFF_ROLE                               VARCHAR(400)      COMMENT 'The role that the staff member played during the encounter.',
   DW_CREATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard creation timestamp',
   DW_UPDATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard update timestamp'
);      
