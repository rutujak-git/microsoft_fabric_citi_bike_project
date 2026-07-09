CREATE   PROCEDURE gold.sp_populate_dim_date
    @start_date DATE = '2026-06-01',
    @end_date DATE = '2026-06-30'
AS
BEGIN
    DROP TABLE IF EXISTS gold.dim_date;

    CREATE TABLE gold.dim_date (
        date_key DATE NOT NULL,
        year INT,
        month INT,
        month_name VARCHAR(20),
        day INT,
        quarter INT,
        day_name VARCHAR(20),
        is_weekend INT
    );

    WITH numbers AS (
        SELECT n FROM (VALUES 
            (0),(1),(2),(3),(4),(5),(6),(7),(8),(9),
            (10),(11),(12),(13),(14),(15),(16),(17),(18),(19),
            (20),(21),(22),(23),(24),(25),(26),(27),(28),(29),
            (30),(31),(32),(33),(34),(35),(36),(37),(38),(39),(40)
        ) AS t(n)
    ),
    date_seq AS (
        SELECT DATEADD(DAY, n, @start_date) AS date_value
        FROM numbers
        WHERE DATEADD(DAY, n, @start_date) <= @end_date
    )
    INSERT INTO gold.dim_date (date_key, year, month, month_name, day, quarter, day_name, is_weekend)
    SELECT
        date_value,
        YEAR(date_value),
        MONTH(date_value),
        CAST(DATENAME(MONTH, date_value) AS VARCHAR(20)),
        DAY(date_value),
        DATEPART(QUARTER, date_value),
        CAST(DATENAME(WEEKDAY, date_value) AS VARCHAR(20)),
        CASE WHEN DATEPART(WEEKDAY, date_value) IN (1,7) THEN 1 ELSE 0 END
    FROM date_seq;
END;