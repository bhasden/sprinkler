return function(config)
    local sprinklers = {}

    gpio.mode(config.clearPin, gpio.OUTPUT)
    gpio.mode(config.clockPin, gpio.OUTPUT)
    gpio.mode(config.dataPin, gpio.OUTPUT)
    gpio.mode(config.enablePin, gpio.OUTPUT)
    gpio.mode(config.latchPin, gpio.OUTPUT)

    sprinklers.turnOff = function()
        dofile("sprinklerController-turnOff.lc")(config)
    end

    sprinklers.turnOn = function(zone)
        sprinklers.turnOff()
        dofile("sprinklerController-turnOn.lc")(config, zone)
    end

    return sprinklers
end