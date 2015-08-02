i2c_id = 0
sensor_address = 0x48
mqtt_server = "172.22.12.11"

i2c.setup(i2c_id, 4, 3, i2c.SLOW)

wifi.setmode(wifi.STATION)
wifi.sta.config("NC-AP2", "votrepass", 0)
wifi.sta.connect()

function humanize(str)
    h, l = string.byte(str, 1, 2)
    l = bit.rshift(l, 5)
    return h + l / 10
end

function read_sensor_bytes()
    i2c.start(i2c_id)
    i2c.address(i2c_id, sensor_address, i2c.TRANSMITTER)
    -- 0x01: Basculement sur le registre de configuration
    -- 0xFF:
    -- 0x02: Temperature sur 12 bits
    i2c.write(i2c_id, 0x01, 0xFF, 0x02)
    i2c.stop(i2c_id)
    
    i2c.start(i2c_id)
    i2c.address(i2c_id, sensor_address, i2c.TRANSMITTER)
    -- 0x00: Basculement sur le registre de temperature
    i2c.write(i2c_id, 0x00)
    i2c.stop(i2c_id)
    
    
    i2c.start(i2c_id)
    i2c.address(i2c_id, sensor_address, i2c.RECEIVER)
    c = i2c.read(i2c_id, 2)
    i2c.stop(i2c_id)
    
    return c
end

function build_post_request(path, key, value)
    payload = "temperature_value=" .. value
    
    return "POST " .. path .. " HTTP/1.1\r\n" ..
    "Host: " .. server_ip .. "\r\n" ..
    "Connection: close\r\n" ..
    "Content-Type: application/x-www-form-urlencoded\r\n" ..
    "Content-Length: " .. string.len(payload) .. "\r\n" ..
    "\r\n" .. payload
end

function send_temperature(value)
sk = net.createConnection(net.TCP, 0)
sk:connect(server_port, server_ip)
request = build_post_request("/temperature", "temperature_value", value)

sk:send(request, function()
    sk:close()
end)
end

function main()
    tmr.alarm(2, 10000, 1, function()
        temp = humanize(read_sensor_bytes())
        send_temperature(temp)
    end)
end

tmr.alarm(1, 1000, 1, function()
    if wifi.sta.status() ~= 5 then
        print(" Wait to IP address!")
    else
        print("New IP address is " .. wifi.sta.getip())
        main()
        tmr.stop(1)
    end
end)
