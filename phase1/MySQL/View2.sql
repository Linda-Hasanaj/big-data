CREATE VIEW View2 AS
SELECT DISTINCT gr.country, gr.river
FROM geo_river gr
WHERE gr.country IN (
    -- shtetet qe kane dalje ne deti
    SELECT DISTINCT c.Code
    FROM country c
    JOIN geo_sea gs ON c.Code = gs.Country
)
AND gr.country NOT IN (
    -- shtetet qe jane anetare te NATO
    SELECT im.Country
    FROM isMember im
    WHERE im.Organization = 'NATO' AND im.Type = 'member'
)
AND gr.country IN (
    -- shtetet me 10 e me shume lumenj
    SELECT country
    FROM geo_river
    GROUP BY country
    HAVING COUNT(DISTINCT river) > 10
);

select * from View2;