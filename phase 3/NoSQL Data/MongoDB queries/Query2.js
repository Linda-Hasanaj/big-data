db.sea.aggregate([
  // 1. Left lookup into islandin to find islands in this sea
  {
    $lookup: {
      from: "islandin",
      localField: "Name",
      foreignField: "Sea",
      as: "islands"
    }
  },
  // 2. Filter out seas that have any islands
  {
    $match: {
      islands: { $size: 0 }
    }
  },

  // 3. Lookup geo_sea to get bordering countries
  {
    $lookup: {
      from: "geo_sea",
      localField: "Name",
      foreignField: "Sea",
      as: "borderingCountries"
    }
  },
  // 4. Filter out seas with no bordering countries
  {
    $match: {
      "borderingCountries.0": { $exists: true }
    }
  },

  // 5. For each bordering country, we need to check if the country is member of NATO or EU
  // We can $lookup into country and then ismember to check memberships

  // Unwind bordering countries to check each country separately
  {
    $unwind: "$borderingCountries"
  },

  // Lookup country document by country code (borderingCountries.Country)
  {
    $lookup: {
      from: "country",
      localField: "borderingCountries.Country",
      foreignField: "Code",
      as: "countryDoc"
    }
  },
  {
    $unwind: "$countryDoc"
  },

  // Lookup ismember for this country to get all memberships
  {
    $lookup: {
      from: "ismember",
      localField: "countryDoc.Code",
      foreignField: "Country",
      as: "memberships"
    }
  },

  // Filter memberships only to NATO or EU
  {
    $addFields: {
      isMemberNATOorEU: {
        $gt: [
          {
            $size: {
              $filter: {
                input: "$memberships",
                as: "m",
                cond: { $in: ["$$m.Organization", ["NATO", "EU"]] }
              }
            }
          },
          0
        ]
      }
    }
  },

  // 6. Group back by sea, gather all isMemberNATOorEU flags to check if all countries qualify
  {
    $group: {
      _id: "$Name",
      allMembersNATOorEU: { $min: "$isMemberNATOorEU" }  // if any false, min will be false
    }
  },

  // 7. Only keep seas where all bordering countries are NATO or EU members
  {
    $match: {
      allMembersNATOorEU: true
    }
  },

  // 8. Project output
  {
    $project: {
      _id: 0,
      Sea_Name: "$_id"
    }
  }
]);
