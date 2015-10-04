
create or replace view weather_last_hour as
select 
case when round(avg(wind_speed)) < 5 then '-' else getwinddir(wind_direction) end as wind_dir,
case when round(avg(wind_speed)) < 5 then 0 else round(avg(wind_speed)) end as wind_speed,
round(avg(humidity)) as humidity,
round(avg(temperature)) as temperature,
round(avg(pressure)) as pressure,
case when round(avg(wind_speed)) < 5 then 0 else round(max(wind_speed)) end as gust

from 
weather_data 


where datetime > now() - interval '1 hour'
group by wind_direction
order by count(wind_direction) desc limit 1;




create or replace view weather_last_ten_minutes as
select 
case when round(avg(wind_speed)) < 5 then '-' else getwinddir(wind_direction) end as wind_dir,
case when round(avg(wind_speed)) < 5 then 0 else round(avg(wind_speed)) end as wind_speed,
round(avg(humidity)) as humidity,
round(avg(temperature)) as temperature,
round(avg(pressure)) as pressure,
case when round(avg(wind_speed)) < 5 then 0 else round(max(wind_speed)) end as gust

from 
weather_data 


where datetime > now() - interval '10 minutes'
group by wind_direction
order by count(wind_direction) desc limit 1;