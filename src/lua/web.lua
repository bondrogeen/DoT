local srv=net.createServer(net.TCP,10)
local cr = {}

srv:listen(80,function(conn)
    local cn
    conn:on("receive", function(conn, payload)
        local req = dofile("web_request.lua")(payload)
        if req then
          cn = req.file
          cr[cn] = nil
          cr[cn] = coroutine.create(dofile("web_file.lua"))
          coroutine.resume(cr[cn], conn, req)
        end
        print(node.heap())
    end)
    conn:on("sent",function(conn)
        if cr[cn]then
          local crS=coroutine.status(cr[cn])
          if crS=="suspended"then
            local status=coroutine.resume(cr[cn])
            if not status then
              conn:close()
              cr[cn]=nil
              collectgarbage()
            end
          elseif crS=="dead" then
            conn:close()
            cr[cn]=nil
            collectgarbage()
          end
        end
    end)
end)

srv_init=true
