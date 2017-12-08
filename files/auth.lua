return function (arg)
local r
if crypto.toBase64(crypto.mask(arg.login..arg.pass,s.token))==crypto.toBase64(crypto.mask(s.auth_login..s.auth_pass,s.token))then
r=crypto.toBase64(crypto.mask(arg.login..arg.pass,s.token))
else
r="false"
end
   return r
end
