USE ROLE sysadmin;

CREATE OR REPLACE WAREHOUSE cfb_transfer_portal_wh
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

USE WAREHOUSE cfb_transfer_portal_wh;

CREATE OR REPlACE DATABASE cfb_transfer_portal_dev;

USE DATABASE cfb_transfer_portal_dev;

CREATE OR REPLACE SCHEMA _raw;
CREATE OR REPLACE SCHEMA _analytics;

