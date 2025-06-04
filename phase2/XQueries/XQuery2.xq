let $seaCountries := distinct-values(
  for $sea in //sea
  return tokenize($sea/@country, '\s+')
)

(: Build map of countries that meet all 3 conditions :)
let $qualifiedMap :=
  for $country in //country
  let $code := $country/@car_code
  where $code = $seaCountries
    and not(contains($country/@memberships, "org-NATO"))
  let $countryRivers :=
    distinct-values(
      for $river in //river
      where some $loc in $river/located satisfies $loc/@country = $code
      return $river/@id
    )
  where count($countryRivers) > 10
  return <qualified code="{$code}">{
    for $id in $countryRivers
    return <riverId>{ $id }</riverId>
  }</qualified>

(: Now use $qualifiedMap :)
return
  for $q in $qualifiedMap
  let $code := $q/@code
  let $riverIds := $q/riverId/text()
  for $river in //river
  where $river/@id = $riverIds
    and (
      some $loc in $river/located satisfies $loc/@country = $code
    )
  return
    <result>
      <country>{ $code }</country>
      <river>{ $river/name[1] }</river>
    </result>

