###Creating a meltano configuration:

```
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

...

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

...

meltano config pipelinewise-target-bigquery set dataset_id telemetry-meltano

meltano config pipelinewise-target-bigquery set project_id telemetry-187418

meltano add transformer dbt

Notes:

pipelinewise-target-bigquery won't work on 3.8.x or higher, only 3.7.x (used 3.7.10 for install)

```
