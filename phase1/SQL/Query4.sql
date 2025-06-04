use Mondial;

SELECT DISTINCT m1.Country AS Country1, m2.Country AS Country2, m1.Sea, l1.Lake
FROM isMember AS im1
JOIN Organization AS org ON im1.Organization = org.Abbreviation
JOIN geo_Sea AS m1 ON im1.Country = m1.Country
JOIN geo_Sea AS m2 ON m1.Sea = m2.Sea
JOIN geo_Lake AS l1 ON im1.Country = l1.Country
JOIN geo_Lake AS l2 ON l1.Lake = l2.Lake
JOIN isMember AS im2 ON m2.Country = im2.Country AND l2.Country = im2.Country
WHERE org.Name = 'North Atlantic Treaty Organization'
  AND im1.Country < im2.Country



