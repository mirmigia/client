require 'vendor.fun' ()
local API = require 'api'
local Celestial = require 'celestial'
local UI  = require 'ui'
local Ship = require 'ship'

CELESTIAL_SIZE = 5

function love.load ()
  ui = UI:new {
    x = love.graphics.getWidth() - 200,
    y = 100,
  }
  local sector = API.fetchSector()
  -- Convert celestials JSON to objects
  local celestials = map(Celestial.fromAPI, sector.celestials)
  local ships = map(Ship.fromAPI, API.fetchShips())
  state = {
    celestials = celestials,
    ships = ships,
  }
end

function love.keypressed (key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.mousepressed (mousex, mousey)
  each(function (cel)
      -- TODO: Optimise, possibly by making each celestial listen
      -- TODO: for mouse events
      local x = cel.pos.x
      local y = cel.pos.y
      local r = Celestial.SIZE
      if x - r/2 < mousex and mousex < x + r/2 and
        y - r/2 < mousey and mousey < y + r/2 then
          ui:select(cel)
      end
  end, state.celestials)
end

function love.update (dt)
  -- TODO: only run in development
  require('vendor.lurker').update()

  each(function (cel)
      cel:update(state, dt)
  end, state.celestials)

  ui:update(state)
end

function love.draw ()
  -- Draw celestial bodies
  each(function (cel)
      cel:draw(state)
      -- Draw selected indicator
      if ui.selected == cel.id then
        local x = cel.pos.x
        local y = cel.pos.y
        love.graphics.setColor(255, 0, 0)
        love.graphics.circle('line', x, y, Celestial.SIZE + 2)
      end
  end, state.celestials)

  ui:draw()
end
