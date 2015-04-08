return function(topic, data)
    print(topic .. ":" ) 
    if data ~= nil then
        print(data)
    end
    
    if topic == wifi.sta.getmac() .. "/zone/on" then
        local zoneData = cjson.decode(data)
        dofile("sprinklerController.lc")({
            clearPin = 2, -- 4
            clockPin = 0, -- 16
            dataPin = 7, -- 13
            enablePin = 6, -- 12
            latchPin = 5, -- 14
        }, zoneData.zone)
    elseif topic == wifi.sta.getmac() .. "/zone/off" then
        dofile("sprinklerController-turnOff.lc")({
            clearPin = 2, -- 4
            clockPin = 0, -- 16
            dataPin = 7, -- 13
            enablePin = 6, -- 12
            latchPin = 5, -- 14
        })
    end
end