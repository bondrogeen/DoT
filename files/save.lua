return function (tab)
 for k,v in pairs(tab) do
  if (tonumber(v) and k ~= "mqtt_server")then
   settings[k]=tonumber(v);
  else
   settings[k]=v
  end
 end
 local ok, json = pcall(sjson.encode, settings)
  if ok then
   if file.open("setting.json", "w") then
    file.write(json)
    file.close()
   end
   print(json)
   return '{"settings":"true"}'
 else
  return '{"settings":"false"}'
 end
end

