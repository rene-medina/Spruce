-- MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ADMIN_MEDS.sql
-- RM 2025.01.20 - Creation
--               - Based on the new version received from AdaptX on 2025.01.15
-- RM 2025.02.04 - Added NCHS_ONLY columns, which are for internal use only because of PHI

--DROP TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ADMIN_MEDS;
CREATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ADMIN_MEDS (   
   NCHS_ONLY_PERSON_ID                      NUMBER(38,0)      COMMENT 'PERSON_ID - Private - NCHS USE only',
   NCHS_ONLY_MRN                            NUMBER(38,0)      COMMENT 'MEDICAL_RECORD_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_ENCOUNTER_ID                   NUMBER(38,0)      COMMENT 'ENCOUNTER_ID - Private - NCHS USE only',
   NCHS_ONLY_FIN                            VARCHAR(400)      COMMENT 'FINANCIAL_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_SURGICAL_CASE_ID               NUMBER(38,0)      COMMENT 'SURG_CASE_ID - Private - NCHS USE only',
   NCHS_ONLY_ORDER_ID_SEQUENCE              VARCHAR(400)      COMMENT 'ORDER_ID + ACTION_SEQUENCE - Private - NCHS USE only',
   NCHS_ONLY_ORDER_PROVIDER_ID              NUMBER(38,0)      COMMENT 'PROVIDER_ID - Private - NCHS USE only',
   OR_SURGICAL_CASE_IDENTIFIER              VARCHAR(400)      COMMENT 'Unique surgical case identifier.',
   OR_ENCOUNTER_IDENTIFIER                  VARCHAR(400)      COMMENT 'Unique encounter identifier for the surgical case.',
   MEDICATION_NAME                          VARCHAR(400)      COMMENT 'Name of the medication.',
   MEDICATION_ROUTE                         VARCHAR(400)      COMMENT 'Route of administration (IV, NG, injection, etc.).',
   MEDICATION_ROUTE_MAPPED                  VARCHAR(400)      COMMENT 'Route of administration mapped to an expected value.',
   MEDICATION_ADMINISTRATION_TS             TIMESTAMP_LTZ(9)  COMMENT 'Date and time the medication was administered. (Use YYYY-MM-DD HH:MM:SS format.)',
   DW_CREATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard creation timestamp',
   DW_UPDATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard update timestamp'
   );      
