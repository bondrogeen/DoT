local function def(v)
local s
if file.open("setting.json", "r") and v==1 then
local ok, j = pcall(sjson.decode,file.read('\n'))
s = ok and j or {}
s.token=crypto.toBase64(node.random(100000))
file.close()
else
s={
wifi_id = "Web Server",
wifi_pass = "",
wifi_mode = "AP",
mqtt_port = "",
mqtt_pass = "",
mqtt_host = "",
mqtt = "OFF",
mqtt_login = "",
mqtt_time = "",
auth="ON",
auth_login="admin",
auth_pass="0000"
}
s.token=crypto.toBase64(node.random(100000))
end
 return s
end

local function list()
local t={}
for k,v in pairs(file.list())do
t[#t+1]=k
end
return t
end

local function init(n)
local j
if file.open(n..".init","r") then
_,j=pcall(sjson.decode,file.read('\n'))
end
return j
end

local function run()
for i,v in ipairs(list())do
local n,t=v:match("(.*).run")
t=n and init(n)
if n and t then n,t=pcall(dofile(v),t)
return t
end
end
end

local function save(t)
local o,j=pcall(sjson.encode,t)
if o and file.open(t.save,"w")then
 file.write(j)
 file.close()
end
return o
end

return function(t)
local r
if type(t)=="table" then
if t.run then r=run()end
if t.list then r=table.concat(list(),",")end
if t.init then r=init(t.init)end
if t.save then r=save(t)end
else r=def(t) end
return r
end
