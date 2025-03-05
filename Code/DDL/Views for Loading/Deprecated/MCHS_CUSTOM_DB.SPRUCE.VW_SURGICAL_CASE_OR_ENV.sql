-- MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ENV.sql
-- RM 2025.01.20 - Creation
-- RM 2025.01.27 - Added NCHS-only fields, DW_UPDATE_TS and the de-identified/tokenized IDs, 
--                 using the tables suggested by Carlos today. 
-- RM 2025.01.28 - Used MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR as driver 
-- RM 2025.02.10 - Fixed OR_SURGICAL_CASE_IDENTIFIER and added DW_UPDATE_TS

CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ENV AS (
SELECT SCOR.NCHS_ONLY_PERSON_ID                        AS NCHS_ONLY_PERSON_ID            -- Private - NCHS USE only
      ,SCOR.NCHS_ONLY_MRN                              AS NCHS_ONLY_MRN                  -- Private - NCHS USE only
      ,SCOR.NCHS_ONLY_ENCOUNTER_ID                     AS NCHS_ONLY_ENCOUNTER_ID         -- Private - NCHS USE only
      ,SCOR.NCHS_ONLY_FIN                              AS NCHS_ONLY_FIN                  -- Private - NCHS USE ONLY
      ,SCOR.NCHS_ONLY_SURGICAL_CASE_ID                 AS NCHS_ONLY_SURGICAL_CASE_ID     -- Private - NCHS USE ONLY
      ,SCOR.SURGICAL_CASE_IDENTIFIER                   AS OR_SURGICAL_CASE_IDENTIFIER    -- Only NCHS ID field shared with ADAPTX
      ,SCOR.ENCOUNTER_IDENTIFIER                       AS OR_ENCOUNTER_IDENTIFIER        -- De-Identified/Tokenized
      ,CE.EVENT_END_DT_TM                              AS GAS_TS
      ,TIMEDIFF(MINUTE, SEVOFLURANE.START_DT_TM, 
                        SEVOFLURANE.END_DT_TM)        AS GAS_DURATION_MINUTES      -- Based on SEVOFLURANE
      ,MAX(CASE
             WHEN SRP.TASK_ASSAY_CD = 7230129605  -- Fresh Gas Air, PowerChart Vitals
             THEN CE.RESULT_VAL ELSE NULL
           END)                                        AS AIR_VOLUME
      ,MAX(CASE
             WHEN SRP.TASK_ASSAY_CD = 7230133445  -- Fresh Gas O2, PowerChart Vitals
             THEN CE.RESULT_VAL ELSE NULL
           END)                                        AS O2_VOLUME
      ,MAX(CASE
             WHEN SRP.TASK_ASSAY_CD = 7230559537  -- Fresh Gas N2O,
             THEN CE.RESULT_VAL ELSE NULL
           END)                                        AS N2O_VOLUME
      ,MAX(CASE
             WHEN SRP.TASK_ASSAY_CD = 19818228    -- Expired Desflurane Anes,
             THEN CE.RESULT_VAL ELSE NULL
           END)                                        AS EXPIRED_DES_PERCENT
      ,MAX(CASE
             WHEN SRP.TASK_ASSAY_CD = 19818235    -- Expired Isoflurane Anes
             THEN CE.RESULT_VAL ELSE NULL
           END)                                        AS EXPIRED_ISO_PERCENT                     
      ,MAX(CASE
             WHEN SRP.TASK_ASSAY_CD = 19818260    -- Expired Sevoflurane Anes       -- PowerChart Monitors 
             THEN CE.RESULT_VAL ELSE NULL
           END)                                        AS EXPIRED_SEVO_PERCENT
      ,MAX(CASE
             WHEN SRP.TASK_ASSAY_CD = 19818299    -- Inspired Sevoflurane Anes -- RM 2025.01.27 *** NOT IN SPECS, SUGGESTED TO BE ADDED *** 
             THEN CE.RESULT_VAL ELSE NULL
           END)                                        AS INSPIRED_SEVOFLURANE
      ,CURRENT_TIMESTAMP                               AS DW_UPDATE_TS     
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR            SCOR
-- RM 2025.01.28 - Can't use CDS_F_SURGERY_CASE for staff, as ADAPTX is asking for additional and/or more 
--                 granular roles than the ones in this CDS table.
JOIN MCHS_DB.MCHS_PROD.SA_ANESTHESIA_RECORD      SAR
  ON SCOR.NCHS_ONLY_SURGICAL_CASE_ID = SAR.SURGICAL_CASE_ID 
JOIN MCHS_DB.MCHS_PROD.SA_PARAMETER              SP
  ON SP.SA_ANESTHESIA_RECORD_ID = SAR.SA_ANESTHESIA_RECORD_ID 
JOIN MCHS_DB.MCHS_PROD.SA_REF_PARAMETER          SRP
  ON SRP.SA_REF_PARAMETER_ID = SP.SA_REF_PARAMETER_ID
JOIN MCHS_DB.MCHS_PROD.SA_PARAMETER_MONITOR      SPM
  ON SPM.SA_PARAMETER_ID = SP.SA_PARAMETER_ID 
JOIN MCHS_DB.MCHS_PROD.SA_PARAMETER_VALUE        SPV
  ON SPV.SA_PARAMETER_ID = SP.SA_PARAMETER_ID 
JOIN MCHS_DB.MCHS_PROD.DISCRETE_TASK_ASSAY       DTA
  ON DTA.TASK_ASSAY_CD = SRP.TASK_ASSAY_CD 
JOIN MCHS_DB.MCHS_PROD.CLINICAL_EVENT            CE
  ON CE.EVENT_ID = SPV.EVENT_ID
JOIN MCHS_DB.MCHS_PROD.CODE_VALUE                CV
  ON CV.CODE_VALUE = CE.RESULT_UNITS_CD 
LEFT JOIN (SELECT ENCNTR_ID AS ENCOUNTER_ID
                 ,MIN(EVENT_END_DT_TM) AS START_DT_TM
                 ,MAX(EVENT_END_DT_TM) AS END_DT_TM 
           FROM MCHS_DB.MCHS_PROD.CLINICAL_EVENT
           WHERE RESULT_STATUS_CD = 25
             AND TASK_ASSAY_CD = 19818299 -- Inspired Sevoflurane Anes (RM 2025.01.27 - Not in SPECS, added as a suggestion)
             AND RESULT_VAL > 0
           GROUP BY ENCNTR_ID) SEVOFLURANE
  ON SCOR.NCHS_ONLY_ENCOUNTER_ID = SEVOFLURANE.ENCOUNTER_ID
WHERE SAR.ACTIVE_IND = 1
  AND SAR.ACTIVE_STATUS_CD = 188
  AND SP.ACTIVE_IND = 1
  AND SP.ACTIVE_STATUS_CD = 188
  AND SRP.ACTIVE_IND = 1
  AND SRP.ACTIVE_STATUS_CD = 188
  AND SPM.ACTIVE_IND = 1
  AND SPM.ACTIVE_STATUS_CD = 188
  AND SPV.ACTIVE_IND = 1
  AND SPV.ACTIVE_STATUS_CD = 188
  AND CE.RESULT_STATUS_CD = 25
  AND SRP.TASK_ASSAY_CD IN (
--          19818972,   -- EKG Anes                       -- PowerChart Monitors
--          19818527,   -- Ventilation Mode Anes          -- PowerChart Monitors
--          19819083,   -- SPO2% Anes                     -- PowerChart Monitors
--          19818274,   -- Fi O2 % Anes                   -- PowerChart Monitors
          19818299,   -- Inspired Sevoflurane Anes        -- PowerChart MONITORS (RM 2025.01.27 - Not in SPECS, added as a suggestion)
--          19818266,   -- Fi N20 % Anes                  -- PowerChart Monitors
--          23189755,   -- RR - End Tidal Anes            -- PowerChart Monitors
--          19818545,   -- Tidal Volume Anes              -- PowerChart Monitors
--          19818512,   -- Peak Inspiratory Pressure Anes -- PowerChart Monitors
--          19818519,   -- PEEP Anes                      -- PowerChart Monitors
--          19653104,   -- Heart Rate Anes                -- PowerChart Monitors (screenshot shows 5 minutes intervals, data is every minute)
          19818260,   -- Expired Sevoflurane Anes       -- PowerChart Monitors - SPRUCE's expired_sevo_percent 
-- ---------------------------------------------------------------------------------------------------------------------------------------------
          7230129605, -- Fresh Gas Air                  -- PowerChart Vitals   - SPRUCE's air_volume
          7230133445, -- Fresh Gas O2                   -- PowerChart Vitals   - SPRUCE's o2_volume
--          7230133503, -- Total Gas Flow                 -- PowerChart Vitals
--          19654564,   -- ETCO2 Anes                     -- PowerChart Vitals
--          19654605,   -- Heart Rate - SpO2 Anes         -- PowerChart Vitals
--          19819030,   -- NIBP Systolic Anes             -- PowerChart Vitals
--          19819021,   -- NIBP Mean Anes                 -- PowerChart Vitals
--          19819014,   -- NIBP Diastolic Anes            -- PowerChart Vitals
-- ---------------------------------------------------------------------------------------------------------------------------------------------
          7230559537, -- Fresh Gas N2O                  -- ?                   - SPRUCE n20_volume
          19818235,   -- Expired Isoflurane Anes        -- ?                   - SPRUCE's expired_iso_percent
          19818228    -- Expired Desflurane Anes        -- ?                   - SPRUCE's expired_des_percent
     )
GROUP BY SCOR.NCHS_ONLY_PERSON_ID
        ,SCOR.NCHS_ONLY_MRN
        ,SCOR.NCHS_ONLY_ENCOUNTER_ID
        ,SCOR.NCHS_ONLY_FIN
        ,SCOR.NCHS_ONLY_SURGICAL_CASE_ID
        ,SCOR.SURGICAL_CASE_IDENTIFIER
        ,SCOR.ENCOUNTER_IDENTIFIER
        ,CE.EVENT_END_DT_TM
        ,TIMEDIFF(MINUTE, SEVOFLURANE.START_DT_TM, SEVOFLURANE.END_DT_TM)   
);


SELECT *
FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ENV
WHERE SURGICAL_CASE_IDENTIFIER = 'MAIN-2024-3835'
ORDER BY NCHS_ONLY_PERSON_ID      -- Private - NCHS USE only
        ,NCHS_ONLY_MRN            -- Private - NCHS USE only
        ,NCHS_ONLY_ENCOUNTER_ID   -- Private - NCHS USE only
        ,NCHS_ONLY_FIN            -- Private - NCHS USE only
        ,SURGICAL_CASE_IDENTIFIER -- Only NCHS ID field shared with ADAPTX
        ,OR_ENCOUNTER_IDENTIFIER  -- De-Identified/Tokenized
        ,GAS_TS;

--  AND SAR.RECORD_DESCRIPTION = 'MAIN-2024-4584'
--  AND SAR.SA_ANESTHESIA_RECORD_ID IN (621420685, 636177896, 636187577, 621420685)     

SELECT CV.CODE_VALUE,
       CV.DISPLAY,
       CV.ACTIVE_IND
FROM MCHS_DB.MCHS_PROD.CODE_VALUE CV
WHERE CV.CODE_SET = 72
  AND UPPER(CV.DISPLAY) LIKE '%SEVOFLURANE%'
   OR CV.CODE_VALUE IN (2798655,19818257,19818296, 19818299)
  
SELECT *
FROM MCHS_DB.MCHS_PROD.CLINICAL_EVENT CE 
WHERE CE.ENCNTR_ID = 62298688
  AND CE.EVENT_CD IN (2798655,19818257,19818296, 19818299)