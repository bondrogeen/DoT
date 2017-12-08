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
  local ok, json = pcall(sjson.encode, i)
  if ok then
   if file.open("get_network.json", "w") then
    file.write(json)
    file.close()
   end   
 end
end
return function (tab)
if tab.val == "start"then
 wifi.sta.getap(listap) 
 return '{"start":"ok"}'
elseif tab.val == "get"then
 if (file.open("get_network.json", "r")) then
  local r = file.read('\n')
 file.close();
 return r
 else
 return '{"get":"no_file"}'
 end
end
end