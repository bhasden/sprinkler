print("")
print("Heap: " .. node.heap())

if wifi.ap.getip() == nil then
    print("AP IP: nil")
else
    print("AP IP: " .. wifi.ap.getip())
end

if wifi.sta.getip() == nil then
    print("STA IP: nil")
else 
    print("STA IP: " .. wifi.sta.getip())
end

tmr.alarm(1, 10000, 0, function() dofile('startup.lc') end)
