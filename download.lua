download = {message = '', active = false, progress = 0, cor = nil}

local function dodownload(progress)
	while progress ~= 100 do
		progress = progress + love.timer.getDelta()*10
		if progress > 100 then progress = 100 end
		progress = coroutine.yield(true, progress, "Doing some fake stuff")
	end
	return false, 100, "Done"
end

function download.load()
	download.progress = 0
	download.active = true
	download.cor = coroutine.create(dodownload)
	download.oldupdate = love.update
	love.update = download.update
end

function download.update(dt)
	local success, busy
	success, busy, download.progress, download.message = coroutine.resume(download.cor, download.progress)
	if not busy then
		--finished, do something here
		download.active = false
		love.update = download.oldupdate
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
