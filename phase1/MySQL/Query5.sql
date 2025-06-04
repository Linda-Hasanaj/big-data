use Mondial;

SELECT 
       m.Name AS Mountain_Name,
       MAX(m.Height) AS Height
FROM mountain m
JOIN geo_mountain gm ON m.Name = gm.Mountain
WHERE gm.Country IN ('AL', 'BIH', 'BG', 'HR', 'GR', 'XK', 'MNE', 'MK', 'RO', 'SI')
GROUP BY m.Name
ORDER BY Height DESC
LIMIT 5;



