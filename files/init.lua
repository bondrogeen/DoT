gpio.mode(1, gpio.INPUT)
s=dofile("init_settings.lua")(gpio.read(1))
dofile("init_wifi.lua")(s.wifi_mode,s.wifi_id,s.wifi_pass,function(con)
print(con)
if(not srv_init)then dofile('web_server.lua')end
end)

