CREATE FUNCTION dbo.ConvertToDate (
    @Year INT,
    @Month INT,
    @Day INT
)
RETURNS DATE
AS
BEGIN
    DECLARE @FullDate DATE;

    
    SET @FullDate = TRY_CAST(
        CONCAT(
            @Year, '-',
            RIGHT('0' + CAST(@Month AS VARCHAR), 2), '-',
            RIGHT('0' + CAST(@Day AS VARCHAR), 2)
        ) AS DATE
    );

    RETURN @FullDate;
END;

SELECT dbo.ConvertToDate(Year, Month, Day) AS FullDate
FROM city_temperature;


