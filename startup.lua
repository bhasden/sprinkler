local function startMqtt()
     mqtt = dofile("mqtt.lc")({
         address = "107.155.90.192",
         port = 1883
     })
end

local function startWebServer()
    -- Compile server code and remove original .lua files.
    -- This only happens the first time afer the .lua files are uploaded.
    local compileAndRemoveIfNeeded = function(f)
        if file.open(f) then
            file.close()
            print("Compiling " .. f)
            node.compile(f)
            file.remove(f)
        end
    end
    
    local serverFiles = {'httpserver.lua', 'httpserver-request.lua', 'httpserver-static.lua', 'httpserver-error.lua'}
    for i, f in ipairs(serverFiles) do compileAndRemoveIfNeeded(f) end

    -- Uncomment to automatically start the server in port 80
    dofile("httpserver.lc")(80)

    compileAndRemoveIfNeeded = nil
    serverFiles = nil
end

local function startSprinklerController()
     sprinklers = dofile("sprinklerController.lc")({
         clearPin = 2, -- 4
         clockPin = 0, -- 16
         dataPin = 7, -- 13
         enablePin = 6, -- 12
         latchPin = 5, -- 14
     })
     sprinklers.turnOff()
end

-- Connect to the WiFi access point. Once the device is connected,
-- you may start the HTTP server.
tmr.alarm(0, 3000, 1, function()
    if wifi.getmode() == wifi.STATION then
        if wifi.sta.status() == 0 then -- STATION_IDLE
            print("Connection idle")
        elseif wifi.sta.status() == 1 then -- STATION_CONNECTING 
            print("Connecting to AP...")
        elseif wifi.sta.status() == 5 then -- STATION_GOT_IP
            print("Connected to AP")
            tmr.stop(0)
            print('IP: ', wifi.sta.getip())
        else
            print("Could not connect to access point (" .. wifi.sta.status() .. ")")
            if wifi.getmode() ~= wifi.STATIONAP then
                print("Restarting AP")
                wifi.ap.config({ssid="Sprinklers", pwd="pass1234"})
                wifi.setmode(wifi.STATIONAP)
            end
        end
    else
        if wifi.getmode() ~= wifi.STATIONAP then
            print("Starting AP")
            wifi.ap.config({ssid="Sprinklers",pwd="pass1234"})
            wifi.setmode(wifi.STATIONAP)
        end
    end
end)

startWebServer()
startMqtt()
startSprinklerController()