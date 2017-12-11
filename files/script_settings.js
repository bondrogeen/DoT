window.onload = function () {
	var modal = document.getElementById('Modal');
	var int;
	
	function sendGet(page, data, callback) {
		var req = new XMLHttpRequest();
		req.open("GET", page, true);		
		req.addEventListener("load", function () {
			if (req.status < 400) {
				callback(req.responseText);
			} else {
				callback(req.status);
			}
		});
		req.send();
	}
	sendGet("http://codedevice.ru", "", function(s){
		alert(s)
	})
	
	
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

	function nav() {
		var x = document.getElementById("myTopnav");
		if (x.className === "nav") {
			x.className += " res";
		} else {
			x.className = "nav";
		}
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
		var data = {
			init: "save"
		};
		var arr = ["wifi_id", "wifi_pass", "wifi_mode", "auth_pass", "auth_login", "auth"];
		arr.forEach(function (item, i, arr) {
			if (item == "wifi_mode" || item == "auth") {
				data[item] = check_sel(item)
			} else {
				data[item] = id(item)
			}
		});
		if (check_sel("wifi_mode") == "OFF") {
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
			if (res = "true") {
				send("web_control.lua", {
					init: "reboot"
				}, function (res) {
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
		}
		document.getElementById('search').value = x[y];
		y = y + 1
	}

	function scan() {
		int = setInterval(ani, 200);
		send("web_control.lua", {
			init: "scan"
		}, function (res) {});

		setTimeout(function () {
			var a = document.getElementById('list');
			send("web_control.lua", {
				init: "get"
			}, function (res) {
				if (res) {
					clearInterval(int);
					y = 0;
					document.getElementById('search').value = "Поиск";
					try {
						var j = JSON.parse(res);
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
		//alert(event.target.id)
		if (event.target.id == "search") {
			scan();
		} else if (event.target.id == "btn_nav") {
			nav();
		} else if (event.target.id == "btn_exit") {
			logout();
		} else if (event.target.id == "btn_save") {
			modal.style.opacity = "1";
			modal.style.display = "block";
		} else if (event.target.id == "close_m" | event.target.id == "close") {
			modal.style.opacity = "0";
			setTimeout(function () {
				modal.style.display = "none";
			}, 600);
		} else if (event.target.id == "save_m") {
			save()
		} else {
			if (event.target.tagName == "LI" && event.target.id) {
				document.getElementById('wifi_id').value = event.target.id;
				document.getElementById('wifi_pass').value = "";
				document.getElementById('wifi_pass').focus();
				document.getElementById('wifi_mode').options[1].selected = 'true'
			}
			a.style.display = 'none';
		}
	});
};