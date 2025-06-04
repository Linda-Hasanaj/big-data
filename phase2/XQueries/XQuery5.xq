let $balkanCodes := ("AL", "GR", "MK", "BG", "BA", "HR", "ME", "XK", "RO", "SI")

let $balkanMountains :=
  for $mountain in //mountain
  let $codes := tokenize($mountain/@country, '\s+')
  where some $c in $codes satisfies $c = $balkanCodes
  order by number($mountain/elevation) descending
  return $mountain

return
  for $m in $balkanMountains[position() <= 5]
  return
    <mountain>
      <name>{ $m/name/text() }</name>
      <elevation>{ $m/elevation/text() }</elevation>
      <country>{ $m/@country }</country>
    </mountain>
