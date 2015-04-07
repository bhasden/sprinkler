local function setupClient(client, config)
    if wifi.sta.status() == 5 then
        tmr.stop(0)
        client:connect(config.address, config.port, 0, function(conn) 
            print("MQTT Connected")
            client:subscribe(wifi.sta.getmac() .. "/zone/on", 0, function(conn) 
                print("MQTT Subscribed")
            end)
        end)
    
        tmr.alarm(1, 20000, 0, function()
            client:publish(wifi.sta.getmac() .. "/zone/on", cjson.encode({ zone = 2 }), 0, 0, function(conn) 
                print("MQTT Sent") 
            end)
                
            tmr.alarm(1, 10000, 0, function()
                client:publish(wifi.sta.getmac() .. "/zone/off", "", 0, 0, function(conn) 
                    print("MQTT Sent")
                end)
            end)
        end)
    end
end

return function(config)
    local m = mqtt.Client(wifi.sta.getmac(), 120)--, config.username, config.password)
    
    m:lwt("/lwt", wifi.sta.getmac(), 0, 0)

    m:on("offline", function(con) 
        print ("MQTT Reconnecting...")
        tmr.alarm(0, 10000, 1, function() setupClient(m, config) end)
    end)

    -- on publish message receive event
    m:on("message", function(conn, topic, data)
        dofile("mqtt-message.lc")(topic, data)
    end)

    tmr.alarm(0, 1000, 1, function() setupClient(m, config) end)

    return m
end