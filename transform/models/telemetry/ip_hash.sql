with source as (
	select * from nutritionfacts_pingback
),

anon_ip as (
	select
		id,
		kolibri_version,
		saved_at,
		mode,
		uptime,
		ip_id AS 'xxx.xxx.xxx.xxx',
		instance_id,
		language,
		timezone,
		installer,
		server_timestamp
	from source
)
select * from anon_ip

