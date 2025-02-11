-- MCHS_CUSTOM_DB.SPRUCE.SUBMISSION DML.sql
-- RM 2025.01.31 - Creation
-- RM 2025.02.03 - Added anes_actions and procedure
-- RM 2025.02.04 - Added administered_medications
-- RM 2025.02.05 - Added icd
-- RM 2025.02.06 - Added ed_arrivals


USE DATABASE MCHS_CUSTOM_DB;
USE SCHEMA SPRUCE;

--TRUNCATE TABLE MCHS_CUSTOM_DB.SPRUCE.SUBMISSION;
INSERT INTO MCHS_CUSTOM_DB.SPRUCE.SUBMISSION 
  (TABLE_NAME, EXPORT_FLAG, EXPORT_SQL)
SELECT COLUMN1::TEXT(400) AS TABLE_NAME, COLUMN2::TEXT(1) AS EXPORT_FLAG, COLUMN3::TEXT(16777216) AS EXPORT_SQL
FROM VALUES 
('or','Y', 
'SELECT VEOR.*
 FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR VEOR
 WHERE DATEDIFF(DAY, VEOR."scheduled_start_ts"::DATE, CURRENT_TIMESTAMP::DATE) <= 90
 ORDER BY VEOR."surgical_case_identifier";'),
('or_environment','Y',
'SELECT VEOE.*
 FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR_ENVIRONMENT VEOE
 JOIN MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR VEOR
   ON VEOE."or_surgical_case_identifier" = VEOR."surgical_case_identifier"
 WHERE DATEDIFF(DAY, VEOR."scheduled_start_ts"::DATE, CURRENT_TIMESTAMP::DATE) <= 90
 ORDER BY VEOE."or_surgical_case_identifier";'),
('staff','Y',
'SELECT VES.*
 FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_STAFF VES
 JOIN MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR VEOR
   ON VES."or_surgical_case_identifier" = VEOR."surgical_case_identifier"
 WHERE DATEDIFF(DAY, VEOR."scheduled_start_ts"::DATE, CURRENT_TIMESTAMP::DATE) <= 90
 ORDER BY VES."or_surgical_case_identifier", VES."staff_name";'),
('anes_actions','Y',
'SELECT VEAA.*
 FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_ANES_ACTIONS VEAA
 JOIN MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR VEOR
   ON VEAA."or_surgical_case_identifier" = VEOR."surgical_case_identifier"
 WHERE DATEDIFF(DAY, VEOR."scheduled_start_ts"::DATE, CURRENT_TIMESTAMP::DATE) <= 90
 ORDER BY VEAA."or_surgical_case_identifier", VEAA."anesthesia_action";'),
('procedure','Y',
'SELECT VP.*
 FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_PROCEDURE VP
 JOIN MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR VEOR
   ON VP."or_surgical_case_identifier" = VEOR."surgical_case_identifier"
 WHERE DATEDIFF(DAY, VEOR."scheduled_start_ts"::DATE, CURRENT_TIMESTAMP::DATE) <= 90
 ORDER BY VP."or_surgical_case_identifier";'),
('administered_medications','Y',
'SELECT VM.*
 FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_ADMIN_MEDS VM
 JOIN MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR VEOR
   ON VM."or_surgical_case_identifier" = VEOR."surgical_case_identifier"
 WHERE DATEDIFF(DAY, VEOR."scheduled_start_ts"::DATE, CURRENT_TIMESTAMP::DATE) <= 90
 ORDER BY VM."or_surgical_case_identifier" 
          ,VM."medication_administration_ts";'),
('icd','Y',
'SELECT VI.*
 FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_ICD VI
 JOIN MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR VEOR
   ON VI."or_surgical_case_identifier" = VEOR."surgical_case_identifier"
 WHERE DATEDIFF(DAY, VEOR."scheduled_start_ts"::DATE, CURRENT_TIMESTAMP::DATE) <= 90
 ORDER BY VI."or_surgical_case_identifier";'),
 ('pain','Y',
'SELECT VP.*
 FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_PAIN VP
 JOIN MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR VEOR
   ON VP."or_surgical_case_identifier" = VEOR."surgical_case_identifier"
 WHERE DATEDIFF(DAY, VEOR."scheduled_start_ts"::DATE, CURRENT_TIMESTAMP::DATE) <= 90
 ORDER BY VP."or_surgical_case_identifier", "pain_score_ts";'),
('ed_arrivals','Y',
'SELECT VEA.*
 FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_ED_ARRIVALS VEA
 WHERE DATEDIFF(DAY, VEA."ed_arrival_ts"::DATE, CURRENT_TIMESTAMP::DATE) <= 90
 ORDER BY VEA."ed_arrival_ts";'),
('hospital_admits','Y',
'SELECT VHA.*
 FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_HOSPITAL_ADMITS VHA
 WHERE DATEDIFF(DAY, VHA."hospital_admit_inpatient_ts"::DATE, CURRENT_TIMESTAMP::DATE) <= 90
 ORDER BY VHA."hospital_admit_inpatient_ts";') 
 ;

-- Successfull 2025.02.07
-- Updated Rows    10
-- Execute time    00:00:01
-- Start time  Fri Feb 07 11:28:50 EST 2025
-- Finish time Fri Feb 07 11:28:51 EST 2025

SELECT *
FROM MCHS_CUSTOM_DB.SPRUCE.SUBMISSION;

