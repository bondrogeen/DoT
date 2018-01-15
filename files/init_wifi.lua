return function (m,i,p,c)
local cfg={}
cfg.ssid=i
cfg.pwd = p:len()>=8 and p or nil
if m=="AP"then
print("Access point")
wifi.setmode(wifi.STATIONAP)
wifi.ap.config(cfg)
wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED,function(T)
c("Connect client: "..wifi.ap.getip())
end)
elseif m=="ST"then
print("Wireless client")
wifi.setmode(wifi.STATION)
wifi.nullmodesleep(false)
wifi.sta.config(cfg)
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED,function(T)
tmr.create(0):alarm(3000,tmr.ALARM_SINGLE,function()
c("Connect access point\nIP:"..wifi.sta.getip())
end)
end)
end
end
