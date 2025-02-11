-- Anethesia Metrics Collected since 2024.sql
-- RM 2025.01.21 - Creation

SELECT DTA.TASK_ASSAY_CD 
      ,DTA.DESCRIPTION AS TASK_ASSAY
      ,SPV.MONITORED_VALUE_IND 
      ,CE.EVENT_CD 
      ,MIN(CE.EVENT_END_DT_TM) AS STARTED_COLLECTING_DT
FROM MCHS_CUSTOM_DB.ODS.CDS_F_SURGERY_CASE       SC
JOIN MCHS_DB.MCHS_PROD.SA_ANESTHESIA_RECORD      SAR
  ON SC.SURG_CASE_ID = SAR.SURGICAL_CASE_ID 
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
          19818260,   -- Expired Sevoflurane Anes       -- PowerChart Monitors - SPRUCE's expired_sevo_percent 
-- ---------------------------------------------------------------------------------------------------------------------------------------------
          7230129605, -- Fresh Gas Air                  -- PowerChart Vitals   - SPRUCE's air_volume
          7230133445, -- Fresh Gas O2                   -- PowerChart Vitals   - SPRUCE's o2_volume
          7230133503, -- Total Gas Flow                 -- PowerChart Vitals
          19654564,   -- ETCO2 Anes                     -- PowerChart Vitals
          19654605,   -- Heart Rate - SpO2 Anes         -- PowerChart Vitals
          19819030,   -- NIBP Systolic Anes             -- PowerChart Vitals
          19819021,   -- NIBP Mean Anes                 -- PowerChart Vitals
          19819014,   -- NIBP Diastolic Anes            -- PowerChart Vitals
-- ---------------------------------------------------------------------------------------------------------------------------------------------
          7230559537, -- Fresh Gas N2O                  -- ?                   - SPRUCE n20_volume
          19818235,   -- Expired Isoflurane Anes        -- ?                   - SPRUCE's expired_iso_percent
          19818228    -- Expired Desflurane Anes        -- ?                   - SPRUCE's expired_des_percent
     )
  AND CE.EVENT_END_DT_TM > '2024-01-01'
GROUP BY DTA.TASK_ASSAY_CD 
        ,DTA.DESCRIPTION
        ,SPV.MONITORED_VALUE_IND 
        ,CE.EVENT_CD
ORDER BY DTA.TASK_ASSAY_CD 
        ,DTA.DESCRIPTION
        ,SPV.MONITORED_VALUE_IND 
        ,CE.EVENT_CD;