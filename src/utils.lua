function reduce (f, init, seq)
  local acc = init
  for _, v in pairs(seq) do
    acc = f(acc, v)
  end
  return acc
end

function filter (f, seq)
  ret = {}
  for _, v in pairs(seq) do
    if f(v) then
      table.insert(ret, v)
    end
  end
  return ret
end

function map (f, seq)
  return reduce(function (acc, v)
      return table.insert(acc, f(v))
  end, {}, seq)
end

function each(f, seq)
  for _, v in pairs(seq) do
    f(v)
  end
end

function tableByProperty (property, seq)
  return reduce(function (acc, v)
      local key = v[property]
      acc[key] = v
      return acc
  end, {}, seq)
end
