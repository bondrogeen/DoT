local srv=net.createServer(net.TCP,10)
local cr={}
srv:listen(80,function(conn)
  local cn
  conn:on("receive", function(conn,payload)
   local req = dofile("web_request.lua")(payload)
   cn=req.uri.file
   cr[cn]=nil
   if req then cr[cn]=coroutine.create(dofile("web_file.lua"))end
   if req and req.method=="GET"then
    coroutine.resume(cr[cn],conn,req.uri.file,req.uri.args,req.cookie)
   elseif req and req.method=="POST"then
    coroutine.resume(cr[cn],conn,req.uri.file,req.getReq(payload),req.cookie)
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
   elseif crS=="dead"then
    conn:close()
    cr[cn]=nil
    collectgarbage()
   end
  end
 end)
end)
srv_init=true
