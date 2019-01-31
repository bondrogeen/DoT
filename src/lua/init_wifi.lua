return function (t)
  local cfg={}
  cfg.ssid=t.ssid
  cfg.pwd = string.len(t.pwd)>=8 and t.pwd or nil
  if(t.mode and t.mode ~= 0) then
    print("mode: "..t.mode)
    wifi.setmode(t.mode)
    wifi.nullmodesleep(false)
    if t.mode == 1 then
      wifi.sta.config(cfg)
    else
      wifi.ap.config(cfg)
    end

    wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED,function(T)
      if(not srv_init)then dofile('web.lua')end
      local mytimer = tmr.create()
      mytimer:register(3000, tmr.ALARM_SINGLE,function (t)
          print(t.mode == 1 and wifi.sta.getip() or wifi.ap.getip())
          t:unregister()
      end)
      mytimer:start()
    end)
  else
    print("Wireless err")
  end
end
