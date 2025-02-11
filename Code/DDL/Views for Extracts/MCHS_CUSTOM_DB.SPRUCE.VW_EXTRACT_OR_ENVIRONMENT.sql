-- MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR_ENVIRONMENT.sql
-- RM 2025.01.31 - Creation

ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = FALSE;

-- OR_ENVIRONMENT
CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR_ENVIRONMENT AS (
SELECT OR_SURGICAL_CASE_IDENTIFIER              AS "or_surgical_case_identifier"
      ,OR_ENCOUNTER_IDENTIFIER                  AS "or_encounter_identifier"
      ,SUBSTRING(GAS_TS::STRING,1,19)           AS "gas_ts" 
      ,GAS_DURATION_MINUTES                     AS "gas_duration_minutes"
      ,AIR_VOLUME                               AS "air_volume"
      ,O2_VOLUME                                AS "o2_volume"
      ,N2O_VOLUME                               AS "n2o_volume"
      ,EXPIRED_DES_PERCENT                      AS "expired_des_percent"
      ,EXPIRED_ISO_PERCENT                      AS "expired_iso_percent"
      ,EXPIRED_SEVO_PERCENT                     AS "expired_sevo_percent" 
      ,INSPIRED_SEVOFLURANE                     AS "*** NOT IN SPECS: INSPIRED_SEVOFLURANE *** " 
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR_ENV
);

--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.VW_EXTRACT_OR_ENVIRONMENT
--WHERE "or_surgical_case_identifier" = 'MAIN-2024-3835';

