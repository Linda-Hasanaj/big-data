use Mondial;

SELECT s.Name AS Sea_Name
FROM Sea s
WHERE 
    NOT EXISTS (SELECT * FROM islandIn WHERE Sea = s.Name)
    
    AND NOT EXISTS (
        SELECT *
        FROM geo_Sea gs
        JOIN Country c ON gs.Country = c.Code
        WHERE gs.Sea = s.Name
        AND NOT EXISTS (
            SELECT 1 
            FROM isMember im 
            WHERE im.Country = c.Code 
            AND im.Organization IN ('NATO', 'EU')
        )
    )
    
    AND EXISTS (SELECT * FROM geo_Sea WHERE Sea = s.Name);
