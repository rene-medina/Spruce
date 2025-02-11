-- MCHS_CUSTOM_DB.SPRUCE.SP_SURGICAL_CASE_OR_HOSPITAL_ADMITS.sql
-- RM 2025.02.10 - Creation
--               - This table doesn't have a PK, so the UPDATE section of a MERGE will fail. Using delte/re-insert instead.

USE WAREHOUSE MCHS_CUSTOM_XLARGE_WH;
USE DATABASE MCHS_CUSTOM_DB;
USE SCHEMA SPRUCE;

--TRUNCATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_HOSPITAL_ADMITS;

CREATE OR REPLACE PROCEDURE MCHS_CUSTOM_DB.SPRUCE.SP_SURGICAL_CASE_OR_HOSPITAL_ADMITS()
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS OWNER
AS 
$$
//var sql_tmp = `CREATE TEMPORARY TABLE MCHS_CUSTOM_DB.SPRUCE.TEMP_SURGICAL_CASE_OR_PAIN AS (
//               SELECT P.NCHS_ONLY_PERSON_ID, P.NCHS_ONLY_MRN, P.NCHS_ONLY_ENCOUNTER_ID, P.NCHS_ONLY_FIN, P.NCHS_ONLY_SURGICAL_CASE_ID, 
//                      P.NCHS_ONLY_CLINICAL_EVENT_ID, P.NCHS_ONLY_EVENT_CD, P.NCHS_ONLY_EVENT, P.OR_SURGICAL_CASE_IDENTIFIER, 
//                      P.OR_ENCOUNTER_IDENTIFIER, P.PAIN_SCORE, P.PAIN_SCORE_TS, P.DW_UPDATE_TS
//               FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_PAIN P
//               JOIN MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR                 SCOR
//                 ON SCOR.NCHS_ONLY_ENCOUNTER_ID = P.NCHS_ONLY_ENCOUNTER_ID
//                AND SCOR.NCHS_ONLY_SURGICAL_CASE_ID = P.NCHS_ONLY_SURGICAL_CASE_ID 
//               WHERE DATEDIFF(DAY, SCOR.SURGERY_START_TS::DATE, CURRENT_TIMESTAMP::DATE) <= 90);`;
//var sql_del = `DELETE FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_PAIN
//               WHERE NCHS_ONLY_SURGICAL_CASE_ID IN (
//               SELECT NCHS_ONLY_SURGICAL_CASE_ID
//               FROM MCHS_CUSTOM_DB.SPRUCE.TEMP_SURGICAL_CASE_OR_PAIN);`;
//var sql_ins = `INSERT INTO MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_PAIN
//               SELECT P.NCHS_ONLY_PERSON_ID, P.NCHS_ONLY_MRN, P.NCHS_ONLY_ENCOUNTER_ID, P.NCHS_ONLY_FIN, P.NCHS_ONLY_SURGICAL_CASE_ID, 
//                      P.NCHS_ONLY_CLINICAL_EVENT_ID, P.NCHS_ONLY_EVENT_CD, P.NCHS_ONLY_EVENT, P.OR_SURGICAL_CASE_IDENTIFIER, 
//                      P.OR_ENCOUNTER_IDENTIFIER, P.PAIN_SCORE, P.PAIN_SCORE_TS, P.DW_UPDATE_TS, P.DW_UPDATE_TS
//               FROM MCHS_CUSTOM_DB.SPRUCE.TEMP_SURGICAL_CASE_OR_PAIN P;`;
//var sql_drp = `DROP TABLE MCHS_CUSTOM_DB.SPRUCE.TEMP_SURGICAL_CASE_OR_PAIN;`;
//
//try {
//    var stmt_tmp = snowflake.createStatement ( {sqlText:sql_tmp} );
//    stmt_tmp.execute();
//
//    var stmt_del = snowflake.createStatement ( {sqlText:sql_del} );
//    stmt_del.execute();
//
//    var stmt_ins = snowflake.createStatement ( {sqlText:sql_ins} );
//    stmt_ins.execute();
//
//    var stmt_drp = snowflake.createStatement ( {sqlText:sql_drp} );
//    stmt_drp.execute();
// 
//    rowCount = stmt_ins.getNumRowsAffected();    
//    return "Number of records affected: " + rowCount ;
//    }
//catch(err) {
//           throw "Error Occurred: " + err.message;
//           }
    return "Number of records affected: " + 0;
$$;


CALL MCHS_CUSTOM_DB.SPRUCE.SP_SURGICAL_CASE_OR_HOSPITAL_ADMITS()
-- Successful 2025.02.10
-- Number of records affected: 0
 
SELECT COUNT(*) AS COUNT
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_HOSPITAL_ADMITS; -- 19,041, mostly loaded manually previously 

