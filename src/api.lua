local API = {}

-- Fetch sector data from API
function API.fetchSector ()
  return {
    id = "ACD234",
    dimensions = {32, 32},
    -- Positions in light years from top left
    celestials = {
      -- TODO: Generate these
      {id="CEL222", pos={100, 100}},
      {id="PLA594", pos={23, 560}},
      {id="ASD666", pos={123, 145}},
      {id="YUP553", pos={444, 323}},
      {id="POS928", pos={340, 580}},
      {id="DOC916", pos={542, 230}},
      {id="CEL303", pos={15, 544}},
      {id="REP001", pos={156, 329}},
      {id="CEL693", pos={482, 444}},
      {id="FET213", pos={572, 120}},
      {id="PEE998", pos={322, 323}},
      {id="TUP430", pos={555, 328}},
    }
  }
end

-- Fetch all (current) player ships from the API
function API.fetchShips ()
  return {
    {
      id = "TBP001",
      name = "Black Pearl",
      type = "Battleship",
      range = 10, -- distance in light years
      location = "CEL222", -- current celestial body
    },
    {
      id = "",
      name = "HMS Interceptor",
      type = "Battleship",
      range = 8, -- distance in light years
      location = "CEL222", -- current celestial body
    },
    {
      id = "TBC845",
      name = "Black Barnacle",
      type = "Scout",
      range = 7, -- distance in light years
      location = "DOC916", -- current celestial body
    },
  }
end

return API
