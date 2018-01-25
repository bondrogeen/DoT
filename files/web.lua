local srv = net.createServer(net.TCP)
srv:listen(80,function(conn)
 local cr
 conn:on("receive", function(conn,payload)
 local req = dofile("web_request.lua")(payload)
 if req then  cr = coroutine.create(dofile("web_file.lua")) end
  if (req and req.method == "GET") then
   if coroutine.status(cr) ~= "dead" then
   local b,res = coroutine.resume(cr, conn, req.uri.file, req.uri.args,req.cookie)
   end
  elseif req and req.method == "POST" then
    dofile("web_file.lua")(conn, req.uri.file,req.getRequestData(payload),req.cookie)
  end
  print(node.heap())
 end)
 conn:on("sent", function(conn)
 if cr then
  local crStatus = coroutine.status(cr)
  if crStatus == "suspended" then
   local status, err = coroutine.resume(cr)
   if not status then
    conn:close()
    cr = nil
    collectgarbage()
   end
  elseif crStatus == "dead" then
   conn:close()
   cr = nil
   collectgarbage()
  end
 end
end)
end)
srv_init=true
