return function(config)
    print("Turning off all zones")
    
    -- Clear zones
    gpio.write(config.clearPin, gpio.LOW)
    gpio.write(config.enablePin, gpio.HIGH)
end
