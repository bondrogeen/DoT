window.onload = function () {
  var modal = document.getElementById('Modal');
  var int;
  var scanStart;

  function send(page, data, callback) {
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
    req.send(JSON.stringify(data));
  }

  function id(val) {
    return document.getElementById(val).value
  }

  function check_sel(val) {
    var s = document.getElementById(val);
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
    document.getElementById('loader').classList.remove('hide')
    var data = {
      init: "save"
    };
    var stop = false
    var arr = ["ssid", "pwd", "mode", "pass", "login", "auth"];
    arr.forEach(function (item, i, arr) {
      if (item === "mode" || item === "auth") {
        data[item] = check_sel(item)
      } else {
        var x = id(item)
        if (x || x !== '') data[item] = x;
      }
    });
    if (stop) {
      modal.style.display = "none";
      return;
    }
    if (check_sel("mode") === "OFF") {
      var w = confirm("Внимание!!! Wi-fi будет отключен, Вы точно этого хотите?");
      if (!w) {
        return
      }
    }
    modal.style.opacity = "0";
    setTimeout(function () {
      modal.style.display = "none";
    }, 600);

    send("web_control.lua", data, function (res) {
      if (res === "true") {
        send("web_control.lua", {
          init: "reboot"
        }, function (res) {
          setTimeout(function () {
            location.href = "/";
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
        var a = document.getElementById('list');
        send("get_network.json", {}, function (res) {
          scanStart = false;
          if (res) {
            //            console.log(res)
            clearInterval(int);
            y = 0;
            document.getElementById('search').value = "Search...";
            try {
              var j = JSON.parse(res);
              console.log(j)

              var i = 1;
              var buf='';
              for (key in j) {
                var data = j[key].split(",")
                 buf += '<li id="' + key + '"><b>' + key + '</b> rssi : ' + data[1] + ' channel : ' + data[3] + '</li>';
                i++;
              }
              a.innerHTML = buf;
            } catch (e) {
              a.innerHTML = '<li>No networks found</li>';
            }
            a.style.display = 'block';
          }

        });
      }, 5000);
    }
  }

  document.body.addEventListener("click", function (event) {
    var a = document.getElementById('list');
    if (event.target.id === "search") {
      scan();
    } else if (event.target.id === "openNav") {
      document.getElementById('mySidenav').classList.toggle('open');
    } else if (event.target.id === "btn_nav") {
      document.getElementById("myTopnav").classList.toggle('res');
    } else if (event.target.id === "btn_exit") {
      logout();
    } else if (event.target.id === "btn_save") {
      modal.style.opacity = "1";
      modal.style.display = "block";
    } else if (event.target.id === "close_m" | event.target.id == "close") {
      modal.style.opacity = "0";
      setTimeout(function () {
        modal.style.display = "none";
      }, 600);
    } else if (event.target.id === "save_m") {
      save();
    } else {
      document.getElementById("mySidenav").classList.remove("open");
      if (event.target.tagName === "LI" && event.target.id) {
        document.getElementById('ssid').value = event.target.id;
        document.getElementById('pwd').value = "";
        document.getElementById('pwd').focus();
        document.getElementById('mode').options[1].selected = 'true'
      }
      a.style.display = 'none';
    }
  });
};
