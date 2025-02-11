-- MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ENV.sql
-- RM 2025.01.20 - Creation
--               - Based on the new version received from AdaptX on 2025.01.15
-- RM 2025.01.28 - Added NCHS-only fields 
-- RM 2025.02.10 - Added missing NCHS_ONLY_SURGICAL_CASE_ID


--DROP TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ENV;
CREATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ENV(       
   NCHS_ONLY_PERSON_ID                      NUMBER(38,0)      COMMENT 'PERSON_ID - Private - NCHS USE only',
   NCHS_ONLY_MRN                            NUMBER(38,0)      COMMENT 'MEDICAL_RECORD_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_ENCOUNTER_ID                   NUMBER(38,0)      COMMENT 'ENCOUNTER_ID - Private - NCHS USE only',
   NCHS_ONLY_FIN                            VARCHAR(400)      COMMENT 'FINANCIAL_NUMBER - Private - NCHS USE only',
   NCHS_ONLY_SURGICAL_CASE_ID               NUMBER(38,0)      COMMENT 'SURG_CASE_ID - Private - NCHS USE only',
   OR_SURGICAL_CASE_IDENTIFIER              VARCHAR(400)      COMMENT 'Unique surgical case identifier.',
   OR_ENCOUNTER_IDENTIFIER                  VARCHAR(400)      COMMENT 'Unique encounter identifier for the surgical case.',
   GAS_TS                                   TIMESTAMP_LTZ(9)  COMMENT 'Date and time gas volume was recorded. (Use YYYY-MM-DD HH:MM:SS format.)',
   GAS_DURATION_MINUTES                     NUMBER(38,3)      COMMENT 'Elapsed time gas was given, in minutes.',
   AIR_VOLUME                               NUMBER(38,3)      COMMENT 'Liters per minute.',
   O2_VOLUME                                NUMBER(38,3)      COMMENT 'Liters per minute.',
   N2O_VOLUME                               NUMBER(38,3)      COMMENT 'Liters per minute.',
   EXPIRED_DES_PERCENT                      NUMBER(38,3)      COMMENT 'Percent of desflurane expired. Values 0.00 to 10.00, formatted to two decimal places (ex: 1.25).',
   EXPIRED_ISO_PERCENT                      NUMBER(38,3)      COMMENT 'Percent of isoflurane expired. Values 0.00 to 5.00, formatted to two decimal places (ex: 1.25).',
   EXPIRED_SEVO_PERCENT                     NUMBER(38,3)      COMMENT 'Percent of sevoflurane expired. Values 0.00 to 8.00, formatted to two decimal places (ex: 1.25).',
   INSPIRED_SEVOFLURANE                     NUMBER(38,3)      COMMENT 'Inspired Sevoflurane Anes *** NOT IN SPECS, SUGGESTED TO BE ADDED ***',
   DW_CREATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard creation timestamp',
   DW_UPDATE_TS                             TIMESTAMP_LTZ(9)  COMMENT 'NCHS DW standard update timestamp'
);      
