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
_,j=pcall(sjson.decode,file.read())
file.close()
end
return j
end

local function autorun(t)
local n,f
for i,v in ipairs(list())do
 n,f=v:match(t.net and "(.*).netrun"or "(.*).run")
 f=n and init(n)
 if n and f then n,f=pcall(dofile(v),f)end
end
return f
end

local function run(t)
local f,d=t.Fname,init(t.Fname)
f= t.net and f..".netrun"or f..".run"
if d and f then
 d.run=true
 f,d=pcall(dofile(f),d)
 end
 return d
end

local function save(t)
local s,o,j=init(t.Fname)
if s then
 for k,v in pairs(s)do
  s[k]=t[k]==nil and v or t[k]
 end
 o,j=pcall(sjson.encode,s)
 if o and file.open(t.Fname..".init","w")then
  file.write(j)
  file.close()
 end
end
return o
end

local function str(t)
local o,j
 if type(t)=="table"then
 o,j=pcall(sjson.encode,t)
 else
 j=tostring(t)
 end
 return j
end

return function(t)
local r
if type(t)=="table"then
if t.com=="run"then r=t.Fname and run(t) or autorun(t)end
if t.com=="list"then r=table.concat(list(),",")end
if t.com=="init"then r=init(t.Fname)end
if t.com=="save"then r=save(t)end
r=str(r)
else r=def(t) end
return r
end
