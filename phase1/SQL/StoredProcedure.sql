CREATE PROCEDURE dbo.Procedura
    @SeaName NVARCHAR(100),
    @LakeName NVARCHAR(100),
    @Country1 NVARCHAR(100)
AS
BEGIN
    SELECT v.Country1, v.Country2, v.Sea, v.Lake
    FROM View4 v
    WHERE (@SeaName IS NULL OR v.Sea LIKE '%' + @SeaName + '%')
      AND (@LakeName IS NULL OR v.Lake LIKE '%' + @LakeName + '%')
      AND (@Country1 IS NULL OR v.Country1 LIKE '%' + @Country1 + '%')
    ORDER BY v.Country1, v.Country2;
END;

EXEC Procedura 'Arctic Ocean', 'Lake Erie', 'CDN';




