Learning Equality Data Pipeline
===============================
The Learning Equality Data Pipeline (LEDP) is a data extraction, loading and transformation system
based on the open-source Meltano project . In fact, LEDP is simply a
Meltano project, and what is said of Meltano here can be construed to apply to LEDP.

Meltano (which is sponsored by GitLab) is itself based upon a set of interrelated Python
applications: principally Singer, dbt, and Airflow. More on those technologies later.

Secrets and Configuration
-------------------------
Meltano retrieves configuration variables and secrets in several different ways, each taking
precedence over the next.

Environment variables
    * an `.env` file (used in LE Data Pipeline for local testing)
    * through environment variables present in the shell of the running meltano process (LEDP sets
      these variables in production via Python code that retrieves values from GCP Secret Manager)
    * in the Meltano project file (`meltano.yml`), within an `env` dictionary of a pipeline

Meltano Project Plugin Configuration
    * plugin-specific variables can be configured in a `config` section of the plugin (this is done
      for non-sensitive variables in LEDP)

The LEDP Database
    * LEDP does not use the Meltano database to store configuration

Default Values of Plugins
    * default values for many plugin variables are used in LEDP, though as a matter of practice,
      all of a plugin's potential parameters are listed in `meltano.yml` even if the default value
      is specified

+-----------------------------------------------+------------+---------------------------+--------------+
| Variable Name                                 |  Aspect    |          Defined          |  Sensitive   |
|                                               +------------+------------+--------------+--------------+
|                                               |            |    Dev     |   Prod       |              |
+===============================================+============+============+==============+==============+
| MELTANO_DATABASE_URI                          |   Main     |   .env     | Sec. Mgr.    |     Yes      |
+-----------------------------------------------+------------+------------+--------------+--------------+
| MELTANO_UI_FORWARDED_ALLOW_IPS                |   UI       |       meltano.yml         |     No       |
+-----------------------------------------------+------------+------------+--------------+--------------+
| TAP_POSTGRES__TELEMETRY_HOST                  |   Tap      |   .env     | Sec. Mgr.    |     Yes      |
+-----------------------------------------------+------------+---------------------------+--------------+
| TAP_POSTGRES__TELEMETRY_DBNAME                |   Tap      |   meltano.yml             |     No       |
+-----------------------------------------------+------------+------------+--------------+--------------+
| TAP_POSTGRES__TELEMETRY_USER                  |   Tap      |   .env     | Sec. Mgr.    |     Yes      |
+-----------------------------------------------+------------+------------+--------------+--------------+
| TAP_POSTGRES__TELEMETRY_PASSWORD              |   Tap      |   .env     | Sec. Mgr.    |     Yes      |
+-----------------------------------------------+------------+------------+--------------+--------------+
| TAP_POSTGRES__KDP_HOST                        |   Tap      |   .env     | Sec. Mgr.    |     Yes      |
+-----------------------------------------------+------------+---------------------------+--------------+
| TAP_POSTGRES__KDP_DBNAME                      |   Tap      |   meltano.yml             |     No       |
+-----------------------------------------------+------------+------------+--------------+--------------+
| TAP_POSTGRES__KDP_USER                        |   Tap      |   .env     | Sec. Mgr.    |     Yes      |
+-----------------------------------------------+------------+------------+--------------+--------------+
| TAP_POSTGRES__KDP_PASSWORD                    |   Tap      |   .env     | Sec. Mgr.    |     Yes      |
+-----------------------------------------------+------------+------------+--------------+--------------+


Creating base meltano project for LE
------------------------------------
::

    pyenv virtualenv 3.7.10 leq-meltano-pipelinewise

    pyenv activate leq-meltano-pipelinewise

    pip install --upgrade pip

    meltano install extractor pipelinewise-tap-postgres

    meltano add --custom loader pipelinewise-target-bigquery
    #then, for settings: dataset_id,project_id,temp_schema,default_target_schema,schema_mapping,default_target_schema_select_permission,data_flattening_max_level,batch_size,add_metadata_columns,hard_delete

    meltano config --plugin-type extractor pipelinewise-tap-postgres list

    meltano config --plugin-type extractor pipelinewise-tap-postgres set host xx.xxx.xx.xx

    meltano config --plugin-type extractor pipelinewise-tap-postgres set port xxxx

    meltano config --plugin-type extractor pipelinewise-tap-postgres set user username

    meltano config --plugin-type extractor pipelinewise-tap-postgres set user <password> #this needs to
    be put into a KV pair in `.env`

    meltano config --plugin-type extractor pipelinewise-tap-postgres set dbname dbname

    meltano config --plugin-type extractor pipelinewise-tap-postgres set filter_schemas public

    #here we select the tables we want to extract
    meltano select pipelinewise-tap-postgres nutritionfacts_birthyearstats "*"

    #use a sequential column (usually a PK)
    meltano config pipelinewise-tap-postgres set _metadata nutritionfacts_birthyearstats
    replication-method INCREMENTAL

    #identify said sequential column
    meltano config pipelinewise-tap-postgres set _metadata nutritionfacts_birthyearstats replication-key
    id

    meltano config pipelinewise-tap-postgres set _metadata nutritionfacts_channelstatistics
    replication-method INCREMENTAL

    meltano config pipelinewise-tap-postgres set _metadata nutritionfacts_channelstatistics
    replication-key id

    meltano config pipelinewise-target-bigquery set dataset_id telemetry-meltano

    meltano config pipelinewise-target-bigquery set project_id telemetry-187418

    meltano add transformer dbt

    meltano ui

Connect to `localhost:5000` with browser

Docker
======

::

    docker run -d -p 5000:5000 <image>`

Notes
=====
pipelinewise-target-bigquery won't work on 3.8.x or higher, only 3.7.x (used 3.7.10 for install)

