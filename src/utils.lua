-- Returns a string representation for value `v` for use when displaying
-- to the user the correct representation for a value. E.g. a string
-- should be displayed as `"Some string"` and not `Some String`
local function toRepresentation (v)
  if type(v) == 'string' then
    return '"' .. v .. '"'
  else
    return tostring(v)
  end
end

-- Print a human-readable representation of table `t` `level`
-- represents the current indentation level, defaults to 0.
function printTable (t, level)
  level = level or 1

  io.write("{\n")
  for k, v in pairs(t) do
    io.write(string.rep("\t", level))
    -- if its a number then its usually an index
    if type(k) ~= 'number' then
      io.write(k .. " = ")
    end

    if type(v) == 'table' then
      printTable(v, level + 1)
    else
      io.write(toRepresentation(v) .. ",")
    end
    io.write("\n")
  end
  io.write(string.rep("\t", level - 1))
  io.write("}\n")
end
