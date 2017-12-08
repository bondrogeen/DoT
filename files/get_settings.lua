
return function ()
local s = {};
local f = file;
if (f.open("setting.json", "r")) then
local j = sjson;
local ok, json = pcall(j.decode,f.read('\n'))
s = ok and json or {}
s.token=crypto.toBase64(node.random(100000))
f.close();
f=nil
j=nil
else
s.wifi_id = "Web Server";
s.wifi_pass = "";
s.wifi_mode = "AP";
s.mqtt_port = ""
s.mqtt_pass = ""
s.mqtt_server = ""
s.mqtt = "off"
s.mqtt_login = ""
s.mqtt_time = ""
s.auth=true
s.auth_login="admin"
s.auth_pass="0000"
s.token=crypto.toBase64(node.random(100000))
end
   return s
end
