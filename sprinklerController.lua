local moduleName = ...
local M = {}
_G[moduleName] = M

local config = {}

local turnOff = function()
     print("Turning off all zones")
     
     gpio.mode(config.clearPin, gpio.OUTPUT)
     gpio.mode(config.clockPin, gpio.OUTPUT)
     gpio.mode(config.dataPin, gpio.OUTPUT)
     gpio.mode(config.latchPin, gpio.OUTPUT)

     -- Clear zones
     gpio.write(config.clearPin, gpio.LOW)
     gpio.write(config.enablePin, gpio.HIGH)
end

-- start a web server.  Return the web server object
function M.create(cfg)
     print("Creating sprinkler controller")
     -- define member variables
     config = cfg
     
     -- define functions
end

M.turnOff = turnOff

function M.turnOn(zone)
     -- Clear any already on zones
     turnOff()
     
     print("Turning on zone " .. zone)

     gpio.mode(config.clearPin, gpio.OUTPUT)
     gpio.mode(config.clockPin, gpio.OUTPUT)
     gpio.mode(config.dataPin, gpio.OUTPUT)
     gpio.mode(config.latchPin, gpio.OUTPUT)

     gpio.write(config.clearPin, gpio.HIGH)
     gpio.write(config.enablePin, gpio.LOW)
     gpio.write(config.latchPin, gpio.LOW)

     -- Get ready to turn on the appropriate zone
     for i = zone, 1, -1 do
          gpio.write(config.clockPin, gpio.LOW);

          if i == zone then 
               gpio.write(config.dataPin, gpio.HIGH);
          else 
               gpio.write(config.dataPin, gpio.LOW);
          end
          
          gpio.write(config.clockPin, gpio.HIGH);
     end

     -- Make it so
     gpio.write(config.latchPin, gpio.HIGH)
end

return M
