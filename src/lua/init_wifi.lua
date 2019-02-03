return function (t)
  local cfg={}
  cfg.ssid = t.ssid
  _mode = t.mode
  cfg.pwd = string.len(t.pwd)>=8 and t.pwd or nil
  if(t.mode ~= 0) then
    wifi.setmode(t.mode)
    wifi.nullmodesleep(false)
    if t.mode == 1 then
      wifi.sta.config(cfg)
    else
      wifi.ap.config(cfg)
    end
    wifi.eventmon.register(t.mode == 1 and 0 or 5,function(T)
      dofile('web.lua')
      local mytimer = tmr.create()
      mytimer:register(5000, tmr.ALARM_SINGLE,function (t)
          print(_s.mode == 1 and wifi.sta.getip() or wifi.ap.getip())
          t:unregister()
      end)
      mytimer:start()
    end)
  else
    print("Wireless err")
  end
end
