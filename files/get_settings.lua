
return function (val)
local s = {}
local def
if file.open("setting.json", "r") then
def = val==1
else
def=nil
end
if def then
file.open("setting.json", "r")
local ok, json = pcall(sjson.decode,file.read('\n'))
s = ok and json or {}
s.token=crypto.toBase64(node.random(100000))
file.close()
else
s.wifi_id = "Web Server";
s.wifi_pass = "";
s.wifi_mode = "AP";
s.mqtt_port = ""
s.mqtt_pass = ""
s.mqtt_server = ""
s.mqtt = "OFF"
s.mqtt_login = ""
s.mqtt_time = ""
s.auth="ON"
s.auth_login="admin"
s.auth_pass="0000"
s.token=crypto.toBase64(node.random(100000))
end
   return s
end
