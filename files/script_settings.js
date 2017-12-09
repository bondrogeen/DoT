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
function name(val) {
  return document.getElementsByName(val)[0].value;
}
function check_sel(val) {
  var s = document.getElementById(val);
  for (var i = 0; i < s.options.length; i++) {
    if (s.options[i].selected) {
      return s.options[i].value;
    }
  }
}
function logout(){
  document.cookie = "id=";
  location.href = '/login.html';
}
function save() {
  var date = {init:"save"};
  var arr = ["wifi_id", "wifi_pass", "wifi_mode"];
  if (check_sel("wifi_mode") == "OFF") {
    var w = confirm("Внимание!!! Wi-fi будет отключен, Вы точно этого хотите?");
    if (!w) {
      return
    }
  }
  send("save.lua", date, function (res) {
    var reboot = confirm("Reboot device?");
    if (reboot) {
      send("send.lua", {com:"reboot",val:"on"}, function (res) {
        setTimeout(function () {
          location.href = location.href;
        }, 10000);
      });
    }
  })
}
var x = ["|", "(|", "((|", "(((|", "((((|"];
var y = 0;

function ani() {
  if (y > 4) {
    y = 0
  };
  document.getElementById('sb').value = x[y];
  y = y + 1
}
var int;

function scan() {
  int = setInterval(ani, 200);
  send("web_control.lua", {init:"scan"}, function (res) {});
  
  setTimeout(function () {
    var a = document.getElementById('list');
    send("web_control.lua", {
      init: "get"
    }, function (res) {
      if (res) {
        clearInterval(int);
        y = 0;
        document.getElementById('sb').value = "Поиск";
        try {
          var j = JSON.parse(res)
          for (var i = 0; i < j.length; i++) {
            if (i == 0) {
              a.innerHTML = '<li id="' + j[i].sd + '"><b>' + j[i].sd + '</b> rssi : ' + j[i].ri + ' channel : ' + j[i].cl + '</li>';
            } else {
              a.innerHTML += '<li id="' + j[i].sd + '"><b>' + j[i].sd + '</b> rssi : ' + j[i].ri + ' channel : ' + j[i].cl + '</li>';
            }
          }
        } catch (e) {
          a.innerHTML = '<li>Сеть не найдена</li>';
        }
        a.style.display = 'block';
      }
    });
  }, 5000);
}

document.body.addEventListener("click", function (event) {
  var a = document.getElementById('list');
  if (event.target.id == "sb") {
    scan()
  } else {
    if (event.target.tagName == "LI" && event.target.id) {
      document.getElementById('tb').value = event.target.id;
      document.getElementById('pass').value = "";
      document.getElementById('pass').focus()
      document.getElementById('wifi_mode').options[1].selected = 'true'
    }
    a.style.display = 'none';
  }
});