-- The number of cycles before a table reference is considered cyclical
local N_TOO_MANY_CYCLES = 100

-- Returns a string representation for value `v` for use when displaying
-- to the user the correct representation for a value. E.g. a string
-- should be displayed as `"Some string"` and not `Some String`
local function torepr (v)
  if type(v) == 'string' then
    return string.format('%q', v)
  else
    return tostring(v)
  end
end

-- Print a human-readable representation of table `t` `level`
-- represents the current indentation level, defaults to 0.
--
-- Throws an error if a cyclical reference is detected.
function print_table (t, level)
  level = level or 1

  if level > N_TOO_MANY_CYCLES then
    error([[table contains too many nested levels, possibly indicating
      a cyclical reference]])
  end

  io.write("{\n")
  for k, v in pairs(t) do
    io.write(string.rep("\t", level))
    -- if its a number then its usually an index
    if type(k) ~= 'number' then
      io.write(k .. " = ")
    end

    if type(v) == 'table' then
      print_table(v, level + 1)
    else
      io.write(torepr(v) .. ",")
    end
    io.write("\n")
  end
  io.write(string.rep("\t", level - 1))
  io.write("}\n")
end
