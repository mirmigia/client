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
  self.selected_ship = nil
end

-- De-selects any currently selected UI elements
function UI:deselect ()
  self.selected = nil
  self.selected_ship = nil
end

-- Returns true if there are any items currently selected
function UI:has_selected ()
  return self.selected or self.selected_ship
end

function UI:show_ships (ships)
  local ships = filter(function (ship)
      return ship.location == self.selected
  end, ships)

  if length(ships) > 0 then
    each(function (ship)
      if suit.Button(ship.name, suit.layout:row(150, 30)).hit then
        self.selected_ship = ship
      end
    end, ships)
  end
end

function UI:show_ship_details (ship)
  -- FIXME: These should be sorted as defined
  local t = {
    id = "ID",
    name = "Name",
    type = "Type",
    range = "Range",
  }
  for prop, label in pairs(t) do
    suit.Label(label .. ": " .. ship[prop], suit.layout:row(150, 15))
  end
end

function UI:update (state)
  suit.layout:reset(self.x, self.y)
  suit.layout:padding(5, 5)

  if self:has_selected() then
    if suit.Button("X", suit.layout:row(15, 15)).hit then
      self:deselect()
    end
  end

  if self.selected_ship then
    self:show_ship_details(self.selected_ship)
    -- go back to list view. TODO: allign with X button
    if suit.Button("<", suit.layout:row(15, 15)).hit then
      self.selected_ship = nil
    end
  elseif self.selected then
    self:show_ships(state.ships)
  end
end

function UI:draw ()
  suit.draw()
end

return UI
