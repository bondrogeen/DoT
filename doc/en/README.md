# DoT

Template for your projects with a web interface.

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



## Changelog

### 0.1.3 (2018-04-09)
* (bondrogeen) fixed the problem with the digital password wi-fi.
### 0.1.0 (2018-03-26)
* (bondrogeen) Significantly changed the markup classes (before .xs-12 now .s12 ). Changed the appearance. 
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