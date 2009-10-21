download = {message = '', active = false, progress = 0, cor = nil}

local request = [[
GET %s HTTP/1.0
Host: %s


]]

local function dodownload(progress, url)
	local sock = socket.tcp()
	local host = url:match("([%w%.]+)")
	local port = url:match("[%w%.]+:(%d+)") or 80
	local page = url:match("(/.*)$")
	local file = page:match("/(.+)$") or ""
	sock:connect(host, port)
	coroutine.yield(url)
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
	local data = ""
	local errmsg, part
	while progress ~= 100 do
		line, errmsg, part = sock:receive(128)
		if not line then
			line = part
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
	sock:close()
	return false, progress
end

function download.load(url)
	download.progress = 0
	download.active = true
	download.cor = coroutine.create(dodownload)
	local err
	err, download.message = coroutine.resume(download.cor, 0, url)
	if not err then
		download.active = false
	end
end

function download.update(dt)
	success, busy, download.progress = assert(coroutine.resume(download.cor, download.progress))
	if not busy or not success then
		--finished, do something here
		download.active = false
	end
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
	love.graphics.setLineWidth(1)
	love.graphics.setColor(255,255,255)
	setCamera(cameras.default)
end
