gpio.mode(1, gpio.INPUT)
s=dofile("init_settings.lua")(gpio.read(1))
dofile("init_wifi.lua")(s.wifi_mode,s.wifi_id,s.wifi_pass,function(c)
 print(c)
 if(not srv_init)then dofile('web.lua')end
 dofile("init_settings.lua")({run=true,net=true})
end)
dofile("init_settings.lua")({run=true})
