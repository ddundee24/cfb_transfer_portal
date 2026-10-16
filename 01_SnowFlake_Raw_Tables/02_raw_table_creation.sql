USE ROLE sysadmin;
USE WAREHOUSE cfb_transfer_portal_wh;
USE DATABASE cfb_transfer_portal_dev;
USE SCHEMA _raw;

CREATE OR REPLACE TABLE player_portal (
    payload VARIANT,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE player_usage (
    payload VARIANT,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE player_recruiting (
    payload VARIANT,
    loaded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);