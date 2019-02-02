var settings = {};

function send(page, data, callback) {
  var req = new XMLHttpRequest();
  req.open("POST", page, true);
  req.setRequestHeader('Content-Type', 'application/json');
  req.addEventListener("load", function () {
    if (req.status < 400) {
      callback(req.responseText);
    } else {
      callback(false);
    }
  });
  req.send(JSON.stringify(data));
}

function listLink() {
  for (i = 0; i < localStorage.length; i++) {
    var myKey = localStorage.key(i);
    if (myKey == "web.info") continue;
    myKey = myKey.split(".")
    console.log(myKey);
    var a = document.createElement('a');
    a.href = "plugin.html?plugin=" + myKey[0];
    a.style.color = "black"
    a.innerHTML = '<li class="lg-i">' + myKey[0] + '</li>'
    list.appendChild(a);
  }
}

function loadURl(src) {
  var load;
  if (src.indexOf(".js") != -1) {
    load = document.createElement('script');
    load.src = src;
    load.async = false;
  } else {
    load = document.createElement("link");
    load.setAttribute("rel", "stylesheet");
    load.setAttribute("type", "text/css");
    load.setAttribute("href", src);
  }
  document.head.appendChild(load);
  load.onload = function () {
    document.getElementById("loader").classList.add('hide');
  };
  load.onerror = function () {
    //    next();
  };
}

function card(obj) {
  var temp =
    '<div class="card hover">' +
    '<div class="card-image"' + (obj.info.img ? 'style="background: url(' + obj.info.img + ') center center / cover no-repeat;"' : '') + '></div>' +
    '<div class="card-content"><span title="Module name" class="card-title">' + obj.info.name + '</span>' +
    '<div class="tia run"></div>' +
    '<div class="group btnInfo">' +
    '<input title="autostart module" ' + (obj.init.run ? "checked " : "") + 'type="checkbox" id="run" />' +
    '<label for="run"></label></div>' +
    '<span class="vers" title="Installed version">version <b>' + obj.info.version + '</b></span><p>'
  if (typeof (obj.info.page) === 'object') {
    obj.info.page.forEach(function (item, i, arr) {
      temp += '<a title="/' + item + '" target="_blank" href="' + item + '">link </a>'
    });
  } else {
    temp += '<a title="/' + obj.info.page + '" target="_blank" href="' + obj.info.page + '">link</a>'
  }
  temp +=
    '</p><p><b>Description : </b>' + obj.info.description + '</p>' +
    '<p><b>Modules : </b>' + obj.info.modules.join(", ") + '</p>' +
    '<span class="git b"><a target="_blank" href="' + obj.info.repository.url + '">GitHub</a></span>' +
    '</div>' +
    '</div>'
  return temp;
}

function create(html, id, c) {
  var e = document.createElement('div');
  e.className = c;
  e.innerHTML = html;
  document.getElementById(id).appendChild(e)
}

window.onload = function () {
  listLink();
  document.getElementById('loader').classList.add('hide');
  var url = new URL(window.location.href);
  var param = url.searchParams.get("plugin");
  if (param) {
    send(param + ".init", {}, function (res) {
      if (res) {
        try {
          settings.init = JSON.parse(res);
          settings.info = JSON.parse(localStorage.getItem(param + ".info"));
        } catch (e) {
          console.log(e);
          return
        }
        load(settings);
        create(card(settings), "info", "s12");
        if (settings.info.script) {
          setTimeout(function () {
            loadURl(settings.info.script);
          }, 2000);
        } else {
          document.getElementById("loader").classList.add('hide');
        }
      }
    });
  }
};

function text(obj, val) {
  var temp =
    '<div class="group">' +
    '<input id="' + obj.id + '" type="text" required="" value="' + obj.valInit + '">' +
    '<label for="' + obj.name + '">' + obj.name + '</label>' +
    '</div>'
  return temp;
}

function number(obj) {
  var temp =
    '<div class="group">' +
    '<input id="' + obj.id + '" title="min=' + obj.min + ', max=' + obj.max + '" type="number" min="' + obj.min + '" max="' + obj.max + '" required="" value="' + obj.valInit + '">' +
    '<label for="' + obj.id + '">' + obj.name + '</label></div>'
  return temp;
}

function select(obj) {
  var temp = '  <div class="group"><select id="' + obj.id + '" name="' + obj.id + '">'
  obj.values.forEach(function (item, i, arr) {
    if (item === obj.valInit) {
      temp += '<option selected value="' + item + '">' + item + '</option>'
    } else {
      temp += '<option value="' + item + '">' + item + '</option>'
    }
  })
  temp += '</select><span>' + obj.name + '</span></div>'
  return temp;
}

function load(sett) {
  var native = sett.info.native;
  console.log(native);
  native.forEach(function (item, i) {
    if (i !== 0) {
      var obj = item;
      obj.valInit = sett.init[item.id];
      if (obj.type === "number") {
        create(number(obj), "plugin", "s6");
      } else if (obj.type === "select") {
        create(select(obj), "plugin", "s6");
      } else {
        create(text(obj), "plugin", "s6");
      }
    }
  });
}

function validate(n) {
  var id = document.getElementById(n);
  var val = id.value;
  if (val.length === 0) return false;
  if (id.type === "number") {
    var min = +id.getAttribute('min');
    var max = +id.getAttribute('max');
    if (val < min || val > max) return false;
  }
  return true;
}

function save() {
  var temp = {};
  var valid = true;
  for (var key in settings.init) {
    var id = document.getElementById(key);
    if (!validate(key)) {
      alert("Error in input field " + key);
      valid = false;
    }
    if (id.type === "checkbox") {
      temp[key] = id.checked;
    } else if (id.type === "number") {
      temp[key] = +id.value;
    } else if (id.type === "select-one") {
      temp[key] = isNaN(+id.value) ? id.value : +id.value;
    } else {
      temp[key] = id.value;
    }

  }
  if (valid) {
    temp.Fname = settings.info.name + ".init";
    var saveInfo = document.getElementById("saveInfo");
    saveInfo.innerHTML = "Saving"
    send("init_settings.lua", {
      save: temp
    }, function (res) {
      if (res) {
        saveInfo.innerHTML = "Saved"
      } else {
        saveInfo.innerHTML = "Error"
      }
      console.log(res);
      setTimeout(function () {
        saveInfo.innerHTML = "Save"
        reboot(true);
      }, 2000);
    });
  }
  console.log(temp);
}


function def() {
  var native = settings.info.native;
  console.log(native)
  native.forEach(function (item, i) {
    console.log(item.val)
    if (item.type === "checkbox") {
      console.log(item.id)
      document.getElementById(item.id).checked = item.val
    } else if (item.type === "select") {
      var s = document.getElementById(item.id);
      for (var i = 0; i < s.options.length; i++) {
        s.options[i].selected = false;

        if (s.options[i].value == item.val) {
          s.options[i].selected = true;
        }
      }
    } else {
      document.getElementById(item.id).value = item.val
    }
  });
}

function del() {
  send("init_settings.lua", {
    del: settings.info.files
  }, function (res) {
    console.log(res);
    document.getElementById("loader").classList.remove('hide');
    if (res) {
      localStorage.removeItem(settings.info.name + ".info");
      setTimeout(function () {
        location.href = '/index.html';
      }, 1000);
    }
  });
}

//  function run(val) {
//   console.log(settings.info.name);
//   if (val) {
//    send("init_settings.lua", {
//     run: {
//      name: settings.info.name
//     }
//    }, function(res) {
//     console.log(res);
//    });
//   }
//  }

function logout() {
  document.cookie = "id=";
  location.href = '/login.html';
}

function reboot(d) {
  if (d) {
    document.getElementById("Modal").style.display = "block";
  } else {
    document.getElementById("loader").classList.remove('hide');
    send("web_control.lua", {
      init: "reboot"
    }, function (res) {
      document.getElementById("Modal").style.display = "none";
      setTimeout(function () {
        location.href = "/";
      }, 10000);
    });
  }
}

function modClose() {
  document.getElementById("Modal").style.display = "none";
}
