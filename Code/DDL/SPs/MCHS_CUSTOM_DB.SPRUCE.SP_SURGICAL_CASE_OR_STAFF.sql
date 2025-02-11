-- MCHS_CUSTOM_DB.SPRUCE.SP_SURGICAL_CASE_OR_STAFF.sql
-- RM 2025.02.10 - Creation
--               - This table doesn't have a PK, so the UPDATE section of a MERGE will fail. Using delte/re-insert instead.

USE WAREHOUSE MCHS_CUSTOM_XLARGE_WH;
USE DATABASE MCHS_CUSTOM_DB;
USE SCHEMA SPRUCE;

TRUNCATE TABLE MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_STAFF;

CREATE OR REPLACE PROCEDURE MCHS_CUSTOM_DB.SPRUCE.SP_SURGICAL_CASE_OR_STAFF()
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS OWNER
AS 
$$
var sql_tmp = `CREATE TEMPORARY TABLE MCHS_CUSTOM_DB.SPRUCE.TEMP_SURGICAL_CASE_OR_STAFF AS (
               SELECT S.NCHS_ONLY_PERSON_ID, S.NCHS_ONLY_MRN, S.NCHS_ONLY_ENCOUNTER_ID, S.NCHS_ONLY_FIN,
                      S.NCHS_ONLY_SURGICAL_CASE_ID, S.NCHS_ONLY_PROVIDER_ID, S.NCHS_ONLY_ROLE_PERFORMED_CD, 
                      S.NCHS_ONLY_STAFF_ROLE_PERFORMED, S.OR_SURGICAL_CASE_IDENTIFIER, S.OR_ENCOUNTER_IDENTIFIER,
                      S.STAFF_NAME, S.STAFF_ROLE, S.DW_UPDATE_TS
               FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_STAFF S
               JOIN MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR          SCOR
                 ON SCOR.NCHS_ONLY_ENCOUNTER_ID = S.NCHS_ONLY_ENCOUNTER_ID
                AND SCOR.NCHS_ONLY_SURGICAL_CASE_ID = S.NCHS_ONLY_SURGICAL_CASE_ID 
               WHERE DATEDIFF(DAY, SCOR.SURGERY_START_TS::DATE, CURRENT_TIMESTAMP::DATE) <= 90);`;
var sql_del = `DELETE FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_STAFF
               WHERE NCHS_ONLY_SURGICAL_CASE_ID IN (
               SELECT NCHS_ONLY_SURGICAL_CASE_ID
               FROM MCHS_CUSTOM_DB.SPRUCE.TEMP_SURGICAL_CASE_OR_STAFF);`;
var sql_ins = `INSERT INTO MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_STAFF
               SELECT S.NCHS_ONLY_PERSON_ID, S.NCHS_ONLY_MRN, S.NCHS_ONLY_ENCOUNTER_ID ,S.NCHS_ONLY_FIN,
                      S.NCHS_ONLY_SURGICAL_CASE_ID, S.NCHS_ONLY_PROVIDER_ID, S.NCHS_ONLY_ROLE_PERFORMED_CD, 
                      S.NCHS_ONLY_STAFF_ROLE_PERFORMED, S.OR_SURGICAL_CASE_IDENTIFIER, S.OR_ENCOUNTER_IDENTIFIER,
                      S.STAFF_NAME, S.STAFF_ROLE, S.DW_UPDATE_TS, S.DW_UPDATE_TS
               FROM MCHS_CUSTOM_DB.SPRUCE.TEMP_SURGICAL_CASE_OR_STAFF S;`;
var sql_drp = `DROP TABLE MCHS_CUSTOM_DB.SPRUCE.TEMP_SURGICAL_CASE_OR_STAFF;`;

try {
    var stmt_tmp = snowflake.createStatement ( {sqlText:sql_tmp} );
    stmt_tmp.execute();

    var stmt_del = snowflake.createStatement ( {sqlText:sql_del} );
    stmt_del.execute();

    var stmt_ins = snowflake.createStatement ( {sqlText:sql_ins} );
    stmt_ins.execute();

    var stmt_drp = snowflake.createStatement ( {sqlText:sql_drp} );
    stmt_drp.execute();
 
    rowCount = stmt_ins.getNumRowsAffected();    
    return "Number of records affected: " + rowCount ;
    }
catch(err) {
           throw "Error Occurred: " + err.message;
           }
$$;


CALL MCHS_CUSTOM_DB.SPRUCE.SP_SURGICAL_CASE_OR_STAFF();
-- Successful 2025.02.10
-- Number of records affected: 20,806
 
SELECT COUNT(*) AS COUNT
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_STAFF  -- 277,873, mostly loaded manually previously 

