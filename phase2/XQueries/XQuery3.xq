(: Get all seas that have no islands :)
for $sea in //sea
where not(//island[@sea = $sea/@id])

(: Get the list of country codes that border this sea :)
let $countries := tokenize($sea/@country, '\s+')

(: Filter only countries that are members of NATO or EU :)
let $validCountries :=
  for $code in $countries
  let $country := //country[@car_code = $code]
  where contains($country/@memberships, "org-NATO") 
     or contains($country/@memberships, "org-EU")
  return $code

(: Ensure that all countries bordering the sea are in NATO or EU :)
where count($validCountries) = count($countries)

(: Return the result showing the sea name :)
return
  <result>
    <sea>{ $sea/name }</sea>
  </result>
