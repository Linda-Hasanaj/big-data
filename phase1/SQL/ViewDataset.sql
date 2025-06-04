CREATE VIEW Temperature AS
SELECT 
    c.Capital AS Capital,
    ROUND(AVG(t.AvgTemperature), 2) AS AvgAprilTempFahrenheit
FROM 
    city_temperature t
JOIN 
    Mondial.dbo.Country c ON t.City = c.Capital AND t.Country = c.Name
JOIN 
    Mondial.dbo.isMember m ON c.Code = m.Country
WHERE 
    m.Organization = 'NATO'
    AND t.Month = 4
    AND t.Year = 1995
GROUP BY 
    c.Capital;

	select * from Temperature;



	
