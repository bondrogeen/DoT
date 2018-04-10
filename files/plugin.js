var settings = {};

function send(page, data, callback) {
   var req = new XMLHttpRequest();
   req.open("POST", page, true);
   req.setRequestHeader('Content-Type', 'application/json');
   req.addEventListener("load", function() {
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

  function card(obj) {
   var temp  =
    '<div class="card hover">' +
    '<div class="card-image"' + (obj.info.img ? 'style="background: url(' + obj.info.img + ') center center / cover no-repeat;"' : '') + '></div>' +
    '<div class="card-content"><span title="Module name" class="card-title">' + obj.info.name + '</span>' +
    '<div class="tia run"></div>' +
    '<div class="group btnInfo">' +
    '<input title="autostart module" ' + (obj.init.run ? "checked " : "") + 'type="checkbox" onchange="run(this.checked);" id="run" />' +
    '<label for="run"></label></div>' +
    '<span class="vers" title="Installed version">version <b>' + obj.info.version + '</b></span><p>'
    if (typeof(obj.info.page) === 'object') {
    obj.info.page.forEach(function(item, i, arr) {
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

  window.onload = function() {
   listLink();
   var url = new URL(window.location.href);
   var param = url.searchParams.get("plugin");
   if (param) {
    send(param + ".init", {}, function(res) {
     if (res) {
      try {
       settings.init = JSON.parse(res);
       settings.info = JSON.parse(localStorage.getItem(param + ".info"));
      } catch (e) {
       console.log(e);
       return
      }
      console.log(settings);
      load(settings);
      create(card(settings), "info", "s12");
     }
    });
   }
  };

  function text(obj, val) {
   var temp =
    '<div class="group">' +
    '<input id="' + obj.key + '" type="text" required="" value="' + val + '">' +
    '<label for="' + obj.key + '">' + obj.key + '</label>' +
    '</div>'
   return temp;
  }

  function number(obj) {
   var temp =
    '<div class="group">' +
    '<input id="' + obj.key + '" title="min=' + obj.min + ', max=' + obj.max + '" type="number" min="' + obj.min + '" max="' + obj.max + '" required="" value="' + obj.val + '">' +
    '<label for="' + obj.key + '">' + obj.val + '</label></div>'
   return temp;
  }

  function select(obj) {
   var temp = '  <div class="group"><select id="' + obj.key + '" name="' + obj.key + '">'
   obj.values.forEach(function(item, i, arr) {
    if (item === obj.val) {
     temp += '<option selected value="' + item + '">' + item + '</option>'
    } else {
     temp += '<option value="' + item + '">' + item + '</option>'
    }
   })
   temp += '</select><span>' + obj.name + '</span></div>'
   return temp;
  }


  function load(sett) {
   var html = "";
   for (var key in sett.init) {
    var obj = sett.info.native[key];
    obj.val = sett.init[key];
    obj.key = key;
    if (key === "run") continue;
    if (obj.type === "number") {
     create(number(obj), "plugin", "s6");
    } else if (obj.type === "select") {
     create(select(obj), "plugin", "s6");
    } else {
     create(text(obj), "plugin", "s6");
    }
   }
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
     alert("Error in input field : '" + settings.info.native[key].name + "'");
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
    send("init_settings.lua", {
     save: temp
    }, function(res) {
     console.log(res);
    });
   }
   console.log(temp);
  }


  function def() {
   for (var key in settings.info.native) {
    if (document.getElementById(key).type === "checkbox") {
     document.getElementById(key).checked = settings.info.native[key].val
    } else {
     document.getElementById(key).value = settings.info.native[key].val
    }
   }
  }

  function del() {
   send("init_settings.lua", {
    del: settings.info.files
   }, function(res) {
    console.log(res);
    document.getElementById("loader").classList.remove('hide');
    if (res) {
     localStorage.removeItem(settings.info.name + ".info");
     setTimeout(function() {
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

  function nav() {
   var x = document.getElementById("myTopnav");
   if (x.classList.contains("res")) {
    x.classList.remove('res');
   } else {
    x.classList.add('res');
   }
  }

  function openNav() {
   var side = document.getElementById("mySidenav")
   if (side.style.width === "200px") {
    side.style.width = "0px";
   } else {
    side.style.width = "200px";
   }
  }

  function closeNav() {
   document.getElementById("mySidenav").style.width = "0";
  }
