local setting_default = {
  ssid = "DoT-"..string.format("%x",node.chipid()*256):sub(0,6):upper(),
  pwd = "",
  auth = false,
  mode = 3,
  login = "admin",
  pass = "0000"
}

local function save(fileName, data)
  local status, result = pcall(sjson.encode, data)
  if result and file.open(fileName, "w") then
    file.write(result)
    file.close()
  end
end

local function init(n)
  local state, result
  if file.open(n, "r") then
    state, result = pcall(sjson.decode,file.read())
    file.close()
  end
  return result
end

local function def(value)
  local setting, default = init("setting.json")
  print((setting and value == 1))
  print(setting )
  print(value)
  default = (setting and value == 1) and setting or setting_default
  if not settings then save("setting.json", default) end
  default.token = tostring(node.random(100000))
  return default
end

local function run(t)
  local n, f
  for k, v in pairs(file.list())do
    if k:match(t.ext and "(.*)%."..t.ext or t.name.."%.[rn][ue][nt]$")then
      n = init(k:match("(.*)%.")..".init")
      if k and n then
        n.run = t.name and true or n.run
        n,f = pcall(dofile(k), n)end
      end
    end
  return f
end

local function del(t)
  if type(t)=="table" then
    for i,v in pairs(t)do
      file.remove(v)
    end
  else
    file.remove(t)
  end
  return t
end

local function resave(t)
  local tab = init(t.Fname)
  if tab then
    for key, value in pairs(tab)do
      print(tab[key])
      print("==")
      print(t[key])
      tab[key] = t[key] == nil and value or t[key]
    end
    save(t.Fname, tab)
    return true
  end
  return false
end

return function(t)
  local r
  if type(t) == "table" then
    if t.run then r = run(t.run) end
    if t.list then r = file.list() end
    if t.init then r = init(t.init) end
    if t.save then r = resave(t.save) end
    if t.del then r = del(t.del) end
    if t.def then r = def(t.def) end
  end
  return r
end
