return function(topic, data)
    print(topic .. ":" ) 
    if data ~= nil then
        print(data)
    end
    
    if topic == wifi.sta.getmac() .. "/zone/on" then
        local zoneData = cjson.decode(data)
        sprinklers.turnOn(zoneData.zone)
    elseif topic == wifi.sta.getmac() .. "/zone/off" then
        sprinklers.turnOff()
    end
end