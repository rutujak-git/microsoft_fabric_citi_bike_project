CREATE PROCEDURE gold.sp_load_fact_trip
AS
BEGIN
    MERGE gold.fact_trip AS target
    USING (
        SELECT
            b.ride_id,
            b.rideable_type,
            s1.station_key AS start_station_key,
            s2.station_key AS end_station_key,
            rt.rider_type_key,
            b.start_date AS trip_date,
            DATEPART(HOUR, b.started_at) AS start_hour,
            b.trip_duration_minutes,
            gold.fn_classify_trip_duration(b.trip_duration_minutes) AS duration_category
        FROM LH_CitiBike.bronze.bronze_citibike_trips b
        LEFT JOIN gold.dim_station s1 ON b.start_station_name = s1.station_name
        LEFT JOIN gold.dim_station s2 ON b.end_station_name = s2.station_name
        LEFT JOIN gold.dim_rider_type rt ON b.member_casual = rt.rider_type
    ) AS source
    ON target.ride_id = source.ride_id
    WHEN MATCHED THEN
        UPDATE SET
            rideable_type = source.rideable_type,
            start_station_key = source.start_station_key,
            end_station_key = source.end_station_key,
            rider_type_key = source.rider_type_key,
            trip_date = source.trip_date,
            start_hour = source.start_hour,
            trip_duration_minutes = source.trip_duration_minutes,
            duration_category = source.duration_category
    WHEN NOT MATCHED THEN
        INSERT (ride_id, rideable_type, start_station_key, end_station_key, rider_type_key, trip_date, start_hour, trip_duration_minutes, duration_category)
        VALUES (source.ride_id, source.rideable_type, source.start_station_key, source.end_station_key, source.rider_type_key, source.trip_date, source.start_hour, source.trip_duration_minutes, source.duration_category);
END;