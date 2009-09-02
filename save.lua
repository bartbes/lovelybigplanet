save = {}

local originalkeypressed
local originalupdate
local originaldraw

function createsave(onend, ...)
	originalupdate = love.update
	love.update = save.update
	originaldraw = love.draw
	love.draw = save.draw
	originalkeypressed = love.keypressed
	love.keypressed = save.keypressed
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
