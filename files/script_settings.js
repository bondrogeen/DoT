function send(page, date, callback) {
var req = new XMLHttpRequest();
req.open("POST", page, true);
req.setRequestHeader('Content-Type', 'application/json');
req.addEventListener("load", function () {
if (req.status < 400) {
callback(req.responseText);
} else {
callback(req.status);
}
});
req.send(JSON.stringify(date));
}
function name(val){
  return document.getElementsByName(val)[0].value;
}
function input(val) {
  var arr = ["mqtt_time", "mqtt_server", "mqtt_port", "mqtt_login", "mqtt_pass"];
  for (var i = 0; i < arr.length; i++) {
document.getElementsByName(arr[i])[0].disabled = val;
}
}
function check(val) {
var inp = document.getElementsByName(val);
for (var i = 0; i < inp.length; i++) {
if (inp[i].type == "radio" && inp[i].checked) {
return inp[i].value;
    }
  }
}
function check_sel(val) {
var s = document.getElementById(val);
for (var i = 0; i < s.options.length; i++) {
if (s.options[i].selected) {
return s.options[i].value;
}
}
}

function save() {
var date = "";
var arr = ["mqtt_pass", "mqtt_login", "mqtt_port", "mqtt_server", "mqtt_time", "wifi_id", "wifi_pass", "wifi_mode", "mqtt"];
arr.forEach(function (item, i, arr) {
if (item == "mqtt") {
date = date + "&" + item + "=" + check(item);
} else if (item == "wifi_mode") {
date = date + "&" + item + "=" + check_sel(item);
} else {
date = date + "&" + item + "=" + name(item);
}
});
if (check_sel("wifi_mode") == "off") {
var w = confirm("Внимание!!! Wi-fi будет отключен, Вы точно этого хотите?");
if (!w) {
return
}
}
document.getElementById('save').innerHTML = "Сохранение";
    send("save.lua", date, function (res) {
      document.getElementById('save').innerHTML = "Сохранено";
      setTimeout(function () { document.getElementById('save').innerHTML = "Сохранить"; }, 3000);
      var reboot = confirm("Reboot device?");
      if (reboot) {
        send("send.lua", "com=reboot&val=on", function (res) {
         setTimeout(function () { location.href=location.href; }, 10000);          
        });
      }
    })
}
if (check("mqtt") == "off") {
  input(true);
}
var x = ["|","(|","((|","(((|","((((|"];
var y = 0;         
function ani(){
  if (y>4){y=0};
  document.getElementById('sb').value = x[y];
  y=y+1
}
var int;

function scan() {
int = setInterval(ani,200);
send("get_list.lua", {val:"start"}, function (res) {});
setTimeout(function () {
var a = document.getElementById('list');
send("get_list.lua", {val:"get"}, function (res) {
if(res){
  clearInterval(int);
  y=0;
  document.getElementById('sb').value = "Поиск";
  try {
    var j = JSON.parse(res)
    for (var i = 0; i < j.length; i++) {
      if(i==0){
        a.innerHTML = '<li id="'+j[i].sd+'"><b>'+j[i].sd+'</b> rssi : '+ j[i].ri +' channel : '+j[i].cl+'</li>';
      }else{
        a.innerHTML += '<li id="'+j[i].sd+'"><b>'+j[i].sd+'</b> rssi : '+ j[i].ri +' channel : '+j[i].cl+'</li>';
      }    
    }
  } catch (e) {
    a.innerHTML = '<li>Сеть не найдена</li>';
  }
  a.style.display = 'block';  
}  
});  
  }, 5000);
  var a = document.getElementById('dd');
}

document.body.addEventListener("click", function (event) {
  var a = document.getElementById('list');  
  if (event.target.id == "sb") {    
    scan()    
  } else {
    if(event.target.tagName == "LI" && event.target.id){
      document.getElementById('tb').value = event.target.id;
      document.getElementById('pass').value = "";
      document.getElementById('pass').focus()
      document.getElementById('wifi_mode').options[1].selected = 'true' 
       }
    a.style.display = 'none';
  }
});
