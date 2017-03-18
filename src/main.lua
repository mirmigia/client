require 'api'
require 'utils'

suit = require 'vendor/suit'

CELESTIAL_SIZE = 5

function love.load ()
  data = {
    sector = api.fetchSector(),
    ships = tableByProperty('id', api.fetchShips()),
    ui = {selected=nil},
  }
  data.sector.celestials = tableByProperty('id', data.sector.celestials)
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
      local x = cel.pos[1]
      local y = cel.pos[2]
      local r = CELESTIAL_SIZE
      if x - r/2 < mousex and mousex < x + r/2 and
        y - r/2 < mousey and mousey < y + r/2 then
          data.ui.selected = cel.id
      end
  end, data.sector.celestials)
end

function love.update (dt)
  suit.layout:reset(love.graphics.getWidth() - 200, 100)
  suit.layout:padding(5, 5)

  if data.ui.selected then
    ships = filter(function (ship)
        return ship.location == data.ui.selected
    end, data.ships)

    if #ships > 0 then
      if suit.Button("X", suit.layout:row(15, 15)).hit then
        data.ui.selected = nil
      else
        each(function (ship)
            suit.Button(ship.name, suit.layout:row(150, 30))
        end, ships)
      end
    end
  end
end

function love.draw ()
  -- Draw celestial bodies
  each(function (cel)
      local x = cel.pos[1]
      local y = cel.pos[2]
      love.graphics.setColor(255, 255, 255)
      love.graphics.circle('fill', x, y, CELESTIAL_SIZE)

      -- Find the number of ships in the sector
      local ships = filter(function (ship)
          return ship.location == cel.id
      end, data.ships)
      local shipCount = #ships
      -- Render ship count
      if shipCount > 0 then
        love.graphics.setColor(0, 255, 0)
        love.graphics.circle('line', x, y, CELESTIAL_SIZE + 1)
        love.graphics.print(shipCount, x, y + CELESTIAL_SIZE + 1)
      end

      -- Draw selected indicator
      if data.ui.selected == cel.id then
        love.graphics.setColor(255, 0, 0)
        love.graphics.circle('line', x, y, CELESTIAL_SIZE + 2)
      end
  end, data.sector.celestials)

  -- Draw UI
  suit.draw()
end
