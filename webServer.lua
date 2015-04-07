local moduleName = ...
local M = {}
_G[moduleName] = M

local config
local server
local state = "inactive"

-- start a web server.  Return the web server object
function M.start(cfg)
    print("Starting webserver")
    -- define member variables
    config = cfg
    server = net.createServer(net.TCP)

    -- define functions
    local parseRequest = function(request)
        -- the first line of the request is in the form METHOD URL PROTOCOL
        _, _, method, url = string.find(request, "(%a+)%s([^%s]+)")
        _, _, path, queryString = string.find(url, "([^%s]+)%?([^%s]+)")
        
        if queryString then
            query = {}
            
            for name, value in string.gfind(queryString, "([^&=]+)=([^&=]+)") do
                query[name] = value
            end
        else
            path = url
            query = nil
        end
        
        return { method = method, url = url, path = path, query = query, queryString = queryString}
    end
    
    -- start listening for requests
    server:listen(80, function(s)
        s:on("receive", function(s, rawRequest)
            local request = parseRequest(rawRequest)
            local response = {}
            print("Request received: ", request.method, request.url,request.path)
            
            if config.pages[request.path] then
                print("Page found")
                response = config.pages[request.path](request)
            else
                print("Not found")
                response.content = "<!DOCTYPE html><html lang=en><body><p>" .. request.url .. " doesn't exist.</p></body></html>"
                response.status = "404 Not Found"
            end
            
            if response.file == nil then
                -- String content
                print("Sending content")
                local headers = "HTTP/1.1 " .. response.status .. "\r\nConnection: keep-alive\r\nCache-Control: private, no-store\r\nContent-Length: " .. string.len(response.content) .. "\r\n\r\n"
                s:send(headers .. response.content)
            else
                -- File content
                local length = 0
                
                for name, size in pairs(file.list()) do
                    if name == response.file then
                        length = size
                        break
                    end
                end
                
                local headers = "HTTP/1.1 " .. response.status .. "\r\nConnection: keep-alive\r\nCache-Control: private, no-store\r\nContent-Length: " .. length .. "\r\n\r\n"
                s:send(headers)
                
                if file.open(response.file, "r") then
                    repeat
                        local line=file.read(128)
                        if line then conn:send(line) end
                        coroutine.yield()
                    until not line    
                    file.close()
                end
            end
        end)
    end)

    state = "listening"
end

function M.close()
    server:close()
    state = "inactive"
end

function M.getStatus()
    return state
end

return M
