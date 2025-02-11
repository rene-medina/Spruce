-- MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_STAFF.sql
-- RM 2024.09.10 - Creation
-- RM 2024.09.17 - Added NOT NULL constraints


USE DATABASE MCHS_CUSTOM_DB;
--CREATE SCHEMA SPRUCE;
DROP TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_STAFF;

CREATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_STAFF (
      SURGICAL_CASE_IDENTIFIER                VARCHAR(400) COMMENT 'Unique surgical case identifier',
      STAFF_NAME                              VARCHAR(400) COMMENT 'Name of staff',
      STAFF_ROLE                              VARCHAR(400) COMMENT 'Expected Values: Attending Surgeon, Surgery Fellow, Surgery Resident, Anesthesiologist, Anesthesia Fellow, Anesthesia Resident, CRNA, Pre-op Nurse, Circulating Nurse, PACU Nurse, Surgical Tech'
);

ALTER TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_STAFF MODIFY (
     COLUMN SURGICAL_CASE_IDENTIFIER SET NOT NULL);
