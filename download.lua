download = {}

local function dodownload(progress)
	while progress ~= 100 do
		progress = progress + love.timer.getDelta()
		if progress > 100 then progress = 100 end
		progress = coroutine.yield(true, progress)
	end
	return false, 100
end

function download.load()
	progress = 0
	coroutine.create(dodownload)
end

function download.update(dt)
	success, busy, progress = coroutine.resume(dld, progress)
	if not busy then
		--finished, do something here
	end
end

function download.draw()
end
