local socket = require "socket"

local server = "127.0.0.1"
local port = 9000

network = {}

local function extract(data, what)
	if what == "type" then
		local type = data:sub(1, 4)
		return type
	elseif what == "length" then
		local length = data:sub(5, 8)
		local a = length:byte(1)
		local b = length:byte(2)
		local c = length:byte(3)
		local d = length:byte(4)
		length = d + c * 256 + b * 65536 + a * 16777216
		return length
	end
end

local function packmessage(type, data)
	local length = data:len()
	length = string.char(math.floor(length/16777216), math.floor((length%16777216)/65536), math.floor((length%65536)/256), length%256)
	return type .. length .. data .. "\n"
end

local function unpackmessage(data)
	local type = extract(data, "type")
	local length = extract(data, "length")
	local data = data:sub(9, 9+length)
	return type, length, data
end

function network:connect()
	if self.socket then
		return true
	end
	self.socket = socket.tcp()
	if not self.socket then return false end
	self.socket:settimeout(0)
	self.socket:connect(server, port)
	return true
end

function network:disconnect()
	if not self.socket then
		return true
	end
	self.socket:close()
	return true
end

function network:getlist(t)
	if not self.socket then
		return false, "Not connected"
	end
	self.socket:send(packmessage("list", t))
	return true
end

function network:getfile(f)
	if not self.socket then
		return false, "Not connected"
	end
	self.socket:send(packmessage("rqst", f))
	return true
end

function network:uncsv(s)
	local t = {}
	for s in s:gmatch("[^^]+") do
		table.insert(t, s)
	end
	return t
end

function network:setcallback(cb)
	self.callback = cb
end

function network:update()
	local data = self.socket:receive()
	if data and self.callback then
		self.callback(unpackmessage(data))
	end
end
