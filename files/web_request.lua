local function h(x) return string.char(tonumber(x,16))end
local function u_d(i)return i:gsub("%+"," "):gsub("%%(%x%x)",h)
end
local function parse(b,r,c)
 local d={}
 if b==nil or b=="" then return end
 for kv in b:gmatch(r)do
  local k,v=kv:match("(.*)=(.*)")
  d[k]=not c and u_d(v) or v
 end
 return d
end
local function getReq(payload)
 local requestData
 return function()
  if requestData then return requestData else
   local mimeType=payload:match("Content%-Type: ([%w/-]+)")
   local bodyStart=payload:find("\r\n\r\n",1,true)
   local body=payload:sub(bodyStart,#payload)
   payload=nil
   collectgarbage()
   if mimeType=="application/json"then
   local ok, j = pcall(sjson.decode,body)
   requestData = ok and j or {}
   elseif mimeType=="application/x-www-form-urlencoded" then
    requestData=parse(body,"%s*&?([^=]+=[^&]*)")
   else
    requestData={}
   end
   return requestData
  end
 end
end
local function pU(u)
 local r={}
 if u==nil then return r end
 if u=="/" then u="/index.html"end
 r.file=u:match("?")and u:match("/(.*)%?")or u:match("/(.*)")
 r.args=parse(u:match("%?([^=]+=[^;]*)"),"([^&]+)") or {}
 return r
end
return function (req)
   local e=req:find("\r\n",1,true)
   if not e then return nil end
   local line = req:sub(1, e - 1)
   local r={}
   _,_,r.method, r.req=line:find("^([A-Z]+) (.-) HTTP/[1-9]+.[0-9]+$")
   local _, _, cookie = req:find("%cCookie: (%C*)")
   if cookie then r.cookie=parse(cookie,";?%s?([^=]+=[^;]*)",true)end
   if not (r.method and r.req)then return nil end
   r.uri=pU(r.req)
   r.getReq=getReq(req)
   return r
end
