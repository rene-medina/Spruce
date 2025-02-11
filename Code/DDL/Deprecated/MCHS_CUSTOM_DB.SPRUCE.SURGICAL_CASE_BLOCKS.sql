-- MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_BLOCKS.sql
-- RM 2024.09.10 - Creation
-- RM 2024.09.17 - Added NOT NULL constraints


USE DATABASE MCHS_CUSTOM_DB;
--CREATE SCHEMA SPRUCE;
--DROP TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_BLOCKS;

CREATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_BLOCKS (
      SURGICAL_CASE_IDENTIFIER                VARCHAR(400) COMMENT 'Unique surgical case identifier',
      BLOCK_TYPES                             VARCHAR(400) COMMENT 'Ex: peripheral vs centroaxial',
      BLOCK_NERVE_SITES                       VARCHAR(400) COMMENT 'Ex: T9-T10, trunk, head & neck, etc.',
      BLOCK_NAMES                             VARCHAR(400) COMMENT 'Ex: caudal, ilioinguinal, etc.',
      BLOCK_TECHNIQUES                        VARCHAR(400) COMMENT 'Ex: single injection vs continuous',
      BLOCK_LATERALITY                        VARCHAR(400) COMMENT 'Ex: left, right or bilateral',
      BLOCK_ATTEMPTS                          NUMBER(38,0) COMMENT 'Number of attempts to do block'
);


ALTER TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_BLOCKS MODIFY (
     COLUMN SURGICAL_CASE_IDENTIFIER SET NOT NULL);
