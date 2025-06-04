use Mondial;

WITH Kryeqytetet AS (
    SELECT DISTINCT c.[Name] AS Kryeqytetet
    FROM Mondial.dbo.City c
    RIGHT JOIN Mondial.dbo.Country co ON c.[Name] = co.Capital
    WHERE c.[Name] IS NOT NULL
),
Kryeqytetet_Organizat AS (
    SELECT k.Kryeqytetet AS Kryqytetet_O
    FROM Kryeqytetet k
    WHERE EXISTS (
        SELECT 1 FROM Mondial.dbo.Organization o WHERE o.City = k.Kryeqytetet
    )
)
SELECT ko.Kryqytetet_O
FROM Kryeqytetet_Organizat ko
WHERE NOT EXISTS (
    SELECT 1 FROM Mondial.dbo.located l WHERE l.City = ko.Kryqytetet_O
);
