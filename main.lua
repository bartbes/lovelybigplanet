love.filesystem.require("camera.lua")
love.filesystem.require("API.lua")
love.filesystem.require("game.lua")
love.filesystem.require("map.lua")

do
	local aspectratio = love.graphics.getWidth()/love.graphics.getHeight()
	setCamera(camera.stretchToResolution(15*aspectratio, 15))
	getCamera():setScreenOrigin(0, 1)
	getCamera():scaleBy(1, -1)
end

function load()
	love.graphics.setFont(love.default_font)
	local mods = love.filesystem.enumerate("mods")
	for i, v in ipairs(mods) do
		love.filesystem.require('mods/'..v)
	end
	startgame("testmap")
end

function loadmap(name, worlds)
	if not love.filesystem.exists("maps/" .. name .. ".lua") then return false, "FILE " .. name .. ".lua doesn't exist" end
	local f = love.filesystem.load("maps/" .. name .. ".lua")
	local env = {}
	env.MAP = mapClass.new()
	env.LBP = LBP
	env.Foreground = 1
	env.Background = 2
	setfenv(f, env)
	f()
	for i, v in pairs(env.MAP.Objects) do
		env.MAP.Objects[i] = assert(loadobject(v[1], worlds[v[5]], v[2], v[3], v[4], v[5]))
	end
	for i, v in pairs(env.MAP.Resources) do
		env.MAP.Resources[i] = assert(loadresource(v))
	end
	return env.MAP
end

function loadobject(name, world, x, y, angle, position)
	if not love.filesystem.exists("objects/" .. name .. ".lua") then return false, "File " .. name .. ".lua doesn't exist" end
	local f = love.filesystem.load("objects/" .. name .. ".lua")
	local env = {}
	env.OBJECT = {}
	env.LBP = LBP
	setfenv(f, env)
	f()
	for i, v in pairs(env.OBJECT.Resources) do
		env.OBJECT.Resources[i] = assert(loadresource(v))
	end
	env.OBJECT._body = love.physics.newBody(world, x, y, 0)--, env.OBJECT.Weight)
	env.OBJECT._body:setAngle(angle)
	env.OBJECT._shapes = {}
	env.OBJECT._position = position
	for i, v in ipairs(env.OBJECT.Polygon) do
		table.insert(env.OBJECT._shapes, love.physics.newPolygonShape(env.OBJECT._body, unpack(v)))
		env.OBJECT._shapes[#env.OBJECT._shapes]:setData(name)
	end
	if env.OBJECT.Weight ~= 0 then
		env.OBJECT._body:setMassFromShapes()
		env.OBJECT._body:setAngularDamping(50)
	end
	return env.OBJECT
end

function loadresource(name)
	local ftype = ""
	local fext = ""
	if love.filesystem.exists("resources/" .. name .. ".jpg") then ftype = "image"; fext = ".jpg" end
	if love.filesystem.exists("resources/" .. name .. ".png") then ftype = "image"; fext = ".png" end
	if ftype == "" or fext == "" then return false, "Resource " .. name .. " not found." end
	if ftype == "image" then
		return love.graphics.newImage("resources/" .. name .. fext)
	end
	return false, "Resource " .. name .. " not found."
end

function draw()
	love.graphics.draw("LovelyBigPlanet.. work in progress", 5, 300)
end

function update(dt)
	game.update(dt)
end

--camera.lateInit()
