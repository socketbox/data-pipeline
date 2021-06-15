with source as (
	select * from public.logger_contentsessionlog
),

hash_id as (
	select
		id AS ,
		kolibri_version,
		saved_at,
		mode,
		uptime,
		'xxx.xxx.xxx.xxx' AS ip_id,
		instance_id,
		language,
		timezone,
		installer,
		server_timestamp
	from source
)
select * from anon_ip

