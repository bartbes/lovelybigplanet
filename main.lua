love.filesystem.require("camera.lua")
love.filesystem.require("api.lua")
love.filesystem.require("game.lua")
love.filesystem.require("map.lua")
love.filesystem.require("hud.lua")
love.filesystem.require("menu.lua")
love.filesystem.require("save.lua")

dbg = false
resources = {}

--create the cameras
cameras = {}
cameras.hud = camera.new()

--in a do-end structure for the local, we do not want to pollute the global environment
do
	local aspectratio = love.graphics.getWidth()/love.graphics.getHeight()
	cameras.default = camera.stretchToResolution(15*aspectratio, 15)
	setCamera(cameras.default)
	cameras.default:setScreenOrigin(0, 1)
	cameras.default:scaleBy(1, -1)
end

function load()
	--set it up, font, mods, colormode, level
	love.graphics.setFont(love.default_font)
	local mods = love.filesystem.enumerate("mods")
	for i, v in ipairs(mods) do
		love.filesystem.require('mods/'..v)
	end
	love.graphics.setColorMode(love.color_modulate)
	if love.filesystem.exists("savegame.dat") then
		loadsave()
	--else
		--return createsave(startgame, "testmap")
	end
	startgame("testmap")
end

--here it comes, the magic
function loadmap(name, worlds)
	if not love.filesystem.exists("maps/" .. name .. ".lua") then return false, "FILE " .. name .. ".lua doesn't exist" end
	local f = love.filesystem.load("maps/" .. name .. ".lua")
	local env = {}
	--we'll create an environment, sandboxing, remember?
	--default drawing functions
	env.MAP = mapClass.new()
	--API
	env.LBP = LBP
	--constants
	env.Foreground = 1
	env.Background = 2
	--set and run
	setfenv(f, env)
	f()
	--load all needed Objects and Resources
	for i, v in pairs(env.MAP.Objects) do
		env.MAP.Objects[i] = assert(loadobject(i, v[1], game.world, v[2], v[3], v[4], v[5]))
	end
	for i, v in pairs(env.MAP.Resources) do
		env.MAP.Resources[i] = assert(loadresource(v))
	end
	env.MAP._name = name
	return env.MAP
end

function loadobject(internalname, name, world, x, y, angle, positions)
	if not love.filesystem.exists("objects/" .. name .. ".lua") then return false, "File " .. name .. ".lua doesn't exist" end
	local f = love.filesystem.load("objects/" .. name .. ".lua")
	local env = {key_left = love.key_left, key_right = love.key_right, key_up = love.key_up, print=print}
	env.OBJECT = {}
	env.LBP = LBP
	--environment is set up, apply and execute
	setfenv(f, env)
	f()
	--load Resources
	for i, v in pairs(env.OBJECT.Resources) do
		env.OBJECT.Resources[i] = assert(loadresource(v))
	end
	--create and set a physics entity
	env.OBJECT._body = love.physics.newBody(world, x, y, 0)--, env.OBJECT.Weight)
	env.OBJECT._body:setAngle(angle)
	env.OBJECT._shapes = {}
	env.OBJECT._positions = positions
	--create the shapes, data is set to the internal name (what the map calls them)
	--category is the layers it's in, mask is what it collides with (or what it doesn't
	--collide with actually)
	for i, v in ipairs(env.OBJECT.Polygon or {}) do
		table.insert(env.OBJECT._shapes, love.physics.newPolygonShape(env.OBJECT._body, unpack(v)))
	end
	for i, v in ipairs(env.OBJECT.Circle or {}) do
		table.insert(env.OBJECT._shapes, love.physics.newCircleShape(env.OBJECT._body, unpack(v)))
	end
	for i, v in ipairs(env.OBJECT.Rectangle or {}) do
		table.insert(env.OBJECT._shapes, love.physics.newRectangleShape(env.OBJECT._body, unpack(v)))
	end
	local posses = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
	for i, v2 in ipairs(positions) do
		table.remove(posses, v2-i+1) -- oh god, this is awful
	end
	for i, v in ipairs(env.OBJECT._shapes) do
		v:setData(internalname)
		v:setCategory(unpack(positions))
		v:setMask(unpack(posses))
	end
	--if it's not static, calculate mass, set angular damping, we do not want things
	--to roll too much
	if not env.OBJECT.Static then
		env.OBJECT._body:setMassFromShapes()
		env.OBJECT._body:setAngularDamping(35)
	end
	--layers need WAY more angular damping
	if name == "player" then
		env.OBJECT._body:setAngularDamping(150)
	end
	return env.OBJECT
end

function loadresource(name)
	if resources[name] then return resources[name] end
	local ftype = ""
	local fext = ""
	if love.filesystem.exists("resources/" .. name .. ".jpg") then ftype = "image"; fext = ".jpg" end
	if love.filesystem.exists("resources/" .. name .. ".png") then ftype = "image"; fext = ".png" end
	--did we find a Resource?
	if ftype == "" or fext == "" then return false, "Resource " .. name .. " not found." end
	--if it's an image, load and return it
	if ftype == "image" then
		resources[name] = love.graphics.newImage("resources/" .. name .. fext)
		return resources[name]
	end
	--FAIL!
	return false, "Resource " .. name .. " not found."
end

function draw()
	--temporary, is overwritten
	love.graphics.draw("LovelyBigPlanet.. work in progress", 5, 300)
end

function update(dt)
	--again, overwritten
	game.update(dt)
	love.timer.sleep(25)
end

function keypressed(key)
	--check some global keys first, if they're not used, pass it on
	if key == love.key_q then
		love.system.exit()
	elseif key == love.key_d and love.keyboard.isDown(love.key_lalt) and love.keyboard.isDown(love.key_lshift) then
		dbg = not dbg
	elseif key == love.key_escape then
		if menu.state then
			menu.cleanup()
		else
			menu.load()
		end
	else
		game.keypressed(key)
	end
end

--camera.lateInit()
