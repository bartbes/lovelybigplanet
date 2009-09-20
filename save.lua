save = {}

local savedatamockup = [[
width = %d
height = %d
fullscreen = %s
]]

function save.createsave(onend, ...)
	local f = love.filesystem.newFile("savegame.dat")
	f:open(love.file_write)
	f:write(savedatamockup:format(love.graphics.getWindowWidth(), love.graphics.getWindowHeight(), tostring(mainmenu.fullscreen)))
	f:close()
end

function save.loadsave()
	local savedata = {}
	local f = love.filesystem.load("savegame.dat")
	setfenv(f, savedata)()
	return savedata
end

