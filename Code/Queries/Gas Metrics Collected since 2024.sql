-- Gas Metrics Collected since 2024.sql
-- RM 2025.01.21 - Creation

SELECT SC.SURG_START_DT_TM::DATE                       AS SURGERY_DATE
      ,SC.CASE_NUM                                     AS OR_CASE_NUM
      ,SUM(CASE
             WHEN SRP.TASK_ASSAY_CD = 7230129605  -- Fresh Gas Air, PowerChart Vitals
             THEN 1 ELSE 0
           END)                                        AS AIR_VOLUME
      ,SUM(CASE
             WHEN SRP.TASK_ASSAY_CD = 7230133445  -- Fresh Gas O2, PowerChart Vitals
             THEN 1 ELSE 0
           END)                                        AS O2_VOLUME
      ,SUM(CASE
             WHEN SRP.TASK_ASSAY_CD = 7230559537  -- Fresh Gas N2O,
             THEN 1 ELSE 0
           END)                                        AS N2O_VOLUME
      ,SUM(CASE
             WHEN SRP.TASK_ASSAY_CD = 19818228    -- Expired Desflurane Anes,
             THEN 1 ELSE 0
           END)                                        AS EXPIRED_DES_PERCENT
      ,SUM(CASE
             WHEN SRP.TASK_ASSAY_CD = 19818235    -- Expired Isoflurane Anes
             THEN 1 ELSE 0
           END)                                        AS EXPIRED_ISO_PERCENT                     
      ,SUM(CASE
             WHEN SRP.TASK_ASSAY_CD = 19818260    -- Expired Sevoflurane Anes       -- PowerChart Monitors 
             THEN 1 ELSE 0
           END)                                        AS EXPIRED_SEVO_PERCENT
FROM MCHS_CUSTOM_DB.ODS.CDS_F_SURGERY_CASE    SC
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
JOIN MCHS_DB.MCHS_PROD.CODE_VALUE                CV
  ON CV.CODE_VALUE = CE.RESULT_UNITS_CD 
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
          19818260,   -- Expired Sevoflurane Anes       -- PowerChart Monitors - SPRUCE's expired_sevo_percent 
          7230129605, -- Fresh Gas Air                  -- PowerChart Vitals   - SPRUCE's air_volume
          7230133445, -- Fresh Gas O2                   -- PowerChart Vitals   - SPRUCE's o2_volume
          7230559537, -- Fresh Gas N2O                  -- ?                   - SPRUCE n20_volume
          19818235,   -- Expired Isoflurane Anes        -- ?                   - SPRUCE's expired_iso_percent
          19818228    -- Expired Desflurane Anes        -- ?                   - SPRUCE's expired_des_percent
     )
  AND CE.EVENT_END_DT_TM > '2024-01-01'
GROUP BY SC.SURG_START_DT_TM::DATE, SC.CASE_NUM 
ORDER BY SC.SURG_START_DT_TM::DATE, SC.CASE_NUM;


SELECT *
FROM MCHS_DB.MCHS_PROD.DISCRETE_TASK_ASSAY DTA
WHERE UPPER(DTA.DESCRIPTION) LIKE '%EXPIRED%';