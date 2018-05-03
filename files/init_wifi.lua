return function (m,i,p)
local cfg={}
cfg.ssid=i
cfg.pwd = string.len(p)>=8 and p or nil
if m=="AP"then
print("Access point")
wifi.setmode(wifi.STATIONAP)
wifi.ap.config(cfg)
wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED,function(T)
if(not srv_init)then dofile('web.lua')end
print("IP: "..wifi.ap.getip())
end)
elseif m=="ST"then
print("Wireless client")
wifi.setmode(wifi.STATION)
wifi.nullmodesleep(false)
wifi.sta.config(cfg)
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED,function(T)
if(not srv_init)then dofile('web.lua')end
dofile("init_settings.lua")({run={ext="net"}})
local mytimer = tmr.create()
mytimer:register(3000, tmr.ALARM_SINGLE,function (t) print("IP:"..tostring(wifi.sta.getip())) t:unregister()end)
mytimer:start()
end)
end
end
