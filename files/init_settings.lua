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
auth="ON",
auth_login="admin",
auth_pass="0000"
}
s.token=crypto.toBase64(node.random(100000))
end
 return s
end

local function str(t)
local o,j
if type(t)=="table"then
o,j=pcall(sjson.encode,t)
else j=tostring(t)end
return j
end

local function init(n)
local o,j
if file.open(n,"r") then
o,j=pcall(sjson.decode,file.read())
file.close()
end
return j
end

local function run(t)
local n,f
for k,v in pairs(file.list())do
if k:match(t.ext and "(.*)%."..t.ext or t.name.."%.[rn][ue][nt]$")then
n=init(k:match("(.*)%.")..".init")
n.run=t.name and true or n.run
n,f=pcall(dofile(k),n)
end
end
return f
end

local function del(t)
if type(t)=="table" then
for i,v in pairs(t)do print(v)file.remove(v)end
else file.remove(t)end
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
r=str(r)
else r=def(t) end
return r
end
