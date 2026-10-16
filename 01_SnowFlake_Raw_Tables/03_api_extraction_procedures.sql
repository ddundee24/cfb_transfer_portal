USE ROLE sysadmin;
USE WAREHOUSE cfb_transfer_portal_wh;
USE DATABASE cfb_transfer_portal_dev;
USE SCHEMA _raw;

-- Create stored procedure to grab player usage data from cfbd

CREATE OR REPLACE PROCEDURE fetch_player_usage()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.10'
  PACKAGES = ('requests', 'snowflake-snowpark-python')
  EXTERNAL_ACCESS_INTEGRATIONS = (cfbd_api_integration)
  SECRETS = ('api_key' = cfb_transfer_portal_dev._raw.api_key)
  HANDLER = 'run'
AS
$$
import requests
import json
import _snowflake
import snowflake.snowpark as snowpark

def run(session: snowpark.Session) -> str:
    api_key = _snowflake.get_generic_secret_string('api_key')
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Accept": "application/json"
    }

    session.sql("TRUNCATE TABLE CFB_TRANSFER_PORTAL_DEV._RAW.PLAYER_USAGE").collect()

    total = 0
    for season in range(2021, 2027):
        url = f"https://api.collegefootballdata.com/player/usage?year={season}"
        response = requests.get(url, headers=headers)

        if response.status_code != 200:
            return f"Failed on {season}: {response.status_code} - {response.text}"

        data = response.json()
        if not data:
            continue

        rows = []
        for row in data:
            rows.append([json.dumps(row)])

        df = session.create_dataframe(rows, schema=["payload_str"])
        df.select(
            snowpark.functions.parse_json(snowpark.functions.col("payload_str")).alias("PAYLOAD"),
            snowpark.functions.current_timestamp().alias("LOADED_AT")
        ).write.mode("append").save_as_table(
            "CFB_TRANSFER_PORTAL_DEV._RAW.PLAYER_USAGE"
        )
        total += len(data)

    return f"Successfully inserted {total} records for seasons 2021-2026."
$$;

-- Create stored procedure to grab player portal data from cfbd

CREATE OR REPLACE PROCEDURE fetch_player_portal()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.10'
  PACKAGES = ('requests', 'snowflake-snowpark-python')
  EXTERNAL_ACCESS_INTEGRATIONS = (cfbd_api_integration)
  SECRETS = ('api_key' = cfb_transfer_portal_dev._raw.api_key)
  HANDLER = 'run'
AS
$$
import requests
import json
import _snowflake
import snowflake.snowpark as snowpark

def run(session: snowpark.Session) -> str:
    api_key = _snowflake.get_generic_secret_string('api_key')
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Accept": "application/json"
    }

    session.sql("TRUNCATE TABLE CFB_TRANSFER_PORTAL_DEV._RAW.PLAYER_PORTAL").collect()

    total = 0
    for season in range(2021, 2027):
        url = f"https://api.collegefootballdata.com/player/portal?year={season}"
        response = requests.get(url, headers=headers)

        if response.status_code != 200:
            return f"Failed on {season}: {response.status_code} - {response.text}"

        data = response.json()
        if not data:
            continue

        rows = []
        for row in data:
            rows.append([json.dumps(row)])

        df = session.create_dataframe(rows, schema=["payload_str"])
        df.select(
            snowpark.functions.parse_json(snowpark.functions.col("payload_str")).alias("PAYLOAD"),
            snowpark.functions.current_timestamp().alias("LOADED_AT")
        ).write.mode("append").save_as_table(
            "CFB_TRANSFER_PORTAL_DEV._RAW.PLAYER_PORTAL"
        )
        total += len(data)

    return f"Successfully inserted {total} records for seasons 2021-2026."
$$;

-- Create stored procedure to grab player high schoole recruiting data from cfbd

CREATE OR REPLACE PROCEDURE fetch_player_recruiting()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.10'
  PACKAGES = ('requests', 'snowflake-snowpark-python')
  EXTERNAL_ACCESS_INTEGRATIONS = (cfbd_api_integration)
  SECRETS = ('api_key' = cfb_transfer_portal_dev._raw.api_key)
  HANDLER = 'run'
AS
$$
import requests
import json
import _snowflake
import snowflake.snowpark as snowpark

def run(session: snowpark.Session) -> str:
    api_key = _snowflake.get_generic_secret_string('api_key')
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Accept": "application/json"
    }

    session.sql("TRUNCATE TABLE CFB_TRANSFER_PORTAL_DEV._RAW.PLAYER_RECRUITING").collect()

    total = 0
    for season in range(2021, 2027):
        url = f"https://api.collegefootballdata.com/recruiting/players?year={season}"
        response = requests.get(url, headers=headers)

        if response.status_code != 200:
            return f"Failed on {season}: {response.status_code} - {response.text}"

        data = response.json()
        if not data:
            continue

        rows = []
        for row in data:
            rows.append([json.dumps(row)])

        df = session.create_dataframe(rows, schema=["payload_str"])
        df.select(
            snowpark.functions.parse_json(snowpark.functions.col("payload_str")).alias("PAYLOAD"),
            snowpark.functions.current_timestamp().alias("LOADED_AT")
        ).write.mode("append").save_as_table(
            "CFB_TRANSFER_PORTAL_DEV._RAW.PLAYER_RECRUITING"
        )
        total += len(data)

    return f"Successfully inserted {total} records for seasons 2021-2026."
$$;

-- Cal stored procedures to load into raw tables
CALL fetch_player_usage();
CALL fetch_player_portal();
CALL fetch_player_recruiting();