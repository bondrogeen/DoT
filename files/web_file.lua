local extmap={
  txt="text/plain",
  js="application/javascript",
  ico="image/x-icon",
  lua="text/html",
  css="text/css",
  html="text/html",
  jpeg = "image/jpeg",
  jpg = "image/jpeg"
}
local function executeCode (str,pattern)
 local _,_,c=str:find(pattern)
 local luaFunc, err=loadstring(c)
 if luaFunc ~=nil then
  return str:gsub(pattern,luaFunc())
 else
  return ("Syntax error: "..err)
 end
end
local function header(c,t,g)
 local s="HTTP/1.0 "..c .."\r\nServer: httpserver\r\nContent-Type: "..t.."\r\n"
 if g then s=s.."Cache-Control: private, max-age=2592000\r\nContent-Encoding: gzip\r\n" end
 s=s.."Connection: close\r\n\r\n"
 return s
end
return function(conn,filename,args,cookie)
 local line
 local gzip=filename:match(".gz")
 local ftype=filename:gsub(".gz",""):match("%.([%a%d]+)$") 
 if not cookie or cookie.id~=crypto.toBase64(crypto.mask(s.auth_login..s.auth_pass,s.token)) then
  if ftype=="html"then filename="login.html"end
 end
 local fd=file.open(filename,"r")
 if fd then
  conn:send(header("200 OK",extmap[ftype or "txt"],gzip))
 else
  conn:send(header("404 Not Found","text/html"))
  conn:send("<h1>Page not found</h1>") return
 end
 if ftype=="html"then
  local buf=""
  repeat
   line=fd:readline()
    if line then
     if line:find("<%?lua(.+)%?>")then
      buf=buf..executeCode(line,"<%?lua(.+)%?>")
     else
      buf=buf..line
     end
    end
    if buf:len()>1024  or not line then
     conn:send(buf)
     if line then coroutine.yield()end
     buf=""
   end
  until not line
  fd:close() fd=nil
  elseif ftype=="lua"then
  local k, c = pcall(dofile(filename),args)
  conn:send(type(c)=="string"and c or"error")
  else
  local data=0
  local all=file.open(filename,"r")
   repeat
    all:seek("set",data)
    line=all:read(1024)
    if line then
     conn:send(line)
     data=data+1024
     coroutine.yield()
     collectgarbage()
    end
   until not string.len(line)
   all:close() 
   end  
  all,line,gzip,ftype,buf,data=nil
end

