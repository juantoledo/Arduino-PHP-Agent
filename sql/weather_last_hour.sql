
create or replace view weather_last_hour as
select 
getwinddir(wind_direction) as wind_dir,
round(avg(wind_speed)) as wind_speed,
round(avg(humidity)) as humidity,
round(avg(temperature)) as temperature,
round(avg(pressure)) as pressure
from 
weather_data 


where datetime > now() - interval '1 hour'
group by wind_direction
order by count(wind_direction) desc limit 1;


