download = {message = '', active = false, progress = 0, cor = nil}

local request = [[
GET %s HTTP/1.0
Host: %s


]]

local function dodownload(progress, url, filename)
	local sock = socket.tcp()
	local port = 80
	local scheme = url:match("^(%w+)://") or "http"
	if scheme == "http" then
		port = 80
	elseif scheme == "lbp" then
		port = 8372
	end
	url = url:sub(#scheme+4)
	local host = url:match("([%w%.]+)")
	port = url:match("[%w%.]+:(%d+)") or port
	sock:connect(host, port)
	coroutine.yield(scheme .. "://" .. url)
	local data = ""
	if scheme == "http" then
		local page = url:match("(/.*)$")
		local file = page:match("/(.+)$") or ""
		local totalsize
		local line
		sock:send(request:format(page, host))
		while true do
			line = sock:receive("*l")
			if line == "" then
				progress = coroutine.yield(true, 0)
				break
			end
			totalsize = line:match("Content%-Length: (%d+)") or totalsize
			progress = coroutine.yield(true, 0)
		end
		local bytesreceived = 0
		local errmsg, part
		while progress ~= 100 do
			line, errmsg, part = sock:receive(2048)
			if not line then
				line = part
				if not line then line = "" end
				part = true
			end
			data = data .. line
			bytesreceived = #data
			if totalsize then
				progress = (bytesreceived/totalsize)*100
			else
				progress = 50
			end
			progress = coroutine.yield(true, progress)
			if part then break end
		end
	elseif scheme == "lbp" then
		local fileID = url:match("/(.+)[\n]*$")
		local msg = network.packmessage("file", fileID)
		sock:send(msg)
		local msg = sock:receive(8)
		log(msg)
		local totalsize = network.extract(msg, "length")
		log(totalsize)
		local line, errmsg, part, bytesreceived
		while progress ~= 100 do
			line, errmsg, part = sock:receive(2048)
			log(line)
			if not line then
				line = part
				if not line then line = "" end
				part = true
			end
			msg = msg .. line
			bytesreceived = #msg
			progress = (bytesreceived/totalsize)*100
			progress = coroutine.yield(true, progress)
			if part then break end
		end
		local t, l, d = network.unpackmessage(msg)
		l = network.extract(d, "length")
		d = d:sub(l+7)
		t, l, data = network.unpackmessage(d)
	end
	sock:close()
	local f = love.filesystem.newFile(filename)
	f:open("w")
	f:write(data)
	f:close()
	return false, progress
end

function download.load(url, filename, cb)
	download.progress = 0
	download.active = true
	download.cor = coroutine.create(dodownload)
	download.cb = cb
	download.url = url
	download.filename = filename
	local err
	err, download.message = coroutine.resume(download.cor, 0, url, filename)
	if not err then
		download.active = false
	end
	download.oldupdate = love.update
	love.update = download.update
end

function download.update(dt)
	success, busy, download.progress = assert(coroutine.resume(download.cor, download.progress))
	if not busy or not success then
		--finished, do something here
		download.active = false
		love.update = download.oldupdate
		if download.cb then
			download.cb(download.url, download.filename)
		end
	end
	love.timer.sleep(15)
end

dtest = download.load

local fnt = love.graphics.newFont(love._vera_ttf, 20)
local fnt_msg_width = fnt:getWidth("Downloading...")/2
local fnt_height = fnt:getHeight()

function download.draw()
	setCamera(cameras.hud)
	love.graphics.setLineWidth(2)
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("fill", w/2 - 320, h/2 - 120, 640, 240)
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("line", w/2 - 320, h/2 - 120, 640, 240)
	love.graphics.setColor(0,0,0)
	local ofnt = love.graphics.getFont()
	love.graphics.setFont(fnt)
	love.graphics.print("Downloading...", w/2 - fnt_msg_width, h/2 - 100 + fnt_height)
	love.graphics.print(download.message, w/2 - fnt:getWidth(download.message)/2, h/2 - 80 + fnt_height*2)
	love.graphics.setFont(ofnt)
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("line", w/2 - 300, h/2 + 60, 600, 40)
	local posx = w/2 - 300 + download.progress*6
	love.graphics.line(posx, h/2 + 60, posx, h/2 + 100)
	love.graphics.setColor(0,255,0,50)
	love.graphics.rectangle("fill", w/2 - 300, h/2 + 60, download.progress*6, 40)
	love.graphics.setColor(255,255,255)
	setCamera(cameras.default)
end
