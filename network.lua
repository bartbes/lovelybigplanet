local socket = require "socket"

local server = "uapps.org" 	--a shell server I have access to thanks to thelinx
local port = 8371			--this should be the final port

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
		if not (a and b and c and d) then return 0 end
		length = d + c * 256 + b * 65536 + a * 16777216
		return length
	end
end

network.extract = extract

local function packmessage(type, data)
	local length = data:len()
	length = string.char(math.floor(length/16777216), math.floor((length%16777216)/65536), math.floor((length%65536)/256), length%256)
	return type .. length .. data .. "\n"
end

network.packmessage = packmessage

local function unpackmessage(data)
	local type = extract(data, "type")
	local length = extract(data, "length")
	local data = data:sub(9, 9+length)
	return type, length, data
end

network.unpackmessage = unpackmessage

function network:connect()
	if self.socket then
		return true
	end
	self.socket = socket.tcp()
	if not self.socket then return false end
	self.socket:settimeout(5)
	log("Connecting to server: " .. server .. ":" .. port)
	self.socket:connect(server, port)
	self.socket:settimeout(0)
	return true
end

function network:disconnect()
	if not self.socket then
		return true
	end
	self.socket:close()
	self.socket = nil
	log("Closed connection to server")
	return true
end

function network:getlist(t)
	if not self.socket then
		return false, "Not connected"
	end
	if not t then
		return false, "No data"
	end
	self.socket:send(packmessage("list", t))
	return true
end

function network:getfile(f)
	if not self.socket then
		return false, "Not connected"
	end
	if not f then
		return false, "No data"
	end
	self.socket:send(packmessage("rqst", f))
	return true
end

function network:getinfo(s)
	if not self.socket then
		return false, "Not connected"
	end
	if not s then
		return false, "No data"
	end
	self.socket:send(packmessage("info", s))
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
	local data = self.socket:receive(8)
	if not data then return end
	data = data .. (self.socket:receive(extract(data, "length") or 0) or "")
	if self.callback then
		self.callback(unpackmessage(data))
	end
end
