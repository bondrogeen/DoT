local buf=""
local function get(t, cb)
 local first
 local status
 local con=net.createConnection(net.TCP, 0)
 con:on("receive", function(con, data)
 if not first then
  status = data:match("HTTP/%d%.%d (.-) .*\r\n")=="200"
  data = data:match("\r\n\r\n(.*)")
  first = true
  if t.save and status then file.open(t.file,"w+")end
 end
 if not status then cb("Not found "..t.file) return end
 if t.save then
  file.write(data)
  cb("load... "..t.file)
 else
  cb(data)
 end
 payload = nil
 collectgarbage()
 end)
 con:on("disconnection", function(con)file.close()cb(false)end)
 con:on("connection", function(con)
  con:send("GET /"..t.path..t.file.." HTTP/1.0\r\n"..
  "Host: "..t.host.."\r\n"..
  "Connection: close\r\n"..
  "Accept-Charset: utf-8\r\n"..
  "Accept-Encoding: \r\n"..
  "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"..
  "Accept: */*\r\n\r\n")
 end)
  con:connect(t.port,t.host)
end

local function temp(d)
 if d then
  if file.open("temp_get.txt","a+")then
   file.write(d)
   file.close()
  end
 end
end

local function upload(t,cb)
 local tab = t.file
 local next
 local function sf(t)
  get(t, function(d)
   if d then buf=buf..d..'\n' else next() end
  end)
 end
 next = function()
  t.save=true
  if #tab ~= 0 then
   t.file=tab[#tab]
   sf(t)
   tab[#tab]=nil
  else
   cb(buf.."close ")
   cb(false)
  end
 end
 next()
end

return function (t, cb)
 local c
 local function r(d)
  if cb then cb(d) else temp(d) print(d)end
 end
 file.remove("temp_get.txt")
 if t.init =="upload" then
  get(t, function(f)
   if f then
    local ok, j = pcall(sjson.decode,f)
    if ok then t.file=j upload(t,r) else r(false) end
   end
  end)
  c=true
 else
  get(t,r)
  c=true
 end
 return tostring(c)
end
