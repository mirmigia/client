local cpml = require 'vendor.cpml'

local Celestial = {}

Celestial.__index = Celestial

-- Default radius for a celestial body
Celestial.SIZE = 5

function Celestial.new (id, pos)
  local cel = {id=id, pos=pos}
  setmetatable(cel, Celestial)
  return cel
end

function Celestial.fromAPI (json)
  local x = json.pos[1]
  local y = json.pos[2]
  return Celestial.new(json.id, cpml.vec2.new(x, y))
end

function Celestial:update (state, dt)
end

function Celestial:draw (state)
  love.graphics.setColor(255, 255, 255)
  love.graphics.circle('fill', self.pos.x, self.pos.y, Celestial.SIZE)

  -- find the number of ships in the sector
  local ships = filter(function (ship)
      return ship.location == self.id
  end, state.ships)
  -- Render ship count
  if length(ships) > 0 then
    local x, y = cpml.vec2.unpack(self.pos)
    love.graphics.setColor(0, 255, 0)
    love.graphics.circle('line', x, y, Celestial.SIZE + 1)
    love.graphics.print(length(ships), x, y + Celestial.SIZE + 1)
  end
end

return Celestial
