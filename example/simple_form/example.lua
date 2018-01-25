return function (args)
 print(args.loginSendTo)
 print(args.passSendTo)
 return 'Login = '..args.loginSendTo..'Pass = '..args.passSendTo..' <br> Come back in 5 seconds... <script> setTimeout(function() { history.back() }, 5000);</script>'
end

