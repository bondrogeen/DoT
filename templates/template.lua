Local function arg_to_str(val)
  local str=""
  for k, v in pairs(val) do
    str=str..k.." : "..v.."
  end
  return str
end

return function (args)
 return arg_to_str(args)
end
