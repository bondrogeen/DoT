local function write_to_file(s,f)
 local ok, json = pcall(sjson.encode, s)
  if ok then
   if file.open(f, "w") then
    file.write(json)
    file.close()
   end
   print(json)
   return "true"
 else
  return "false"
 end
end
local function cry(l,p)
return crypto.toBase64(crypto.mask(l..p,s.token))
end
local function auth(arg)
 return cry(arg.login,arg.pass)==cry(s.auth_login,s.auth_pass) and cry(arg.login,arg.pass) or "false"
end
local function save(tab)
for k,v in pairs(tab) do
s[k] = (tonumber(v) and k ~= "auth_pass") and tonumber(v) or v
 end
 return write_to_file(s,"setting.json")
end
local function listap(t)
local d = {}
local i = {}
 for ssid,v in pairs(t) do
  local authmode, rssi, bssid, channel = v:match("([^,]+),([^,]+),([^,]+),([^,]+)")
  d.sd=ssid
  d.bd=bssid
  d.ri=rssi
  d.am=authmode
  d.cl=channel
  i[#i+1]=d
  d={}
 end
 write_to_file(i,"get_network.json")
end
return function (tab)
local r="false"
 if tab.init=="save"then tab.init=nil r=save(tab)
 elseif tab.init=="scan" then wifi.sta.getap(listap) r="true"
 elseif tab.init=="reboot" then
  tmr.create():alarm(2000, tmr.ALARM_SINGLE, function()print("reboot")node.restart()end)
 elseif tab.init=="get" then
  if (file.open("get_network.json","r")) then r = file.read('\n') file.close()end
 elseif tab.init=="auth" then r=auth(tab) end
 return r
end
