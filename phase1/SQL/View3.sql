CREATE VIEW View3 AS
SELECT s.Name AS Sea_Name
FROM Sea s
WHERE 
    
    s.Name NOT IN (SELECT DISTINCT Sea FROM islandIn WHERE Sea IS NOT NULL)
    
    
    AND s.Name IN (
        SELECT gs.Sea
        FROM geo_Sea gs
        JOIN (
            SELECT DISTINCT Country 
            FROM isMember 
            WHERE Organization IN ('NATO', 'EU')
        ) AS valid_countries ON gs.Country = valid_countries.Country
        GROUP BY gs.Sea
        HAVING COUNT(*) = (
            SELECT COUNT(*) 
            FROM geo_Sea gs2 
            WHERE gs2.Sea = gs.Sea
        )
    );

	
