require 'vendor.fun'
local suit = require 'vendor.suit'

local UI = {}

function UI:new(o)
  setmetatable(o, self)
  self.__index = self
  return o
end

-- Set the selected celestial body
function UI:select (celestial)
  self.selected = celestial.id
end


local function showShips (ui, ships)
  local ships = filter(function (ship)
      return ship.location == ui.selected
  end, ships)

  if #ships > 0 then
    if suit.Button("X", suit.layout:row(15, 15)).hit then
      ui.selected = nil
    else
      each(function (ship)
        suit.Button(ship.name, suit.layout:row(150, 30))
      end, ships)
    end
  end
end

function UI:update (state)
  suit.layout:reset(self.x, self.y)
  suit.layout:padding(5, 5)

  if self.selected then
    showShips(self, state.ships)
  end
end

function UI:draw ()
  suit.draw()
end

return UI
