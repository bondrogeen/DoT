local function hex_to_char(x) return string.char(tonumber(x,16))end
local function uri_decode(input)return input:gsub("%+"," "):gsub("%%(%x%x)",hex_to_char)
end
local function parse(body,reg,dec)
 local data={}
 if body==nil or body=="" then return r end
 for kv in body:gmatch(reg)do
  local key,value=kv:match("(%w*)=(.*)")
  data[key]=not dec and uri_decode(value) or value
 end
 return data
end
local function getRequestData(payload)
 local requestData
 return function()
  if requestData then return requestData else 
   local mimeType=payload:match("Content%-Type: ([%w/-]+)")
   local bodyStart=payload:find("\r\n\r\n",1,true)
   local body=payload:sub(bodyStart,#payload) 
   payload=nil
   collectgarbage()
   if mimeType=="application/json"then
   local ok, json = pcall(sjson.decode,body)
   requestData = ok and json or {}
   elseif mimeType=="application/x-www-form-urlencoded" then
    requestData=parse(body,"%s*&?([^=]+=[^&]*)")
   else        
    requestData={}
   end   
   return requestData
  end
 end
end
local function parseUri(uri)
 local r={}
 if uri==nil then return r end
 if uri=="/" then uri="/index.html"end
 r.file=uri:match("?")and uri:match("/(.*)%?")or uri:match("/(.*)")
 r.args=parse(uri:match("%?([^=]+=[^;]*)"),"([^&]+)") or {}
 return r
end
return function (request)
   local e=request:find("\r\n",1,true)
   if not e then return nil end
   local line = request:sub(1, e - 1)
   local r={}
   _,_,r.method, r.request=line:find("^([A-Z]+) (.-) HTTP/[1-9]+.[0-9]+$")
   local _, _, cookie = request:find("%cCookie: (%C*)")
   if cookie then r.cookie=parse(cookie,";?%s?([^=]+=[^;]*)",true)end
   if not (r.method and r.request)then return nil end
   r.uri=parseUri(r.request)
   r.getRequestData=getRequestData(request)
   return r
end
