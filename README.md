# DoT
 
Шаблон для ваших проектов с веб интерфейсом.



[English](https://github.com/bondrogeen/web-server/blob/master/doc/en/README.md)



## Установка

1. Необходимые модули ("crypto", "file", "gpio", "net", "node", "sjson", "tmr", "uart", "wifi") далее на ваше усмотрение. [Собрать прошивку](https://nodemcu-build.com/)
2. Загрузить все [файлы](https://github.com/bondrogeen/web-server/tree/master/files) в модуль.
3. Подключиться к точке доступа **Web server** и перейти по адресу **192.168.4.1**.
	
[YouTube](https://www.youtube.com/watch?v=ZlZd6Yuta10)
      
![Logo](doc/image/web_server_login.jpg)
			
4. Вводим логин (admin) и пароль (0000).
			
5. Переходим в **Настройки**.
			
![Logo](doc/image/web_server_settings_page.jpg)

6. Подключаемся к вашей wi-fi сети 

![Logo](doc/image/web_server_index_page.jpg)

## Changelog

### 0.1.8 (2018-06-01)
* (bondrogeen) Переводит table в JSON от lua скриптов для GET или POST запросов. 
### 0.1.6 (2018-05-02)
* (bondrogeen) Изменил пин для настроек по умолчанию. Tеперь это GPIO2 (4).
### 0.1.5 (2018-04-14)
* (bondrogeen) Мелкие исправления.
### 0.1.4 (2018-04-11)
* (bondrogeen) Изменил построение настроек.
### 0.1.3 (2018-04-09)
* (bondrogeen) Исправил проблему с цифровым паролем wi-fi.
### 0.1.0 (2018-03-26)
* (bondrogeen) Существенно изменили классы разметки (было .xs-12 сейчас .s12 ). Изменил внешний вид.
### 0.0.7 (2018-03-22)
* (bondrogeen) Добавил обновление файлов веб сервера
* (bondrogeen) Исправил баг web_file.lua
### 0.0.6 (2018-03-12)
* (bondrogeen) Исправил баг в аутентификации
### 0.0.5 (2018-03-04)
* (bondrogeen) Добавлено тестовое прошивку, добавлено NodeMCU Flasher.
### 0.0.4 (2018-03-03)
* (nedoskiv) Исправил утечку памяти.
* (bondrogeen) Изменен внешний вид, мелкие исправления css.
### 0.0.3 (2018-01-25)
* (bondrogeen) Переименовал web_server.lua в web.lua
### 0.0.2 (2018-01-13)
* (bondrogeen) Изменил executeCode()
### 0.0.1 (2017-12-08)
* (bondrogeen) init.



