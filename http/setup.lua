return function (connection, args, formData)
    local function updateWifi()
        print("Updating wifi credentials")
        wifi.sta.config(ssid, password)
        wifi.setmode(wifi.STATION)
        print("Restarting device")
        node.restart()
    end

    local ssid = formData["ssid"]
    local password = formData["password"]
    
    connection:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\Cache-Control: private, no-store\r\n\r\n")
    connection:send('<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Arguments</title></head>')
    connection:send('<body>')
    connection:send('<h1>Wifi Setup</h1>')
    
    connection:send('<form method="POST">')
    connection:send('SSID:<br><input type="text" name="ssid"><br>')
    connection:send('Password:<br><input type="password" name="password"><br>')
    connection:send('<input type="submit" value="Submit">')
    connection:send('</form>')

    connection:send('</body></html>')

    if ssid ~= nil and password ~= nil then
        tmr.alarm(0, 2000, 0, updateWifi)
    end
end
