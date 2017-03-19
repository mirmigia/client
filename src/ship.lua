local Ship = {}

Ship.__index = Ship

function Ship.new (o)
  -- TODO: validate params
  setmetatable(o, Ship)
  return o
end

Ship.fromAPI = Ship.new

return Ship
