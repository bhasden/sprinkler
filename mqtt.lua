local function setupClient(client, config)
    if wifi.sta.status() == 5 then
        tmr.stop(0)
        client:connect(config.address, config.port, 0, function(conn) 
            print("MQTT Connected")
            client:subscribe(wifi.sta.getmac() .. "/zone/on", 0, function(conn) 
                print("MQTT Subscribed On")

                client:subscribe(wifi.sta.getmac() .. "/zone/off", 0, function(conn) 
                    print("MQTT Subscribed Off")
                        
                    client:subscribe(wifi.sta.getmac() .. "/zone/request", 0, function(conn) 
                        print("MQTT Subscribed Request")
                    end)
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
        tmr.delay(10000)
        tmr.alarm(0, 10000, 1, function() setupClient(m, config) end)
    end)

    -- on publish message receive event
    m:on("message", function(conn, topic, data)
        dofile("mqtt-message.lc")(m, topic, data)
    end)

    tmr.alarm(0, 1000, 1, function() setupClient(m, config) end)

    return m
end
