local ex={
  txt="text/plain",
  js="application/javascript",
  ico="image/x-icon",
  lua="text/html",
  css="text/css",
  html="text/html",
  jpeg = "image/jpeg",
  jpg = "image/jpeg"
}
local op="web_control.luastyle.css.gzlogin.html"
local function executeCode (s,p)
 for v in s:gmatch(p) do
  local _,c=pcall(loadstring(v))
  s=s:gsub(p,tostring(c==nil and "" or c),1)
 end return s
end
local function header(c,t,g)
 local s="HTTP/1.0 "..c .."\r\nServer: web-server\r\nContent-Type: "..t.."\r\n"
 if g then s=s.."Cache-Control: private, max-age=2592000\r\nContent-Encoding: gzip\r\n" end
 s=s.."Connection: close\r\n\r\n"
 return s
end
return function(conn,fn,args,cookie)
 local line
 local gzip=fn:match(".gz")
 local ftype=fn:gsub(".gz",""):match("%.([%a%d]+)$")
 if s.auth=="ON"then
 if not cookie or cookie.id~=crypto.toBase64(crypto.mask(s.auth_login..s.auth_pass,s.token)) then
  if ftype=="html"then fn="login.html"end
  if not op:find(fn)then fn=""end
 end
 end
 local fd=file.open(fn,"r")
 if fd then
  conn:send(header("200 OK",ex[ftype]or"text/plain",gzip))
 else
  conn:send(header("404 Not Found","text/html"))
  conn:send("<h1>Page not found</h1>") return
 end
 if ftype=="html"then
  arg=args
  local buf=""
  repeat
   line=fd:readline()
    if line then
     if line:find("<%?lua(.-)%?>")then
      buf=buf..executeCode(line,"<%?lua(.-)%?>")
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
  fd:close() fd=nil arg=nil
  elseif ftype=="lua"then
  local k, c = pcall(dofile(fn),args)
  conn:send(type(c)=="string"and c or"error")
  else
  local d=0
  local all=file.open(fn,"r")
   repeat
    all:seek("set",d)
    line=all:read(1024)
    if line then
     conn:send(line)
     d=d+1024
     if line:len()==1024 then coroutine.yield()end
    end
   until not line
   all:close() 
   end  
  all,line,gzip,ftype,buf,data=nil
end

