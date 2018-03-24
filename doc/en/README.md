# web-server

Web server for NodeMCU firmware for ESP8266.   

Rather, this is the basic template for your projects with a web interface.


## Features

* GET, POST requests
* Parser forms (application / x-www-form-urlencoded and application / json)
* Ability to download additional. files (js, css, ico, txt, jpg).
* Minimum code size in memory, in standby mode.
* Ability to include LUA code in the HTML page. ( \<?lua return(node.chipid()) ?>)
* Run LUA scripts and send them parameters using POST and GET requests.
* Minimal authentication.
* Ability to download compressed files (.gz).

## Structure

### Initialization:
* init.lua - initialization of settings and wi-fi.
* init_settings.lua - getting settings, as well as keeping the default settings.
* init_wifi.lua - connection to the wifi network.

### The server consists of four main scripts:
* web.lua - is the web server itself.
* web_request.lua - analysis of responses from the client.
* web_file.lua - transfer files, run scripts and load html pages with lua code.
* web_control.lua - authentication, saving parameters, obtaining a list of access points.

### Files:
* favicon.ico - icon.
* index.html - home page.
* settings.html - settings page.
* login.html - page authentication.
* script_settings.js.gz - js script (compressed) for processing and sending forms.
* style.css.gz - style file (compressed).

## Installation

1. The modules you need (crypto, file, gpio, net, node, sjson, tmr, uart, wifi). [Building the firmware](https://nodemcu-build.com/)
2. Download all [files](https://github.com/bondrogeen/web-server/tree/master/files) to the module.
3. Connect to the access point **Web server** and go to the address **192.168.4.1**.
			
![Logo](https://raw.githubusercontent.com/bondrogeen/web-server/master/doc/image/web_server_login.jpg)
			
4. Enter the login (admin) and password (0000).
			
![Logo](https://raw.githubusercontent.com/bondrogeen/web-server/master/doc/image/web_server_index_page.jpg)
			
5. Go to **Settings**.
			
![Logo](https://raw.githubusercontent.com/bondrogeen/web-server/master/doc/image/web_server_settings_page.jpg)

6. Connect to your wi-fi network

## How to work with lua scripts

Example file "test.lua"
   
```lua
   
Local function arg_to_str(val)    
  local str=""    
  for k, v in pairs(val) do     
    str=str..k.." : "..v.."     
  end   
  return str    
end    
   
return function (args)    
 return arg_to_str(args)    
end      
   
``` 
   

Parameters from forms (if any) will be passed to the table ** args **.

http://IP/test.lua?key=value&name=Roman

![test.lua](https://raw.githubusercontent.com/bondrogeen/web-server/master/doc/image/test_lua_args.jpg)

## Restrictions.
The server processes the files in different ways, so for files with the extension .html the reading from the file is progressive, this is done to simplify the processing of the built-in Lua code, there is no limitation on the file size. With files with the .lua extension, the size of the sent data is no more than 4KB.
All other files are transferred byte by byte (1024 bytes at a time), there are also no restrictions on the file size. The server can not receive data more than 1.4KB (data + header). While there was no such need.)))

## Changelog

### 0.0.7 (2018-03-22)
* (bondrogeen) Added update of web server files
* (bondrogeen) Fixed bug web_file.lua
### 0.0.6 (2018-03-12)
* (bondrogeen) Fix authentication
### 0.0.5 (2018-03-04)
* (bondrogeen) Added a test firmware, added NodeMCU Flasher
### 0.0.4 (2018-03-03)
* (nedoskiv) Fix memory leak.
* (bondrogeen) Changed the appearance, minor fixes css.
### 0.0.3 (2018-01-25)
* (bondrogeen) Rename web_server.lua to web.lua
### 0.0.2 (2018-01-13)
* (bondrogeen) Changed executeCode()
### 0.0.1 (2017-12-08)
* (bondrogeen) init.