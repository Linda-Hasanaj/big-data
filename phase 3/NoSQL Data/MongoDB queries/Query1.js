db.geo_river.aggregate([
  // 1. Join with geo_sea collection to check if country has sea access
  {
    $lookup: {
      from: "geo_sea",
      localField: "Country",
      foreignField: "Country",
      as: "sea_access"
    }
  },
  {
    $match: {
      sea_access: { $ne: [] } // Keep only countries with sea access
    }
  },

  // 2. Join with ismember collection to exclude countries that are NATO members
  {
    $lookup: {
      from: "ismember",
      let: { code: "$Country" },
      pipeline: [
        {
          $match: {
            $expr: {
              $and: [
                { $eq: ["$Country", "$$code"] },
                { $eq: ["$Organization", "NATO"] },
                { $eq: ["$Type", "member"] }
              ]
            }
          }
        }
      ],
      as: "nato_status"
    }
  },
  {
    $match: {
      nato_status: { $eq: [] } // Keep only countries that are NOT NATO members
    }
  },

  // 3. Group by country and collect river names
  {
    $group: {
      _id: "$Country",
      rivers: { $addToSet: "$River" }
    }
  },

  // 4. Filter countries with more than 10 rivers
  {
    $match: {
      $expr: {
        $gt: [{ $size: "$rivers" }, 10]
      }
    }
  },

  // 5. Unwind river list to show each river separately and sort results
  {
    $unwind: "$rivers"
  },
  {
    $project: {
      _id: 0,
      country: "$_id",
      river: "$rivers"
    }
  },
  {
    $sort: {
      country: 1,
      river: 1
    }
  }
])
