CREATE   PROCEDURE gold.sp_load_dim_station
AS
BEGIN
    TRUNCATE TABLE gold.dim_station;

    WITH all_stations AS (
        SELECT start_station_name AS station_name, start_lat AS latitude, start_lng AS longitude
        FROM LH_CitiBike.bronze.bronze_citibike_trips
        WHERE start_station_name IS NOT NULL AND LTRIM(RTRIM(start_station_name)) <> ''

        UNION ALL

        SELECT end_station_name AS station_name, end_lat AS latitude, end_lng AS longitude
        FROM LH_CitiBike.bronze.bronze_citibike_trips
        WHERE end_station_name IS NOT NULL AND LTRIM(RTRIM(end_station_name)) <> ''
    ),
    ranked AS (
        SELECT station_name, latitude, longitude,
               ROW_NUMBER() OVER (PARTITION BY station_name ORDER BY station_name) AS rn
        FROM all_stations
    )
    INSERT INTO gold.dim_station (station_key, station_name, latitude, longitude)
    SELECT ROW_NUMBER() OVER (ORDER BY station_name), station_name, latitude, longitude
    FROM ranked
    WHERE rn = 1;
END;