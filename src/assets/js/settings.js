window.onload = function () {
  var int;
  var scanStart;
  var settings;

  function send(page, data, callback) {
    var req = new XMLHttpRequest();
    req.open("POST", page, true);
    req.setRequestHeader('Content-Type', 'application/json');
    req.addEventListener("load", function () {
      if (callback)(req.status === 200) ? callback(req.responseText) : callback(false)
    });
    req.send(JSON.stringify(data));
  }

  function parse(text) {
    try {
      return JSON.parse(text);
    } catch (err) {
      return false;
    }
  }

  function $(val) {
    return document.getElementById(val);
  }

  function loadSettings() {
    send("init_settings.lua", {
      def: 1
    }, function (res) {
      $('loader').classList.add('hide');
      var data = parse(res);
      console.log(data);
      if (!data) {
        console.log("Error load settings.");
      } else {
        settings = data;
        $('pwd').value = data.pwd;
        $('ssid').value = data.ssid;
        $('login').value = data.login;
        $('pass').value = data.pass;
        $('mode').value = data.mode;
        $('auth').value = (data.auth === true);
      }
    });
  }

  function check_sel(val) {
    var s = $(val);
    for (var i = 0; i < s.options.length; i++) {
      if (s.options[i].selected) {
        return s.options[i].value
      }
    }
  }

  function logout() {
    document.cookie = "id=";
    location.href = '/login.html';
  }

  function save() {
    var data = {
      Fname: "setting.json"
    };
    var arr = ["ssid", "pwd", "mode", "pass", "login", "auth"];
    arr.forEach(function (item, i, arr) {
      if (item === "mode") {
        data[item] = +check_sel(item);
      } else if (item === "auth") {
        data[item] = check_sel(item) == "true";
      } else {
        var x = $(item).value;
        if (x || x !== '') data[item] = x;
      }
    });
    if (+check_sel("mode") === 0) {
      if (!confirm("Attention !!! Wi-Fi will be disabled, do you really want it?")) return;
    }
    $('loader').classList.remove('hide')
    $('modal').classList.add("hide");
    send("init_settings.lua", {
      save: data
    }, function (res) {
      if (res === "true") {
        send("web_control.lua", {
          reboot: true
        }, function (res) {
          setTimeout(function () {
            location.href = "/";
          }, 10000);
        });
      }
    });
  }


  var x = ["|", "(|", "((|", "(((|", "((((|"];
  var y = 0;

  function ani() {
    if (y > 4) {
      y = 0
    }
    document.getElementById('search').value = x[y];
    y = y + 1
  }

  function scan() {
    if (!scanStart) {
      scanStart = true;
      int = setInterval(ani, 200);
      send("web_control.lua", {
        scan: true
      }, function (res) {});
      setTimeout(function () {
        send("get_network.json", {}, function (res) {
          scanStart = false;
          if (res) {
            clearInterval(int);
            y = 0;
            $('search').value = "Search...";
            try {
              var j = JSON.parse(res);
              var i = 1;
              var buf = '';
              for (key in j) {
                var data = j[key].split(",")
                buf += '<li id="' + key + '"><b>' + key + '</b> rssi : ' + data[1] + ' channel : ' + data[3] + '</li>';
                i++;
              }
              $('list').innerHTML = buf;
            } catch (e) {
              $('list').innerHTML = '<li>No networks found</li>';
            }
            $('list').style.display = 'block';
          }

        });
      }, 5000);
    }
  }



  loadSettings();
  document.body.addEventListener("click", function (event) {
    var id = event.target.id;
    if (id === "search") scan();
    if (id === "btn_exit") logout();
    if (id === "save_m") save();
    if (id === "btn_save") $('modal').classList.remove("hide");
    if (id === "close" || id === "close_m") $('modal').classList.add("hide");
    if (event.target.tagName === "LI") {
      var a = $('list');
      if (id) {
        $('ssid').value = id;
        $('pwd').value = "";
        $('pwd').focus();
        $('mode').value = "1";
      }
      a.style.display = 'none';
    }
  });
};
