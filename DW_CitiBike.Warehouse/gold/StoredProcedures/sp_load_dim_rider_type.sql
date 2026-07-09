CREATE PROCEDURE gold.sp_load_dim_rider_type
AS 
BEGIN
    TRUNCATE TABLE gold.dim_rider_type;

    INSERT INTO gold.dim_rider_type (rider_type_key, rider_type)
    SELECT ROW_NUMBER() OVER (ORDER BY member_casual), member_casual
    FROM (
        SELECT DISTINCT member_casual
        FROM LH_CitiBike.bronze.bronze_citibike_trips
        WHERE member_casual IS NOT NULL
    ) AS distinct_types;
END;