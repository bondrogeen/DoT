local function hex(x)
  return string.char(tonumber(x,16))
end

local function decode(i)
  return i:gsub("%+"," "):gsub("%%(%x%x)",hex)
end

local function parse(string, regular, c)
  local data = {}
  if string and string ~= "" then
    for kv in string:gmatch(regular) do
      local key, value = kv:match("(.*)=(.*)")
      data[key] = not c and decode(value) or value
    end
  end
  return data
end

local function getReq(payload)
  local requestData = {}
  local mimeType = payload:match("Content%-Type: ([%w/-]+)")
  local body = payload:sub( payload:find("\r\n\r\n", 1, true), #payload)
  print(body)
  payload=nil
  collectgarbage()
  if mimeType == "application/json" then
    local ok, j = pcall(sjson.decode, body)
    requestData = ok and j or {}
  elseif mimeType == "application/x-www-form-urlencoded" then
    requestData = parse(body, "%s*&?([^=]+=[^&]*)")
  end
  return requestData
end

return function (req)
  local r = {}
  r.method, r.req = req:match( "(.-)\r\n" ):match("^([A-Z]+) (.-) HTTP/[1-9]+.[0-9]+$")
  if r.method and r.req then
    r.cookie = parse(req:match("%cCookie: (%C*)"), ";?%s?([^=]+=[^;]*)", true)
    r.file = r.req:match("?") and r.req:match("/(.*)%?") or r.req:match("/(.*)")
    r.file = r.file == "" and "index.html" or r.file
    r.args = r.method == "GET" and parse(r.req:match("%?([^=]+=[^;]*)"), "([^&]+)") or getReq(req)
  else
    r=nil
  end
  return r
end
