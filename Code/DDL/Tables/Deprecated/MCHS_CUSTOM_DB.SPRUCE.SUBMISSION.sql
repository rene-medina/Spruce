-- MCHS_CUSTOM_DB.SPRUCE.SUBMISSION.sql
-- RM 2025.01.31 - Creation

CREATE OR REPLACE TABLE MCHS_CUSTOM_DB.SPRUCE.SUBMISSION (
  TABLE_NAME    VARCHAR(400),
  EXPORT_FLAG   VARCHAR(1) DEFAULT 'Y',
  EXPORT_SQL    VARCHAR(16777216)
);