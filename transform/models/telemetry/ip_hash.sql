with source as (
	select * from public.nutritionfacts_pingback
),

anon_ip as (
	select
		id,
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

