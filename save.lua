save = {}

local originalkeypressed

function createsave(onend, ...)
	update = save.update
	draw = save.draw
	originalkeypressed = keypressed
	keypressed = save.keypressed
end

function loadsave()
	love.filesystem.require("savegame.dat")
end

function save.update(dt)
end

function save.draw()
end

function save.keypressed(key)
end
