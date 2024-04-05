-- Step 1: Union all datasets
CREATE TABLE all_data AS(
SELECT * 
FROM trip_data.april_2021
UNION ALL
SELECT *
FROM trip_data.may_2021
UNION ALL
SELECT *
FROM trip_data.june_2021
UNION ALL
SELECT *
FROM trip_data.july_2021
UNION ALL
SELECT *
FROM trip_data.august_2021
UNION ALL
SELECT *
FROM trip_data.september_2021
UNION ALL
SELECT *
FROM trip_data.october_2021
UNION ALL
SELECT * 
FROM trip_data.november_2021
UNION ALL
SELECT *
FROM trip_data.december_2021
UNION ALL
SELECT *
FROM trip_data.january_2022
UNION ALL
SELECT *
FROM trip_data.febuary_2022
UNION ALL
SELECT *
FROM trip_data.march_2022);

-- Step 2: Remove null values
DELETE FROM trip_data.all_data 
WHERE 
    ride_id IS NULL OR
    rideable_type IS NULL OR
    started_at IS NULL OR
    ended_at IS NULL OR
    start_station_name IS NULL OR
    start_station_id IS NULL OR
    end_station_name IS NULL OR
    end_station_id IS NULL OR
    start_lat IS NULL OR
    start_lng IS NULL OR
    end_lat IS NULL OR
    end_lng IS NULL OR
    member_casual IS NULL

ALTER TABLE trip_data.all_data
ADD COLUMN day_of_week INT;

UPDATE trip_data.all_data
SET day_of_week = DAYOFWEEK(started_at);

CREATE TABLE day_of_week_numeric AS
SELECT DISTINCT
       day_of_week,
       CASE
           WHEN day_of_week = 1 THEN 'Sunday'
           WHEN day_of_week = 2 THEN 'Monday'
           WHEN day_of_week = 3 THEN 'Tuesday'
           WHEN day_of_week = 4 THEN 'Wednesday'
           WHEN day_of_week = 5 THEN 'Thursday'
           WHEN day_of_week = 6 THEN 'Friday'
           WHEN day_of_week = 7 THEN 'Saturday'
           ELSE NULL
       END AS day_name
FROM trip_data.all_data;

-- Exploratory Data Analysis (EDA):
-- 1. Summary Statistics:

SELECT 
    COUNT(*) AS total_rows,
    MIN(started_at) AS min_start_time,
    MAX(ended_at) AS max_end_time,
    AVG(TIMESTAMPDIFF(SECOND, started_at, ended_at)) AS avg_duration_seconds,
    MIN(start_lat) AS min_start_lat,
    MAX(start_lat) AS max_start_lat,
    MIN(start_lng) AS min_start_lng,
    MAX(start_lng) AS max_start_lng,
    MIN(end_lat) AS min_end_lat,
    MAX(end_lat) AS max_end_lat,
    MIN(end_lng) AS min_end_lng,
    MAX(end_lng) AS max_end_lng
FROM trip_data.all_data;

-- 2. Number of Rides by Rideable Type:

SELECT rideable_type, COUNT(*) AS num_rides
FROM trip_data.all_data
GROUP BY rideable_type;

-- 3. Number of Rides by Member Type:

SELECT member_casual, COUNT(*) AS num_rides
FROM trip_data.all_data
GROUP BY member_casual;

-- 4. Average Ride Duration by Member Type:

SELECT member_casual, AVG(TIMESTAMPDIFF(SECOND, started_at, ended_at)) AS avg_duration_seconds
FROM trip_data.all_data
GROUP BY member_casual;

-- Advanced Analysis:
-- 1. Popular Start Stations:

SELECT start_station_name, COUNT(*) AS num_rides
FROM trip_data.all_data
GROUP BY start_station_name
ORDER BY num_rides DESC
LIMIT 10;

-- 2. Popular End Stations:

SELECT end_station_name, COUNT(*) AS num_rides
FROM trip_data.all_data
GROUP BY end_station_name
ORDER BY num_rides DESC
LIMIT 10;

-- 3. Hourly Distribution of Rides:

SELECT HOUR(started_at) AS hour_of_day, COUNT(*) AS num_rides
FROM trip_data.all_data
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- vizualizations

-- Bar Chart of Ride Count by Rideable Type:

SELECT 
    rideable_type, 
    COUNT(*) AS num_rides
FROM 
    trip_data.all_data
GROUP BY 
    rideable_type;
    
-- Pie Chart of Ride Count by Member Type:

SELECT 
    member_casual, 
    COUNT(*) AS num_rides
FROM 
   trip_data.all_data
GROUP BY 
    member_casual;
    
--     Hourly Distribution of Rides:

SELECT 
    HOUR(started_at) AS hour_of_day, 
    COUNT(*) AS num_rides
FROM 
    trip_data.all_data
GROUP BY 
    hour_of_day
ORDER BY 
    hour_of_day;



