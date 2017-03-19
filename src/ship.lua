local Ship = {}

Ship.__index = Ship

function Ship.new (o)
  -- TODO: validate params
  setmetatable(o, Ship)
  return o
end

Ship.from_api = Ship.new

return Ship
