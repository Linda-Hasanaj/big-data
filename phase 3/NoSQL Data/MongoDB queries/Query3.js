db.ismember.aggregate([
  {
    $match: {
      Organization: "NATO"
    }
  },
  {
    $lookup: {
      from: "geo_sea",
      localField: "Country",
      foreignField: "Country",
      as: "seas"
    }
  },
  {
    $lookup: {
      from: "geo_lake",
      localField: "Country",
      foreignField: "Country",
      as: "lakes"
    }
  },
  {
    $unwind: "$seas"
  },
  {
    $unwind: "$lakes"
  },
  {
    $project: {
      Country1: "$Country",
      Sea: "$seas.Sea",
      Lake: "$lakes.Lake"
    }
  },
  {
    $lookup: {
      from: "geo_sea",
      localField: "Sea",
      foreignField: "Sea",
      as: "seaMatches"
    }
  },
  {
    $lookup: {
      from: "geo_lake",
      localField: "Lake",
      foreignField: "Lake",
      as: "lakeMatches"
    }
  },
  {
    $unwind: "$seaMatches"
  },
  {
    $unwind: "$lakeMatches"
  },
  {
    $match: {
      $expr: {
        $and: [
          { $eq: ["$seaMatches.Country", "$lakeMatches.Country"] },
          { $ne: ["$Country1", "$seaMatches.Country"] },
          { $lt: ["$Country1", "$seaMatches.Country"] }
        ]
      }
    }
  },
  {
    $lookup: {
      from: "ismember",
      let: { c: "$seaMatches.Country" },
      pipeline: [
        {
          $match: {
            $expr: {
              $and: [
                { $eq: ["$Organization", "NATO"] },
                { $eq: ["$Country", "$$c"] }
              ]
            }
          }
        }
      ],
      as: "memberCheck"
    }
  },
  {
    $match: {
      "memberCheck.0": { $exists: true }
    }
  },
  // Deduplicate combinations of Country1, Country2, Sea, Lake
  {
    $group: {
      _id: {
        Country1: "$Country1",
        Country2: "$seaMatches.Country",
        Sea: "$Sea",
        Lake: "$Lake"
      }
    }
  },
  {
    $project: {
      _id: 0,
      Country1: "$_id.Country1",
      Country2: "$_id.Country2",
      Sea: "$_id.Sea",
      Lake: "$_id.Lake"
    }
  }
])
