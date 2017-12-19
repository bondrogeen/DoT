return function (args)
 local str=""
 for k, v in pairs(args) do
  str=str..k.." : "..v.."<br>"
 end
 return str
end
