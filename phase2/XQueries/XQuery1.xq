for $country in //country
where string-length(normalize-space($country/@memberships)) > 0
let $capitalId := $country/@capital
let $capitalCity := //city[@id = $capitalId]
where not($capitalCity/located_at[@watertype = "river"])
let $capitalName := $capitalCity/name[1]
return
  <capital>{string($capitalName)}</capital>
