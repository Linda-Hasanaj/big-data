declare function local:ordered-pair($a as xs:string, $b as xs:string) as xs:string {
  if ($a le $b) then concat($a, '|', $b)
  else concat($b, '|', $a)
};

let $natoCodes := distinct-values(
  for $c in //country
  where contains($c/@memberships, "org-NATO")
  return $c/@car_code
)

(: Create set of pairs for seas :)
let $seaPairs := distinct-values(
  for $sea in //sea
  let $codes := tokenize($sea/@country, '\s+')
  let $nato := for $c in $codes where $c = $natoCodes return $c
  where count($nato) > 1
  for $i in 1 to count($nato) - 1
  for $j in $i + 1 to count($nato)
  return local:ordered-pair($nato[$i], $nato[$j])
)

(: Create set of pairs for lakes :)
let $lakePairs := distinct-values(
  for $lake in //lake
  let $codes := tokenize($lake/@country, '\s+')
  let $nato := for $c in $codes where $c = $natoCodes return $c
  where count($nato) > 1
  for $i in 1 to count($nato) - 1
  for $j in $i + 1 to count($nato)
  return local:ordered-pair($nato[$i], $nato[$j])
)

(: Only keep pairs that appear in both sets (sea + lake) :)
let $strictMatches := distinct-values(
  for $p in $seaPairs
  where $p = $lakePairs
  return $p
)

return
  for $pair in $strictMatches
  let $codes := tokenize($pair, '\|')
  let $name1 := //country[@car_code = $codes[1]]/name[1]
  let $name2 := //country[@car_code = $codes[2]]/name[1]
  return
    <pair>
      <country1>{ $name1 }</country1>
      <country2>{ $name2 }</country2>
    </pair>
