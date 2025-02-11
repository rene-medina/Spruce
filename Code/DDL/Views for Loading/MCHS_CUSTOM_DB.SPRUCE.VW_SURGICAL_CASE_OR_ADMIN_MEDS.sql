-- MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ADMIN_MEDS.sql
-- RM 2025.02.04 - Creation


--DROP VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ADMIN_MEDS;
CREATE OR REPLACE VIEW MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ADMIN_MEDS AS (
SELECT MEDS.NCHS_ONLY_PERSON_ID              AS NCHS_ONLY_PERSON_ID 
      ,MEDS.NCHS_ONLY_MRN                    AS NCHS_ONLY_MRN 
      ,MEDS.NCHS_ONLY_ENCOUNTER_ID           AS NCHS_ONLY_ENCOUNTER_ID 
      ,MEDS.NCHS_ONLY_FIN                    AS NCHS_ONLY_FIN
      ,MEDS.NCHS_ONLY_SURGICAL_CASE_ID       AS NCHS_ONLY_SURGICAL_CASE_ID
      ,MEDS.PRESCRIBINGID                    AS NCHS_ONLY_ORDER_ID_SEQUENCE
      ,MEDS.ORDER_PROVIDER_ID                AS NCHS_ONLY_ORDER_PROVIDER_ID
      ,MEDS.SURGICAL_CASE_IDENTIFIER         AS OR_SURGICAL_CASE_IDENTIFIER
      ,MEDS.ENCOUNTER_IDENTIFIER             AS OR_ENCOUNTER_IDENTIFIER
      ,MEDS.RAW_MEDADMIN_MED_NAME            AS MEDICATION_NAME
      ,MEDS.MEDADMIN_ROUTE                   AS MEDICATION_ROUTE
      ,CASE MEDS.MEDADMIN_ROUTE
--         WHEN '?' THEN 'Inhalation'
         WHEN 'INTRAVENOUS' THEN 'Injection/IV'
         WHEN 'ORAL' THEN 'Oral'
         WHEN 'RECTAL' THEN 'Rectal'
         WHEN 'SUBLINGUAL' THEN 'Sublingual/Buccal'
         WHEN 'TOPICAL' THEN 'Topical'
         WHEN 'TRANSDERMAL' THEN 'Transdermal'
         ELSE '<UNKNOWN>'         
       END                                   AS MEDICATION_ROUTE_MAPPED
      ,CONCAT(TO_CHAR(
          MEDS.MEDADMIN_START_DATE,'YYYY-MM-DD'), 
          ' ', MEDS.MEDADMIN_START_TIME
          )::TIMESTAMP                       AS MEDICATION_ADMINISTRATION_TS
      ,CURRENT_TIMESTAMP                     AS DW_UPDATE_TS
FROM ( 
SELECT SCOR.NCHS_ONLY_PERSON_ID                                                                          AS NCHS_ONLY_PERSON_ID 
      ,SCOR.NCHS_ONLY_MRN                                                                                AS NCHS_ONLY_MRN 
      ,SCOR.NCHS_ONLY_ENCOUNTER_ID                                                                       AS NCHS_ONLY_ENCOUNTER_ID 
      ,SCOR.NCHS_ONLY_FIN                                                                                AS NCHS_ONLY_FIN
      ,SCOR.NCHS_ONLY_SURGICAL_CASE_ID                                                                   AS NCHS_ONLY_SURGICAL_CASE_ID
      ,TO_CHAR (OA.ORDER_ID) || '.' || TO_CHAR (OA.ACTION_SEQUENCE)                                      AS PRESCRIBINGID
      ,OA.ORDER_PROVIDER_ID                                                                              AS ORDER_PROVIDER_ID 
      ,SCOR.SURGICAL_CASE_IDENTIFIER                                                                     AS SURGICAL_CASE_IDENTIFIER
      ,SCOR.ENCOUNTER_IDENTIFIER                                                                         AS ENCOUNTER_IDENTIFIER
      ,CASE
         WHEN (LENGTH(TRIM(B.REQ_START_DT_TM)) = 8 
               AND TRY_TO_DATE(SUBSTR(B.REQ_START_DT_TM,1,8), 'MM/DD/YY')     IS NOT NULL) THEN TO_DATE(SUBSTR(B.REQ_START_DT_TM,1,8), 'MM/DD/YY')
         WHEN TRY_TO_DATE(SUBSTR(B.REQ_START_DT_TM,1,8),      'MM/DD/YY')     IS NOT NULL  THEN TO_DATE(SUBSTR(B.REQ_START_DT_TM,1,8), 'MM/DD/YY')
         WHEN TRY_TO_DATE(SUBSTR(B.REQ_START_DT_TM,1,10),     'MM/DD/YYYY')   IS NOT NULL  THEN TO_DATE(SUBSTR(B.REQ_START_DT_TM,1,10),'MM/DD/YYYY')
         WHEN TRY_TO_DATE(SUBSTR(B.REQ_START_DT_TM,1,11),     'DD/MON/YYYY')  IS NOT NULL  THEN TO_DATE(SUBSTR(B.REQ_START_DT_TM,1,11),'DD/MON/YYYY')
         WHEN TRY_TO_DATE(SUBSTR(B.REQ_START_DT_TM,1,11),     'DD-MON-YYYY')  IS NOT NULL  THEN TO_DATE(SUBSTR(B.REQ_START_DT_TM,1,11),'DD-MON-YYYY')
         WHEN TRY_TO_DATE(SUBSTR(B.REQ_START_DT_TM,1,11),     'DD MON YYYY')  IS NOT NULL  THEN TO_DATE(SUBSTR(B.REQ_START_DT_TM,1,11),'DD MON YYYY')
         ELSE NULL 
       END                                                                                               AS MEDADMIN_START_DATE
      ,CASE 
         WHEN TRY_TO_TIMESTAMP(SUBSTR(B.REQ_START_DT_TM,1,17),'MM/DD/YY HH:MI:SS')    IS NOT NULL THEN LPAD(TRIM(SUBSTR(B.REQ_START_DT_TM,10,8)),8,'0')
         WHEN TRY_TO_TIMESTAMP(SUBSTR(B.REQ_START_DT_TM,1,14),'MM/DD/YY HH:MI')       IS NOT NULL THEN TRIM(SUBSTR(B.REQ_START_DT_TM,12,8)) || ':00'
         WHEN TRY_TO_TIMESTAMP(SUBSTR(B.REQ_START_DT_TM,1,16),'MM/DD/YYYY HH:MI')     IS NOT NULL THEN TRIM(SUBSTR(B.REQ_START_DT_TM,12,8)) || ':00'
         WHEN TRY_TO_TIMESTAMP(SUBSTR(B.REQ_START_DT_TM,1,18),'MM/DD/YYYY HH:MI:SS')  IS NOT NULL THEN LPAD(TRIM(SUBSTR(B.REQ_START_DT_TM,11,8)),8,'0')
         WHEN TRY_TO_TIMESTAMP(SUBSTR(B.REQ_START_DT_TM,1,20),'DD/MON/YYYY HH:MI:SS') IS NOT NULL THEN LPAD(TRIM(SUBSTR(B.REQ_START_DT_TM,13,8)),8,'0')
         WHEN TRY_TO_TIMESTAMP(B.REQ_START_DT_TM,             'DD-MON-YYYY HH:MI')    IS NOT NULL THEN TRIM(SUBSTR(B.REQ_START_DT_TM,13,8)) || ':00'
         WHEN TRY_TO_TIMESTAMP(B.REQ_START_DT_TM,             'DD MON YYYY HH:MI')    IS NOT NULL THEN TRIM(SUBSTR(B.REQ_START_DT_TM,13,8)) || ':00'
         WHEN (LENGTH(B.REQ_START_DT_TM) = 8 AND TRY_TO_DATE(B.REQ_START_DT_TM,'MM/DD/YY') IS NOT NULL) THEN '00:00:00'
         ELSE NULL 
       END                                                                                               AS MEDADMIN_START_TIME
      ,CASE
         WHEN (LENGTH(TRIM(B.STOP_DT_TM)) = 8 
               AND TRY_TO_DATE(SUBSTR(B.STOP_DT_TM,1,8), 'MM/DD/YY')     IS NOT NULL) THEN TO_DATE(SUBSTR(B.STOP_DT_TM,1,8),'MM/DD/YY')
         WHEN TRY_TO_DATE(SUBSTR(B.STOP_DT_TM,1,8),      'MM/DD/YY')     IS NOT NULL  THEN TO_DATE(SUBSTR(B.STOP_DT_TM,1,8),'MM/DD/YY')
         WHEN TRY_TO_DATE(SUBSTR(B.STOP_DT_TM,1,10),     'MM/DD/YYYY')   IS NOT NULL  THEN TO_DATE(SUBSTR(B.STOP_DT_TM,1,10),'MM/DD/YYYY')
         WHEN TRY_TO_DATE(SUBSTR(B.STOP_DT_TM,1,11),     'DD/MON/YYYY')  IS NOT NULL  THEN TO_DATE(SUBSTR(B.STOP_DT_TM,1,11),'DD/MON/YYYY')
         WHEN TRY_TO_DATE(SUBSTR(B.STOP_DT_TM,1,11),     'DD-MON-YYYY')  IS NOT NULL  THEN TO_DATE(SUBSTR(B.STOP_DT_TM,1,11),'DD-MON-YYYY')
         WHEN TRY_TO_DATE(SUBSTR(B.STOP_DT_TM,1,11),     'DD MON YYYY')  IS NOT NULL  THEN TO_DATE(SUBSTR(B.STOP_DT_TM,1,11),'DD MON YYYY')
         ELSE NULL 
       END                                                                                               AS MEDADMIN_STOP_DATE
      ,CASE 
         WHEN TRY_TO_TIMESTAMP(SUBSTR(B.STOP_DT_TM,1,17),'MM/DD/YY HH:MI:SS')    IS NOT NULL THEN LPAD(TRIM(SUBSTR(B.STOP_DT_TM,10,8)),8,'0')
         WHEN TRY_TO_TIMESTAMP(SUBSTR(B.STOP_DT_TM,1,14),'MM/DD/YY HH:MI')       IS NOT NULL THEN TRIM(SUBSTR(B.STOP_DT_TM,12,8)) || ':00'
         WHEN TRY_TO_TIMESTAMP(SUBSTR(B.STOP_DT_TM,1,16),'MM/DD/YYYY HH:MI')     IS NOT NULL THEN TRIM(SUBSTR(B.STOP_DT_TM,12,8)) || ':00'
         WHEN TRY_TO_TIMESTAMP(SUBSTR(B.STOP_DT_TM,1,18),'MM/DD/YYYY HH:MI:SS')  IS NOT NULL THEN LPAD(TRIM(SUBSTR(B.STOP_DT_TM,11,8)),8,'0')
         WHEN TRY_TO_TIMESTAMP(SUBSTR(B.STOP_DT_TM,1,20),'DD/MON/YYYY HH:MI:SS') IS NOT NULL THEN LPAD(TRIM(SUBSTR(B.STOP_DT_TM,13,8)),8,'0')
         WHEN TRY_TO_TIMESTAMP(B.STOP_DT_TM,             'DD-MON-YYYY HH:MI')    IS NOT NULL THEN TRIM(SUBSTR(B.STOP_DT_TM,13,8)) || ':00'
         WHEN TRY_TO_TIMESTAMP(B.STOP_DT_TM,             'DD MON YYYY HH:MI')    IS NOT NULL THEN TRIM(SUBSTR(B.STOP_DT_TM,13,8)) || ':00'
         WHEN (LENGTH(B.STOP_DT_TM) = 8 AND TRY_TO_DATE(B.STOP_DT_TM,'MM/DD/YY') IS NOT NULL) THEN '00:00:00'
         ELSE NULL 
       END                                                                                               AS MEDADMIN_STOP_TIME
      ,CASE
         WHEN B.STRENGTH_DOSE IS NULL   -- Strength Dose
           THEN B.VOLUME_DOSE           -- Volume Dose
         ELSE B.STRENGTH_DOSE
       END                                                                                               AS MEDADMIN_DOSE_ADMIN
      ,COALESCE(PDU.VS_VALUESET_ITEM, 'OT')                                                              AS MEDADMIN_DOSE_ADMIN_UNIT
      ,CASE 
         WHEN PRR.VS_VALUESET_ITEM IS NULL THEN NULL
         ELSE PRR.VS_VALUESET_ITEM  
       END                                                                                               AS MEDADMIN_ROUTE      
      ,CASE
         WHEN O.ORDER_MNEMONIC LIKE 'Patient%'
           THEN O.ORDER_MNEMONIC || ' (' || O.ORDERED_AS_MNEMONIC || ')'
         ELSE O.ORDER_MNEMONIC
       END                                                                                               AS RAW_MEDADMIN_MED_NAME
      ,CASE
         WHEN B.STRENGTH_DOSE IS NULL   -- Strength Dose
           THEN B.VOLUME_DOSE           -- Volume Dose
         ELSE B.STRENGTH_DOSE
       END                                                                                               AS RAW_MEDADMIN_DOSE_ADMIN
      ,CASE
         WHEN B.STRENGTH_DOSE_UNIT IS NULL -- Strength Dose Unit
           THEN B.VOLUME_DOSE_UNIT         -- Volume Dose Unit 
         ELSE B.STRENGTH_DOSE_UNIT 
       END                                                                                               AS RAW_MEDADMIN_DOSE_ADMIN_UNIT
      ,ADMINISTRATION_ROUTE_CODE                                                                         AS RAW_MEDADMIN_ROUTE
FROM MCHS_CUSTOM_DB.SPRUCE.SURGICAL_CASE_OR SCOR
LEFT JOIN MCHS_DB.MCHS_PROD.ORDERS          O 
  ON SCOR.NCHS_ONLY_ENCOUNTER_ID = O.ENCNTR_ID
-- RM 2025.02.04 - Fix for incongruent status code between ORDERS and ORDER_ACTION, which were allowing Deleted medication to be loaded. 
 AND O.ORDER_STATUS_CD = 2543 -- Completed
 AND O.DEPT_STATUS_CD = 9312  -- Completed
LEFT JOIN MCHS_DB.MCHS_PROD.ORDER_ACTION OA 
  ON O.ORDER_ID = OA.ORDER_ID
-- RM 2025.02.04 - Fix for incongruent status code between ORDERS and ORDER_ACTION, which were allowing Deleted medication to be loaded. 
 AND O.ORDER_STATUS_CD = 2543 -- Completed
 AND O.DEPT_STATUS_CD = 9312  -- Completed
LEFT JOIN
     (SELECT A.ORDER_ID
            ,A.ACTION_SEQUENCE
            ,MAX(A.REQ_START_DT_TM)           AS REQ_START_DT_TM
            ,MAX(A.NBR_OF_REFILLS)            AS NBR_OF_REFILLS
            ,MAX(A.DRUG_DOSE)                 AS DRUG_DOSE
            ,MAX(A.ADMINISTRATION_ROUTE)      AS ADMINISTRATION_ROUTE
            ,MAX(A.ADMINISTRATION_ROUTE_CODE) AS ADMINISTRATION_ROUTE_CODE
            ,MAX(A.STRENGTH_DOSE)             AS STRENGTH_DOSE
            ,MAX(A.STRENGTH_DOSE_UNIT)        AS STRENGTH_DOSE_UNIT
            ,MAX(A.STRENGTH_DOSE_UNIT_CODE)   AS STRENGTH_DOSE_UNIT_CODE
            ,MAX(A.VOLUME_DOSE)               AS VOLUME_DOSE
            ,MAX(A.VOLUME_DOSE_UNIT)          AS VOLUME_DOSE_UNIT
            ,MAX(A.VOLUME_DOSE_UNIT_CODE)     AS VOLUME_DOSE_UNIT_CODE
            ,MAX(A.DURATION)                  AS DURATION
            ,MAX(A.STOP_DT_TM)                AS STOP_DT_TM
            ,MAX(A.TOTAL_REFILLS)             AS TOTAL_REFILLS
      FROM (SELECT OD.ORDER_ID
                  ,OD.ACTION_SEQUENCE
                  ,CASE WHEN OD.OE_FIELD_ID =  12620 THEN OD.OE_FIELD_DISPLAY_VALUE END AS REQ_START_DT_TM 
                  ,CASE WHEN OD.OE_FIELD_ID =  12628 THEN OD.OE_FIELD_DISPLAY_VALUE END AS NBR_OF_REFILLS 
                  ,CASE WHEN OD.OE_FIELD_ID =  12693 THEN OD.OE_FIELD_DISPLAY_VALUE END AS DRUG_DOSE
                  ,CASE WHEN OD.OE_FIELD_ID =  12711 THEN OD.OE_FIELD_DISPLAY_VALUE END AS ADMINISTRATION_ROUTE
                  ,CASE WHEN OD.OE_FIELD_ID =  12711 THEN OD.OE_FIELD_VALUE         END AS ADMINISTRATION_ROUTE_CODE
                  ,CASE WHEN OD.OE_FIELD_ID =  12715 THEN OD.OE_FIELD_DISPLAY_VALUE END AS STRENGTH_DOSE
                  ,CASE WHEN OD.OE_FIELD_ID =  12716 THEN OD.OE_FIELD_DISPLAY_VALUE END AS STRENGTH_DOSE_UNIT
                  ,CASE WHEN OD.OE_FIELD_ID =  12716 THEN OD.OE_FIELD_VALUE         END AS STRENGTH_DOSE_UNIT_CODE
                  ,CASE WHEN OD.OE_FIELD_ID =  12718 THEN OD.OE_FIELD_DISPLAY_VALUE END AS VOLUME_DOSE
                  ,CASE WHEN OD.OE_FIELD_ID =  12719 THEN OD.OE_FIELD_DISPLAY_VALUE END AS VOLUME_DOSE_UNIT
                  ,CASE WHEN OD.OE_FIELD_ID =  12719 THEN OD.OE_FIELD_VALUE         END AS VOLUME_DOSE_UNIT_CODE
                  ,CASE WHEN OD.OE_FIELD_ID =  12721 THEN OD.OE_FIELD_DISPLAY_VALUE END AS DURATION
                  ,CASE WHEN OD.OE_FIELD_ID =  12731 THEN OD.OE_FIELD_DISPLAY_VALUE END AS STOP_DT_TM
                  ,CASE WHEN OD.OE_FIELD_ID = 634309 THEN OD.OE_FIELD_DISPLAY_VALUE END AS TOTAL_REFILLS
            FROM MCHS_DB.MCHS_PROD.ORDER_DETAIL OD
            WHERE OD.OE_FIELD_ID IN 
                ( 12620, -- Code_Set 16449 Order Entry Fields, Code_Value 12620  Requested Start Date/Time
                  12628, -- Code_Set 16449 Order Entry Fields, Code_Value 12628  Number of Refills
--                  12690, -- Code_Set 16449 Order Entry Fields, Code_Value 12690  Frequency
                  12693, -- Code_Set 16449 Order Entry Fields, Code_Value 12693  Drug from (dose from)
                  12711, -- Code_Set 16449 Order Entry Fields, Code_Value 12711  Route of Administration
                  12715, -- Code_Set 16449 Order Entry Fields, Code_Value 12716  Strength Dose
                  12716, -- Code_Set 16449 Order Entry Fields, Code_Value 12716  Strength Dose Unit
                  12718, -- Code_Set 16449 Order Entry Fields, Code_Value 12718  Volume Dose
                  12719, -- Code_Set 16449 Order Entry Fields, Code_Value 12719  Volume Dose Unit
                  12721, -- Code_Set 16449 Order Entry Fields, Code_Value 12721  Duration
                  12731, -- Code_Set 16449 Order Entry Fields, Code_Value 12731  Stop Date/Time
                  634309 -- Code_Set 16449 Order Entry Fields, Code_Value 634309 Total Refills
                )
           ) A
      GROUP BY A.ORDER_ID, A.ACTION_SEQUENCE 
      ORDER BY A.ORDER_ID, A.ACTION_SEQUENCE
     ) B
  ON (OA.ORDER_ID = B.ORDER_ID
  AND OA.ACTION_SEQUENCE = B.ACTION_SEQUENCE)
LEFT JOIN MCHS_CUSTOM_DB.RESEARCH.ONEFL_XLT     PRR 
  ON (B.ADMINISTRATION_ROUTE_CODE = PRR.CODE_VALUE AND PRR.VS_TABLE_NAME = 'MED_ADMIN' AND PRR.VS_FIELD_NAME = 'MEDADMIN_ROUTE')
LEFT JOIN MCHS_CUSTOM_DB.RESEARCH.ONEFL_XLT      PDU
  ON (COALESCE(B.STRENGTH_DOSE_UNIT_CODE, B.VOLUME_DOSE_UNIT_CODE) = PDU.CODE_VALUE AND PDU.VS_TABLE_NAME = 'MED_ADMIN' AND PDU.VS_FIELD_NAME = 'MEDADMIN_DOSE_ADMIN_UNIT')
WHERE O.ACTIVITY_TYPE_CD = 705
  AND O.HNA_ORDER_MNEMONIC IS NOT NULL
  AND OA.ORDER_PROVIDER_ID IS NOT NULL
  AND OA.ACTION_DT_TM IS NOT NULL
  AND OA.ORDER_PROVIDER_ID NOT IN ('1', '0')
  AND LTRIM(B.DRUG_DOSE) IS NOT NULL
  AND B.REQ_START_DT_TM IS NOT NULL) MEDS
);

-- Validation:
--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ADMIN_MEDS
--WHERE OR_SURGICAL_CASE_IDENTIFIER = 'MAIN-2024-3835'
--ORDER BY MEDICATION_NAME
--        ,MEDICATION_ADMINISTRATION_TS;


--ADMINISTERED MEDICATIONS
--SELECT *
--FROM MCHS_CUSTOM_DB.SPRUCE.VW_SURGICAL_CASE_OR_ADMIN_MEDS 
--WHERE OR_SURGICAL_CASE_IDENTIFIER IN ('MAIN-2024-3835', 'MPS-2024-4761', 'MAIN-2024-7948' ,'MPS-2025-3',
--                                      'CATH-2024-704' ,'MAIN-2024-8216', 'MAIN-2024-7863' ,'MPS-2024-4510')
--ORDER BY OR_SURGICAL_CASE_IDENTIFIER
--        ,MEDICATION_ADMINISTRATION_TS
--        ,MEDICATION_NAME;