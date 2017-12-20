# web-server

Web server for NodeMCU firmware for ESP8266.   

Rather, this is the basic template for your projects with a web interface.


## Features

* GET, POST requests
* Running scripts
* Inserting Lua code into an html page ( \<? Lua return (node.chipid ())?> )
* Support for compressed .gz files
* Forms authentication
* Analysis of forms (application / x-www-form-urlencoded and application / json)

## Installation

1. The modules you need (crypto, file, gpio, net, node, sjson, tmr, uart, wifi) are optional. [Assemble the firmware] (https://nodemcu-build.com/)
2. Download all [files] (https://github.com/bondrogeen/web-server/tree/master/files) to the module.
3. Connect to the access point ** Web server ** and go to the address ** 192.168.4.1 **.
			
![Logo](https://raw.githubusercontent.com/bondrogeen/web-server/master/doc/image/web_server_login.jpg)
			
4. Enter the login (admin) and password (0000).
			
![Logo](https://raw.githubusercontent.com/bondrogeen/web-server/master/doc/image/web_server_index_page.jpg)
			
5. Go to ** Settings **.
			
![Logo](https://raw.githubusercontent.com/bondrogeen/web-server/master/doc/image/web_server_settings_page.jpg)

6. Connect to your wi-fi network

## How to work with lua scripts

Example file "template.lua"
   
...lua
   
return function (args)   
 local str=""   
 for k, v in pairs(args) do   
  str=str..k.." : "..v.."<br>"    
 end    
 return str    
end   
   
... 
   

Parameters from forms (if any) will be passed to the table ** args **.

http://IP/test.lua?key=value&name=Roman

![test.lua](https://raw.githubusercontent.com/bondrogeen/web-server/master/doc/image/test_lua_args.jpg)

