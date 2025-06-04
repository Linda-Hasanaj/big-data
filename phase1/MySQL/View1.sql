CREATE VIEW View1 AS
SELECT ko.Kryqytetet_O
FROM (
    SELECT k.Kryeqytetet AS Kryqytetet_O
    FROM (
        SELECT DISTINCT c.Name AS Kryeqytetet
        FROM Mondial.City c
        RIGHT JOIN Mondial.Country co ON c.Name = co.Capital
        WHERE c.Name IS NOT NULL
    ) AS k
    WHERE EXISTS (
        SELECT 1 FROM Mondial.Organization o WHERE o.City = k.Kryeqytetet
    )
) AS ko
WHERE NOT EXISTS (
    SELECT 1 FROM Mondial.located l WHERE l.City = ko.Kryqytetet_O
);

select * from View1;
