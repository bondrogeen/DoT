
local function saveToFile(fileName,data)
  local r = file.open(fileName, "w") and data
  if r then
     file.write(data)
     file.close()
  end
  return r
end

local function auth(arg)
  local access = (arg.login == _s.login and arg.pass == _s.pass)
  return access and _s.token
end

local function listap(list)
  status, result = pcall(sjson.encode, list)
  print(result)
  saveToFile("get_network.json", result)
end

local function reboot()
  tmr.create():alarm(2000, tmr.ALARM_SINGLE, function()
    print("reboot")
    node.restart()
  end)
  return true
end

return function (t)
  local r
  if t.scan then
    r = true
    wifi.sta.getap(listap)
  end
  if t.auth then r = auth(t.auth)end
  if t.reboot then r = reboot()end
  return r
end
