currentZone = nil

return function(config, zone)
    -- Clear any already on zones
    print("Turning on zone " .. zone)
    
    gpio.mode(config.clearPin, gpio.OUTPUT)
    gpio.mode(config.clockPin, gpio.OUTPUT)
    gpio.mode(config.dataPin, gpio.OUTPUT)
    gpio.mode(config.enablePin, gpio.OUTPUT)
    gpio.mode(config.latchPin, gpio.OUTPUT)
    
    gpio.write(config.clearPin, gpio.HIGH)
    gpio.write(config.enablePin, gpio.LOW)
    gpio.write(config.latchPin, gpio.LOW)
    
    -- Get ready to turn on the appropriate zone
    for i = zone, 1, -1 do            
        if i == zone then 
            gpio.write(config.dataPin, gpio.HIGH);
        else
            gpio.write(config.dataPin, gpio.LOW);
        end
        
        gpio.write(config.clockPin, gpio.HIGH);
        gpio.write(config.clockPin, gpio.LOW);
    end
    
    -- Make it so
    gpio.write(config.latchPin, gpio.HIGH)
    currentZone = zone;
end
