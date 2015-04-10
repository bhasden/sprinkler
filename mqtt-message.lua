return function(m, topic, data)
    local config = {
        clearPin = 2, -- 4
        clockPin = 0, -- 16
        dataPin = 7, -- 13
        enablePin = 6, -- 12
        latchPin = 5, -- 14
    }

    if topic == wifi.sta.getmac() .. "/zone/on" then
        local zoneData = cjson.decode(data)

        dofile("sprinklerController-turnOff.lc")(config)
        dofile("sprinklerController-turnOn.lc")(config, zoneData.zone)
    elseif topic == wifi.sta.getmac() .. "/zone/off" then
        dofile("sprinklerController-turnOff.lc")(config)
    elseif topic == wifi.sta.getmac() .. "/zone/request" then
        m:publish(wifi.sta.getmac() .. "/zone/state", cjson.encode({ zone = currentZone }), 0, 0, function(conn)
            print("Sending state")
        end)
    end
end
