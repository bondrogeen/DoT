gpio.mode(1, gpio.INPUT)
local on=gpio.read(1)
print(on)
s={}
s=dofile("get_settings.lua")(on)
local cfg={}
cfg.ssid=s.wifi_id
if string.len(s.wifi_pass)>=8 then cfg.pwd=s.wifi_pass end
if s.wifi_mode=="AP"then
print("Access point")
wifi.setmode(wifi.STATIONAP)
wifi.ap.config(cfg)
wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED,function(T)
print("Connect client")
print(wifi.ap.getip())
if(not srv_init)then dofile('web_server.lua')end
end)
elseif s.wifi_mode=="ST"then
print("Wireless client")
wifi.setmode(wifi.STATION)
wifi.nullmodesleep(false)
wifi.sta.config(cfg)
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED,function(T)
print("Connect access point")
if(not srv_init)then dofile('web_server.lua')end
tmr.create(0):alarm(5000,tmr.ALARM_SINGLE,function()print(wifi.sta.getip())end)
end)
end
