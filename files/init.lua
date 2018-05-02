gpio.mode(4, gpio.INPUT)
s=dofile("init_settings.lua")(gpio.read(4))
node.setcpufreq(node.CPU160MHZ)
dofile("init_wifi.lua")(s.wifi_mode,s.wifi_id,s.wifi_pass)
local mytimer = tmr.create()
mytimer:register(5000, tmr.ALARM_SINGLE,
function (t) print("Start")dofile("init_settings.lua")({run={ext="run"}})t:unregister()end)
mytimer:start()
