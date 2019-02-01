local setting_default = {
  ssid = "DoT-"..string.format("%x",node.chipid()*256):sub(0,6):upper(),
  pwd = "",
  mode = 3,
  login = "admin",
  pass = "0000"
}

local function init(n)
  local state, result
  if file.open(n,"r") then
    state, result = pcall(sjson.decode,file.read())
    file.close()
  end
  return result
end

local function def(value)
  local setting = init("setting.json")
  setting = (setting and value==1) and setting or setting_default
  setting.token = tostring(node.random(100000))
  return setting
end

local function run(t)
  local n,f
  for k,v in pairs(file.list())do
    if k:match(t.ext and "(.*)%."..t.ext or t.name.."%.[rn][ue][nt]$")then
      n=init(k:match("(.*)%.")..".init")
      if k and n then
        n.run=t.name and true or n.run
        n,f=pcall(dofile(k),n)end
      end
    end
  return f
end

local function del(t)
  if type(t)=="table" then
    for i,v in pairs(t)do
      print(v)file.remove(v)
    end
  else
    file.remove(t)
  end
  return t
end

local function save(t)
  local s,o,j=init(t.Fname)
  if s then
    for k,v in pairs(s)do
      s[k]=t[k]==nil and v or t[k]
    end
    o,j=pcall(sjson.encode,s)
    print(j)
    if o and file.open(t.Fname,"w")then
      file.write(j)
      file.close()
    end
  end
  return o
end

return function(t)
  local r
  if type(t)=="table"then
    if t.run then r=run(t.run)end
    if t.list then r=file.list()end
    if t.init then r=init(t.init)end
    if t.save then r=save(t.save)end
    if t.del then r=del(t.del)end
    if t.def then r=def(t)end
  end
  return r
end
