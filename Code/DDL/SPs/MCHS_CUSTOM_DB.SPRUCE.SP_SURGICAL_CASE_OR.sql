-- MCHS_CUSTOM_DB.SPRUCE.SP_SURGICAL_CASE_OR.sql
-- RM 2025.02.07 - Creation

USE WAREHOUSE MCHS_CUSTOM_XLARGE_WH;
USE DATABASE MCHS_CUSTOM_DB;
USE SCHEMA SPRUCE;

--TRUNCATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR;

CREATE OR REPLACE PROCEDURE MCHS_CUSTOM_DB.SPRUCE.SP_SURGICAL_CASE_OR()
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS OWNER
AS 
$$
var sql0 = ` MERGE INTO MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR TRG
                  USING (SELECT *
                         FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR 
                         WHERE DATEDIFF(DAY, SURGERY_START_TS::DATE, CURRENT_TIMESTAMP::DATE) <= 90) SRC
                     ON SRC.NCHS_ONLY_ENCOUNTER_ID = TRG.NCHS_ONLY_ENCOUNTER_ID
                    AND SRC.NCHS_ONLY_SURGICAL_CASE_ID = TRG.NCHS_ONLY_SURGICAL_CASE_ID
             WHEN MATCHED THEN UPDATE SET 
                     NCHS_ONLY_PERSON_ID = SRC.NCHS_ONLY_PERSON_ID,
                     NCHS_ONLY_MRN = SRC.NCHS_ONLY_MRN,
                     NCHS_ONLY_ENCOUNTER_ID = SRC.NCHS_ONLY_ENCOUNTER_ID,
                     NCHS_ONLY_FIN = SRC.NCHS_ONLY_FIN,
                     NCHS_ONLY_SURGICAL_CASE_ID = SRC.NCHS_ONLY_SURGICAL_CASE_ID,
                     SURGICAL_CASE_IDENTIFIER = SRC.SURGICAL_CASE_IDENTIFIER,
                     ENCOUNTER_IDENTIFIER = SRC.ENCOUNTER_IDENTIFIER,
                     MEDICAL_RECORD_NUMBER = SRC.MEDICAL_RECORD_NUMBER,
                     LEGAL_SEX = SRC.LEGAL_SEX,
                     RACE = SRC.RACE,
                     ETHNICITY = SRC.ETHNICITY,
                     LANGUAGE = SRC.LANGUAGE,
                     ZIP_CODE = SRC.ZIP_CODE,
                     HEIGHT_CM = SRC.HEIGHT_CM,
                     WEIGHT_KG = SRC.WEIGHT_KG,
                     FACILITY_NAME = SRC.FACILITY_NAME,
                     PATIENT_AGE_IN_YEARS = SRC.PATIENT_AGE_IN_YEARS,
                     PATIENT_AGE_IN_MONTHS = SRC.PATIENT_AGE_IN_MONTHS,
                     PRIMARY_PAYOR_NAME = SRC.PRIMARY_PAYOR_NAME,
                     PRIMARY_PAYOR_FINANCIAL_CLASS = SRC.PRIMARY_PAYOR_FINANCIAL_CLASS,
                     PATIENT_CLASS = SRC.PATIENT_CLASS,
                     OR_ROOM_NAME = SRC.OR_ROOM_NAME,
                     PRIMARY_PROCEDURE_NAME = SRC.PRIMARY_PROCEDURE_NAME,
                     PROCEDURE_COUNT = SRC.PROCEDURE_COUNT,
                     CASE_ELECTIVE = SRC.CASE_ELECTIVE,
                     SCHEDULED_START_TS = SRC.SCHEDULED_START_TS,
                     PRIMARY_SURGEON_NAME = SRC.PRIMARY_SURGEON_NAME,
                     SURGICAL_SPECIALTY = SRC.SURGICAL_SPECIALTY,
                     WHEELED_INTO_OR_TS = SRC.WHEELED_INTO_OR_TS,
                     SURGERY_START_TS = SRC.SURGERY_START_TS,
                     SURGICAL_CLOSE_TS = SRC.SURGICAL_CLOSE_TS,
                     WHEELED_OUT_OF_OR_TS = SRC.WHEELED_OUT_OF_OR_TS,
                     HOSPITAL_ADMIT_INPATIENT_TS = SRC.HOSPITAL_ADMIT_INPATIENT_TS,
                     HOSPITAL_DISCHARGE_TS = SRC.HOSPITAL_DISCHARGE_TS,
                     ASA_SCORE = SRC.ASA_SCORE,
                     AIRWAY_GRADE = SRC.AIRWAY_GRADE,
                     ANESTHESIA_START_TS = SRC.ANESTHESIA_START_TS,
                     ANESTHESIA_READY_TS = SRC.ANESTHESIA_READY_TS,
                     ANESTHESIA_STOP_TS = SRC.ANESTHESIA_STOP_TS,
                     PACU_1_ADMIT_TS = SRC.PACU_1_ADMIT_TS,
                     PACU_1_DISCHARGE_TS = SRC.PACU_1_DISCHARGE_TS,
                     PACU_2_ADMIT_TS = SRC.PACU_2_ADMIT_TS,
                     PACU_2_DISCHARGE_TS = SRC.PACU_2_DISCHARGE_TS,
--                     DW_CREATE_TS = SRC.DW_CREATE_TS,
                     DW_UPDATE_TS = SRC.DW_UPDATE_TS
             WHEN NOT MATCHED THEN INSERT (NCHS_ONLY_PERSON_ID, NCHS_ONLY_MRN, NCHS_ONLY_ENCOUNTER_ID, NCHS_ONLY_FIN, NCHS_ONLY_SURGICAL_CASE_ID, 
                                           SURGICAL_CASE_IDENTIFIER, ENCOUNTER_IDENTIFIER, MEDICAL_RECORD_NUMBER, LEGAL_SEX, RACE, ETHNICITY, 
                                           LANGUAGE, ZIP_CODE, HEIGHT_CM, WEIGHT_KG, FACILITY_NAME, PATIENT_AGE_IN_YEARS, PATIENT_AGE_IN_MONTHS, 
                                           PRIMARY_PAYOR_NAME, PRIMARY_PAYOR_FINANCIAL_CLASS, PATIENT_CLASS, OR_ROOM_NAME, PRIMARY_PROCEDURE_NAME, 
                                           PROCEDURE_COUNT, CASE_ELECTIVE, SCHEDULED_START_TS, PRIMARY_SURGEON_NAME, SURGICAL_SPECIALTY, 
                                           WHEELED_INTO_OR_TS, SURGERY_START_TS, SURGICAL_CLOSE_TS, WHEELED_OUT_OF_OR_TS, HOSPITAL_ADMIT_INPATIENT_TS, 
                                           HOSPITAL_DISCHARGE_TS, ASA_SCORE, AIRWAY_GRADE, ANESTHESIA_START_TS, ANESTHESIA_READY_TS, ANESTHESIA_STOP_TS, 
                                           PACU_1_ADMIT_TS, PACU_1_DISCHARGE_TS, PACU_2_ADMIT_TS, PACU_2_DISCHARGE_TS, DW_CREATE_TS, DW_UPDATE_TS)
                                   VALUES (SRC.NCHS_ONLY_PERSON_ID, SRC.NCHS_ONLY_MRN, SRC.NCHS_ONLY_ENCOUNTER_ID, SRC.NCHS_ONLY_FIN, SRC.NCHS_ONLY_SURGICAL_CASE_ID, 
                                           SRC.SURGICAL_CASE_IDENTIFIER, SRC.ENCOUNTER_IDENTIFIER, SRC.MEDICAL_RECORD_NUMBER, SRC.LEGAL_SEX, SRC.RACE, 
                                           SRC.ETHNICITY, SRC.LANGUAGE, SRC.ZIP_CODE, SRC.HEIGHT_CM, SRC.WEIGHT_KG, SRC.FACILITY_NAME, SRC.PATIENT_AGE_IN_YEARS, 
                                           SRC.PATIENT_AGE_IN_MONTHS, SRC.PRIMARY_PAYOR_NAME, SRC.PRIMARY_PAYOR_FINANCIAL_CLASS, SRC.PATIENT_CLASS, SRC.OR_ROOM_NAME, 
                                           SRC.PRIMARY_PROCEDURE_NAME, SRC.PROCEDURE_COUNT, SRC.CASE_ELECTIVE, SRC.SCHEDULED_START_TS, SRC.PRIMARY_SURGEON_NAME, 
                                           SRC.SURGICAL_SPECIALTY, SRC.WHEELED_INTO_OR_TS, SRC.SURGERY_START_TS, SRC.SURGICAL_CLOSE_TS, SRC.WHEELED_OUT_OF_OR_TS, 
                                           SRC.HOSPITAL_ADMIT_INPATIENT_TS, SRC.HOSPITAL_DISCHARGE_TS, SRC.ASA_SCORE, SRC.AIRWAY_GRADE, SRC.ANESTHESIA_START_TS, 
                                           SRC.ANESTHESIA_READY_TS, SRC.ANESTHESIA_STOP_TS, SRC.PACU_1_ADMIT_TS, SRC.PACU_1_DISCHARGE_TS, SRC.PACU_2_ADMIT_TS, 
                                           SRC.PACU_2_DISCHARGE_TS, SRC.DW_UPDATE_TS, SRC.DW_UPDATE_TS); `;
try {
    var stmt = snowflake.createStatement ( {sqlText:sql0} );
    stmt.execute();
    rowCount = stmt.getNumRowsAffected();    
    return "Number of records affected: " + rowCount ;
    }
catch(err) {
           throw "Error Occurred: " + err.message;
           }
$$;


-- CALL MCHS_CUSTOM_DB.SPRUCE.SP_SURGICAL_CASE_OR();
-- Successful 2025.02.07
-- Number of records affected: 31,081
-- 00:00:06

-- Validation
--SELECT DW_CREATE_TS,
--       COUNT(*) AS COUNT
--FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR
--GROUP BY DW_CREATE_TS
--ORDER BY DW_CREATE_TS;
--
-- DW_CREATE_TS                COUNT
-- 2025-02-07 12:22:09.759    30,171 -- 2022-2024 encounters, manually inserted with DML
-- 2025-02-07 12:24:14.702       910 -- 2025 encounters inserted by the SP

 
--SELECT DW_UPDATE_TS,
--       COUNT(*) AS COUNT
--FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR
--GROUP BY DW_UPDATE_TS
--ORDER BY DW_UPDATE_TS;
--
-- DW_UPDATE_TS                 COUNT
-- 2025-02-07 12:33:35.061     28,866
-- 2025-02-07 12:46:51.388      2,215

--SELECT DISTINCT SURGERY_START_TS::DATE
--FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR
--WHERE DW_UPDATE_TS = '2025-02-07 12:46:51.388'
--ORDER BY 1; -- 90 records, 90 days as expected.

