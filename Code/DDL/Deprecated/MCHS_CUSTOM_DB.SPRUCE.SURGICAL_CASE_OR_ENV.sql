-- MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ENV.sql
-- RM 2024.09.10 - Creation
-- RM 2024.09.17 - Added NOT NULL constraints


USE DATABASE MCHS_CUSTOM_DB;
--CREATE SCHEMA SPRUCE;
--DROP TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ENV;

CREATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ENV (
      SURGICAL_CASE_IDENTIFIER                VARCHAR(400) COMMENT 'Unique surgical case identifier',
      GAS_TS                                  TIMESTAMP_LTZ(9) COMMENT 'Gas volume was recorded TS',
      GAS_DURATION                            NUMBER(38,0) COMMENT 'Elapsed time gas was given',
      AIR_VOLUME                              NUMBER(38,0) COMMENT 'Liters per minute',
      O2_VOLUME                               NUMBER(38,0) COMMENT 'Liters per minute',
      N20_VOLUME                              NUMBER(38,0) COMMENT 'Liters per minute',
      EXP_DES_PRCNT                           NUMBER(38,0) COMMENT 'Percent expired',
      EXP_ISO_PRCNT                           NUMBER(38,0) COMMENT 'Percent expired',
      EXP_SEVO_PRCNT                          NUMBER(38,0) COMMENT 'Percent expired'
);


ALTER TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ENV MODIFY (
     COLUMN SURGICAL_CASE_IDENTIFIER SET NOT NULL);

