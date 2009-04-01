function load()
	love.graphics.setFont(love.default_font)
	local mods = love.filesystem.enumerate("mods")
	for i, v in ipairs(mods) do
		love.filesystem.require('mods/'..v)
	end
end

function loadobject(name)
	if not love.filesystem.exists("objects/" .. name .. ".lua") then return false, "File " .. name .. ".lua doesn't exist" end
	local f = love.filesystem.load("objects/" .. name .. ".lua")
	local env = {}
	env.OBJECT = {}
	setfenv(f, env)
	f()
	Objects[env.OBJECT.identifier or #objects+1] = env.OBJECT
	for i, v in pairs(env.OBJECT.Resources) do
		env.OBJECT.Resources[i] = assert(loadresource(v))
	end
	return true, env.OBJECT.identifier or #objects
end

function loadresource(name)
	local ftype = ""
	local fext = ""
	if love.filesystem.exists("resources/" .. name .. ".jpg") then ftype = "image"; fext = ".jpg" end
	if love.filesystem.exists("resources/" .. name .. ".png") then ftype = "image"; fext = ".png" end
	if ftype == "" or fext == "" then return false, "Resource " .. name .. " not found." end
	if ftype == "image" then
		return true, love.graphics.newImage("resources/" .. name .. fext)
	end
end

function draw()
	love.graphics.draw("LovelyBigPlanet.. work in progress", 5, 300)
end

