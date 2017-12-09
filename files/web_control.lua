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
local function auth(arg)
local r
 if crypto.toBase64(crypto.mask(arg.login..arg.pass,s.token))==crypto.toBase64(crypto.mask(s.auth_login..s.auth_pass,s.token))then
  r=crypto.toBase64(crypto.mask(arg.login..arg.pass,s.token))
 else
  r="false"
 end
return r
end
local function save(tab)
for k,v in pairs(tab) do
  if (tonumber(v) and k ~= "auth_pass")then
   s[k]=tonumber(v);
  else
   s[k]=v
  end
 end
 return write_to_file(s,"setting.json")
end
local function listap(t)
local d = {}
local i = {}
 for ssid,v in pairs(t) do
  local authmode, rssi, bssid, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]+)")
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
 elseif tab.init=="get" then
  if (file.open("get_network.json","r")) then r = file.read('\n') file.close()end
 elseif tab.init=="auth" then r=auth(tab) end
 return r
end