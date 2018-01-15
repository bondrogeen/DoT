return function (v,back)
print(v)
local s
if file.open("setting.json", "r") and v==1 then
local ok, json = pcall(sjson.decode,file.read('\n'))
s = ok and json or {}
s.token=crypto.toBase64(node.random(100000))
file.close()
else
s={
wifi_id = "Web Server",
wifi_pass = "",
wifi_mode = "AP",
mqtt_port = "",
mqtt_pass = "",
mqtt_server = "",
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
