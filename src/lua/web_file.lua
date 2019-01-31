local ex={
  txt="text/plain",
  js="application/javascript",
  json="application/json",
  ico="image/x-icon",
  lua="text/html",
  css="text/css",
  html="text/html",
  jpeg = "image/jpeg",
  jpg = "image/jpeg"
}

local function str(text)
  local status, result
  if type(text) == "table" then
    status, result = pcall(sjson.encode, text) -- table conversion to JSON
  else
    result = tostring(text)
  end
  return result
end

local op="web_control.luastyle.css.gzlogin.html"

local function executeCode (string, regular)
  for v in string:gmatch(regular) do
    local status, code = pcall(loadstring(v))
    string = string:gsub(regular, tostring( code == nil and "" or code ), 1)
  end
  return string
end

local function header(statusCode, content, isZip)
  local str = "HTTP/1.0 ".. statusCode .."\r\nServer: web-server\r\nContent-Type: "..content.."\r\n"
  if isZip then
    str = str.."Cache-Control: private, max-age=2592000\r\nContent-Encoding: gzip\r\n"
  end
  str = str.."Connection: close\r\n\r\n"
 return str
end

return function(conn, request)
  local fileName, args, cookie = request.file, request.args, request.cookie
  local gzip, fileType, line = fileName:match(".gz"), fileName:gsub(".gz",""):match("%.([%a%d]+)$")

  if not _s.auth then
    if not cookie or cookie.id ~= _s.token then
      fileName = op:match(fileType == "html" and "login.html" or fileName) or ""
    end
  end

  local fd=file.open(fileName, "r")

  if fd then
    conn:send(header("200 OK",ex[fileType] or "text/plain", gzip))
  else
    conn:send(header("404 Not Found", "text/html"))
    conn:send("<h1>Page not found</h1>")
    return
  end

  -- if (args.fget == true)  only download file

  if fileType=="html" and not args.fget then
    local buffer = ""
    repeat
      line=fd:readline()
      if line then
        if line:find("<%?lua(.-)%?>") then
          buffer = buffer..executeCode(line, "<%?lua(.-)%?>")
        else
          buffer = buffer..line
        end
      end
      if buffer:len() > 1024 or not line then
        conn:send(buffer)
        if line then
          coroutine.yield()
        end
        buffer = ""
      end
    until not line
    fd:close()
    fd=nil

  elseif fileType == "lua" and not args.fget then
    local status, result = pcall(dofile(fileName), args)
    conn:send(str(result))

  else
    local index = 0
    local all = file.open(fileName, "r")
    repeat
      all:seek("set",index)
      line = all:read(1024)
      if line then
        conn:send(line)
        index = index + 1024
        if line:len() == 1024 then
          coroutine.yield()
        end
      end
    until not line
    all:close()
  end
  all,line,gzip,fileType,buffer=nil
end

