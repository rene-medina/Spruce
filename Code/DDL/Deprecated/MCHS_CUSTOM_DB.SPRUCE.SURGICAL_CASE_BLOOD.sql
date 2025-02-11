-- MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_BLOOD.sql
-- RM 2024.09.10 - Creation
-- RM 2024.09.17 - Added NOT NULL constraints


USE DATABASE MCHS_CUSTOM_DB;
--CREATE SCHEMA SPRUCE;
--DROP TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_BLOOD;

CREATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_BLOOD (
      SURGICAL_CASE_IDENTIFIER                VARCHAR(400) COMMENT 'Unique surgical case identifier',
      BLOOD_PRODUCT_TYPE                      VARCHAR(400) COMMENT 'Name of blood product (red blood cells, platelets, FFP, cyprecipitate, etc.)',
      BLOOD_PRODUCT_VOLUME                    NUMBER(38,0) COMMENT 'Numerical volume of blood product given',
      BLOOD_PRODUCT_UNITS                     VARCHAR(400) COMMENT 'Measurement units of the amount given',
      BLOOD_PRODUCT_ADMIN_TS                  TIMESTAMP_LTZ(9) COMMENT 'Blood product is administered to the patient TS'
);


ALTER TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_BLOOD MODIFY (
     COLUMN SURGICAL_CASE_IDENTIFIER SET NOT NULL);
