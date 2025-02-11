-- Surgical Case Monitor and Vitals.sql
-- RM 2024.10.22 - Creation

-- ********** MONITOR AND VITALS ***************
--    MCHS_DB.MCHS_PROD.SA_PARAMETER
--    MCHS_DB.MCHS_PROD.SA_PARAMETER_MONITOR
--    MCHS_DB.MCHS_PROD.SA_PARAMETER_VALUE
--    MCHS_DB.MCHS_PROD.SA_REF_PARAMETER
--    MCHS_DB.MCHS_PROD.SA_REF_CAT_PARAMETER -- Not used - all records have the category of 'All Parameters'
--    MCHS_DB.MCHS_PROD.SA_REF_CATEGORY      -- Not used - all records have the category of 'All Parameters'
-- RM 2024.10.01 - Check why only 3 of the 7 task codes are returnng in the query
SELECT WE.PATIENT 
--      ,WE.PERSON_ID
      ,WE.MEDICAL_RECORD_NUMBER AS MRN
      ,WE.FINANCIAL_NUMBER AS FIN
--      ,WE.ENCOUNTER_ID
--      ,SC.SURG_START_DT_TM 
--      ,SAR.SURGICAL_CASE_ID 
      ,SAR.RECORD_DESCRIPTION AS SURGICAL_CASE
--      ,SAR.SA_ANESTHESIA_RECORD_ID
--      ,SRP.TASK_ASSAY_CD 
      ,DTA.DESCRIPTION AS TASK_ASSAY
      ,CASE 
         WHEN SRP.TASK_ASSAY_CD IN (19818260, 7230129605, 7230133445, 7230559537, 19818228, 19818235) THEN 'Yes'
         ELSE 'No'
       END AS REQUIRED_BY_PROJ_SPRUCE
--      ,SRC.CATEGORY_NAME -- Not used - all records have the category of 'All Parameters'
      ,SPV.VALUE_DT_TM   -- SPRUCE (gas_ts)?
--      ,SPM.*
--      ,SPV.NOMENCLATURE_ID 
--      ,SPV.NUMERIC_VALUE - Same as CE.RESULT_VAL
      ,SPV.MONITORED_VALUE_IND 
      ,CE.EVENT_ID 
      ,CE.EVENT_CD 
      ,CE.RESULT_VAL 
--      ,CE.RESULT_UNITS_CD 
      ,CV.DISPLAY AS RESULT_UNITS
      ,CE.EVENT_TAG 
FROM MCHS_DB.MCHS_PROD.SURGICAL_CASE             SC
JOIN MCHS_CUSTOM_DB.ODS.VW_W_ENCOUNTER           WE
  ON WE.ENCOUNTER_ID = SC.ENCNTR_ID 
JOIN MCHS_DB.MCHS_PROD.SA_ANESTHESIA_RECORD      SAR
  ON SC.SURG_CASE_ID = SAR.SURGICAL_CASE_ID 
JOIN MCHS_DB.MCHS_PROD.SA_PARAMETER              SP
  ON SP.SA_ANESTHESIA_RECORD_ID = SAR.SA_ANESTHESIA_RECORD_ID 
JOIN MCHS_DB.MCHS_PROD.SA_REF_PARAMETER          SRP
  ON SRP.SA_REF_PARAMETER_ID = SP.SA_REF_PARAMETER_ID
--JOIN MCHS_DB.MCHS_PROD.SA_REF_CAT_PARAMETER      SRCP  -- Not used - all records have the category of 'All Parameters'
--  ON SRCP.SA_REF_PARAMETER_ID = SRP.SA_REF_PARAMETER_ID 
--JOIN MCHS_DB.MCHS_PROD.SA_REF_CATEGORY           SRC  -- Not used - all records have the category of 'All Parameters'
--  ON SRC.SA_REF_CATEGORY_ID = SRCP.SA_REF_CATEGORY_ID 
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
WHERE SAR.ACTIVE_IND = 1
  AND SAR.ACTIVE_STATUS_CD = 188
  AND SP.ACTIVE_IND = 1
  AND SP.ACTIVE_STATUS_CD = 188
  AND SRP.ACTIVE_IND = 1
  AND SRP.ACTIVE_STATUS_CD = 188
--  AND SRCP.ACTIVE_IND = 1
--  AND SRCP.ACTIVE_STATUS_CD = 188
--  AND SRC.ACTIVE_IND = 1
--  AND SRC.ACTIVE_STATUS_CD = 188
  AND SPM.ACTIVE_IND = 1
  AND SPM.ACTIVE_STATUS_CD = 188
  AND SPV.ACTIVE_IND = 1
  AND SPV.ACTIVE_STATUS_CD = 188
  AND CE.RESULT_STATUS_CD = 25
  AND SRP.TASK_ASSAY_CD IN (
          19818972,   -- EKG Anes                       -- PowerChart Monitors
          19818527,   -- Ventilation Mode Anes          -- PowerChart Monitors
          19819083,   -- SPO2% Anes                     -- PowerChart Monitors
          19818274,   -- Fi O2 % Anes                   -- PowerChart Monitors
          19818299,   -- Inspired Sevoflurane Anes      -- PowerChart Monitors
          19818266,   -- Fi N20 % Anes                  -- PowerChart Monitors
          23189755,   -- RR - End Tidal Anes            -- PowerChart Monitors
          19818545,   -- Tidal Volume Anes              -- PowerChart Monitors
          19818512,   -- Peak Inspiratory Pressure Anes -- PowerChart Monitors
          19818519,   -- PEEP Anes                      -- PowerChart Monitors
          19653104,   -- Heart Rate Anes                -- PowerChart Monitors (screenshot shows 5 minutes intervals, data is every minute)
          19818260,   -- Expired Sevoflurane Anes       -- PowerChart Monitors - SPRUCE (exp_sevo_prcnt)?
-- ---------------------------------------------------------------------------------------------------------------------------------------------
          7230129605, -- Fresh Gas Air                  -- PowerChart Vitals   - SPRUCE (air_volume)?
          7230133445, -- Fresh Gas O2                   -- PowerChart Vitals   - SPRUCE (o2_volume)?
          7230133503, -- Total Gas Flow                 -- PowerChart Vitals
          19654564,   -- ETCO2 Anes                     -- PowerChart Vitals
          19654605,   -- Heart Rate - SpO2 Anes         -- PowerChart Vitals
          19819030,   -- NIBP Systolic Anes             -- PowerChart Vitals
          19819021,   -- NIBP Mean Anes                 -- PowerChart Vitals
          19819014,   -- NIBP Diastolic Anes            -- PowerChart Vitals
-- ---------------------------------------------------------------------------------------------------------------------------------------------
          7230559537, -- Fresh Gas N2O                  -- ?                   - SPRUCE (n20_volume)?
            19818228, -- Expired Desflurane Anes        -- ?                   - SPRUCE (exp_des_prcnt)?
            19818235  -- Expired Isoflurane Anes        -- ?                   - SPRUCE (exp_iso_prcnt)?
     )
  AND SAR.RECORD_DESCRIPTION = 'MAIN-2024-3835'
--  AND SAR.RECORD_DESCRIPTION = 'MAIN-2024-4584' -- Expired Sevoflurane Anes
--  AND SAR.RECORD_DESCRIPTION = 'CATH-2024-559'  -- Expired Sevoflurane Anes
--  AND SAR.RECORD_DESCRIPTION =  'NCHSS-2024-7679' -- SAR.SA_ANESTHESIA_RECORD_ID = 636121357 -- Not found   
--  AND SAR.RECORD_DESCRIPTION =  'MAIN-2024-4584'
--  AND SAR.SA_ANESTHESIA_RECORD_ID IN (621420685, 636177896, 636187577, 621420685)     
ORDER BY SAR.SURGICAL_CASE_ID
        ,DTA.DESCRIPTION
        ,SPV.VALUE_DT_TM;
  

-- Lactated Ringers IV Sol 500 mL ???

SELECT CE.PERSON_ID
      ,CE.ENCNTR_ID
--      ,CE.CLINICAL_EVENT_ID
      ,CE.PARENT_EVENT_ID
      ,CE.EVENT_ID
      ,CE.EVENT_CLASS_CD
      ,MCHS_CUSTOM_DB.PUBLIC.LOOKUP_DISPLAY(CE.EVENT_CLASS_CD) AS EVENT_CLASS
      ,CE.EVENT_START_DT_TM
      ,CE.EVENT_END_DT_TM
      ,CE.PERFORMED_DT_TM
      ,CE.VALID_UNTIL_DT_TM
      ,CE.EVENT_TITLE_TEXT
      ,CE.VIEW_LEVEL
      ,CE.ORDER_ID
      ,CE.CATALOG_CD
      ,OC.DESCRIPTION AS CATALOG_DESCRIPTION
      ,CE.TASK_ASSAY_CD
      ,DTA.DESCRIPTION AS TASK_ASSAY
      ,CE.REFERENCE_NBR
      ,CE.EVENT_RELTN_CD
      ,MCHS_CUSTOM_DB.PUBLIC.LOOKUP_DISPLAY(CE.EVENT_RELTN_CD) AS EVENT_RELTN
      ,CE.VALID_FROM_DT_TM
      ,CE.EVENT_CD
      ,MCHS_CUSTOM_DB.PUBLIC.LOOKUP_DISPLAY(CE.EVENT_CD) AS EVENT
      ,CE.EVENT_TAG
      ,CE.RESULT_VAL
      ,CE.RESULT_UNITS_CD
      ,MCHS_CUSTOM_DB.PUBLIC.LOOKUP_DISPLAY(CE.RESULT_UNITS_CD) AS RESULT_UNITS
FROM MCHS_DB.MCHS_PROD.CLINICAL_EVENT         CE
JOIN MCHS_DB.MCHS_PROD.DISCRETE_TASK_ASSAY    DTA
  ON DTA.TASK_ASSAY_CD = CE.TASK_ASSAY_CD 
JOIN MCHS_DB.MCHS_PROD.ORDER_CATALOG          OC
  ON OC.CATALOG_CD = CE.CATALOG_CD 
WHERE CE.ENCNTR_ID = 62298688
  AND CE.EVENT_END_DT_TM BETWEEN '2024-09-12 13:01:00.000' AND '2024-09-12 16:15:00.000'
  AND CE.RESULT_STATUS_CD = 25
--  AND CE.VIEW_LEVEL > 0
--  AND CE.EVENT_CD IN  
--  (68642866, -- Peripheral IV (start of IV)
--    2799021) -- Lactated Ringers Injection (end of IV)
  AND CE.TASK_ASSAY_CD NOT IN (
          19818972,   -- EKG Anes                       -- PowerChart Monitors
          19818527,   -- Ventilation Mode Anes          -- PowerChart Monitors
          19819083,   -- SPO2% Anes                     -- PowerChart Monitors
          19818274,   -- Fi O2 % Anes                   -- PowerChart Monitors
          19818299,   -- Inspired Sevoflurane Anes      -- PowerChart Monitors
          19818266,   -- Fi N20 % Anes                  -- PowerChart Monitors
          23189755,   -- RR - End Tidal Anes            -- PowerChart Monitors
          19818545,   -- Tidal Volume Anes              -- PowerChart Monitors
          19818512,   -- Peak Inspiratory Pressure Anes -- PowerChart Monitors
          19818519,   -- PEEP Anes                      -- PowerChart Monitors
          19653104,   -- Heart Rate Anes                -- PowerChart Monitors (screenshot shows 5 minutes intervals, data is every minute)
          19818260,   -- Expired Sevoflurane Anes       -- PowerChart Monitors - SPRUCE (exp_sevo_prcnt)?
-- ---------------------------------------------------------------------------------------------------------------------------------------------
          7230129605, -- Fresh Gas Air                  -- PowerChart Vitals   - SPRUCE (air_volume)?
          7230133445, -- Fresh Gas O2                   -- PowerChart Vitals   - SPRUCE (o2_volume)?
          7230133503, -- Total Gas Flow                 -- PowerChart Vitals
          19654564,   -- ETCO2 Anes                     -- PowerChart Vitals
          19654605,   -- Heart Rate - SpO2 Anes         -- PowerChart Vitals
          19819030,   -- NIBP Systolic Anes             -- PowerChart Vitals
          19819021,   -- NIBP Mean Anes                 -- PowerChart Vitals
          19819014,   -- NIBP Diastolic Anes            -- PowerChart Vitals
-- ---------------------------------------------------------------------------------------------------------------------------------------------
          7230559537, -- Fresh Gas N2O                  -- ?                   - SPRUCE (n20_volume)?
            19818228, -- Expired Desflurane Anes        -- ?                   - SPRUCE (exp_des_prcnt)?
            19818235  -- Expired Isoflurane Anes        -- ?                   - SPRUCE (exp_iso_prcnt)?
     )
  AND CE.PARENT_EVENT_ID = CE.EVENT_ID   
ORDER BY CE.PARENT_EVENT_ID
        ,CE.EVENT_ID;

SELECT CODE_VALUE,
       DISPLAY
FROM MCHS_DB.MCHS_PROD.CODE_VALUE
WHERE CODE_VALUE IN (223,224,231,232,233,236,4053628)
ORDER BY CODE_VALUE;

