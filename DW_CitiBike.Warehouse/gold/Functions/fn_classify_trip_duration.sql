CREATE FUNCTION gold.fn_classify_trip_duration (@minutes FLOAT)
RETURNS VARCHAR(10)
AS
    BEGIN
        RETURN (
        CASE
        WHEN @minutes IS NULL THEN 'unknown'
            WHEN @minutes < 10 THEN 'short'
            WHEN @minutes < 30 THEN 'medium'
            ELSE 'long'
        END
        );
END;