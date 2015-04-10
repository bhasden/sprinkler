return function(config)
    print("Turning off all zones")
    
    gpio.mode(config.clearPin, gpio.OUTPUT)
    gpio.mode(config.clockPin, gpio.OUTPUT)
    gpio.mode(config.dataPin, gpio.OUTPUT)
    gpio.mode(config.enablePin, gpio.OUTPUT)
    gpio.mode(config.latchPin, gpio.OUTPUT)
    
    -- Clear zones
    gpio.write(config.clearPin, gpio.LOW)
    gpio.write(config.enablePin, gpio.HIGH)
    
    currentZone = nil
end
