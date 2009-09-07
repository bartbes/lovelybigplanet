--require("editor.lua")
editor = { update = function() end, mousepressed = function() end, mousereleased = function() end, keypressed = function() end, keyreleased = function() end }
LoveUI = {}
require("camera.lua")
require("api.lua")
require("game.lua")
require("map.lua")
require("hud.lua")
require("menu.lua")
require("save.lua")

dbg = false
resources = {}

--create the cameras
cameras = {}
cameras.hud = camera.new()
cameras.editor = camera.new()

--in a do-end structure for the local, we do not want to pollute the global environment
do
	local aspectratio = love.graphics.getWidth()/love.graphics.getHeight()
	cameras.default = camera.stretchToResolution(10*aspectratio, 10)
	setCamera(cameras.default)
	cameras.default:setScreenOrigin(0, 1)
	cameras.default:scaleBy(1, -1)
end

function love.load()
	--set it up, mods, colormode, level
	local mods = love.filesystem.enumerate("mods")
	for i, v in ipairs(mods) do
		if v:sub(-4, -1) == "lua" then
			require('mods/'..v)
		end
	end
	love.graphics.setColorMode(love.color_modulate)
	if love.filesystem.exists("savegame.dat") then
		loadsave()
	--else
		--return createsave(startgame, "testmap")
	end
	local njoysticks = love.joystick.getNumJoysticks()
	if njoysticks == 0 then
		activejoystick = 0
	elseif njoysticks > 0 then
		--this needs to be replaced, this doesn't work
		--you need to be able to choose the joystick here
		activejoystick = 0
	end
	love.graphics.setFont(love._vera_ttf, 12)
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
	env.deg2rad = math.rad
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
	local env = {print=print}
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
	env.OBJECT._body = love.physics.newBody(world, x, y, 0, 0)--, env.OBJECT.Weight)
	env.OBJECT._body:setAngle(angle)
	env.OBJECT._shapes = {}
	env.OBJECT._positions = positions
	env.OBJECT._name = name
	env.OBJECT._internalname = internalname
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

function loadobjectlite(name)
	if not love.filesystem.exists("objects/" .. name .. ".lua") then return false, "File " .. name .. ".lua doesn't exist" end
	local f = love.filesystem.load("objects/" .. name .. ".lua")
	local env = {print=print}
	env.OBJECT = {}
	env.LBP = LBP
	--environment is set up, apply and execute
	setfenv(f, env)
	f()
	--load Resources
	for i, v in pairs(env.OBJECT.Resources) do
		env.OBJECT.Resources[i] = assert(loadresource(v))
	end
	env.OBJECT._name = name
	env.OBJECT._lite = true
	return env.OBJECT
end


function loadresource(name)
	if resources[name] then return resources[name] end
	local ftype = ""
	local fext = ""
	if love.filesystem.exists("resources/" .. name .. ".jpg") then ftype = "image"; fext = ".jpg" end
	if love.filesystem.exists("resources/" .. name .. ".png") then ftype = "image"; fext = ".png" end
	if love.filesystem.exists("resources/" .. name .. ".mp3") then ftype = "music"; fext = ".png" end
	if love.filesystem.exists("resources/" .. name .. ".ogg") then ftype = "music"; fext = ".ogg" end
	--did we find a Resource?
	if ftype == "" or fext == "" then return false, "Resource " .. name .. " not found." end
	--if it's an image, load and return it
	if ftype == "image" then
		resources[name] = {name = name, resource = love.graphics.newImage("resources/" .. name .. fext)}
		return resources[name]
	elseif ftype == "music" then
		resources[name] = {name = name, music = love.audio.newMusic("resources/" .. name .. fext)}
		resources[name].resource = love.audio.newSource(resources[name].music)
		resources[name].resource:setLooping(true)
		return resources[name]
	end
	--FAIL!
	return false, "Resource " .. name .. " not found."
end

function rtos(resources)
	local s = "{\n"
	for i, v in pairs(resources) do
		s = s .. string.format("\t%s = \"%s\", \n", i, v.name)
	end
	s = s .. "}"
	return s
end

function otos(objects)
	local s = "{\n"
	for i, v in pairs(objects) do
		if type(i) == "number" then
			s = s .. "\t[" .. i .. "] = { "
		else
			s = s .. "\t" .. i .. " = { "
		end
		s = s .. string.format("\"%s\", %f, %f, %f, { ", v._name, v._body:getX(), v._body:getY(), v._body:getAngle())
		for j, w in ipairs{v._shapes[1]:getCategory()} do
			s = s .. w .. ", "
		end
		s = s .. "} }, \n"
	end
	s  = s .. "}"
	return s
end

function generatemap(filename)
	if not love.filesystem.exists("PLACEHOLDER") then
		local f = love.filesystem.newFile("PLACEHOLDER", love.file_write)
		love.filesystem.open(f)
		love.filesystem.close(f)
		love.filesystem.mkdir("maps")
	end
	local f = love.filesystem.newFile("maps/" .. filename .. ".lua", love.file_write)
	love.filesystem.open(f)
	local data = string.format(
[[
MAP.Name = "%s"
MAP.Creator = "%s"
MAP.Version = "%s"
MAP.Resources = %s
MAP.BackgroundScale = { x = %f, y = %f }
MAP.Objects = %s
MAP.Finish = { x = %f, y = %f, position = %d }
MAP.Mission = "%s"
]],
		game.map.Name,
		game.map.Creator,
		game.map.Version,
		rtos(game.map.Resources),
		game.map.BackgroundScale.x or 1,
		game.map.BackgroundScale.y or game.map.BackgroundScale.x or 1,
		otos(game.map.Objects),
		game.map.Finish.x,
		game.map.Finish.y,
		game.map.Finish.position,
		string.gsub(game.map.Mission, "\n", "\\n") or "")
	love.filesystem.write(f, data)
	love.filesystem.close(f)
end

function love.draw()
	--temporary, is overwritten
	love.graphics.print("LovelyBigPlanet.. work in progress", 5, 300)
end

function love.update(dt)
	--again, overwritten
	game.update(dt)
	love.timer.sleep(25)
end

function love.keypressed(key)
	--check some global keys first, if they're not used, pass it on
	if key == love.key_q and (not editor.active or editor.context.firstResponder.cellClass~=LoveUI.TextfieldCell) then
		return love.event.quit()
	elseif key == love.key_escape then
		if menu.state then
			menu.cleanup()
		else
			menu.load()
		end
	elseif key == love.key_e and (not editor.active or editor.context.firstResponder.cellClass~=LoveUI.TextfieldCell) then
		editor.active = not editor.active
	else
		if key == love.key_d and love.keyboard.isDown(love.key_lalt) and love.keyboard.isDown(love.key_lshift) then
			dbg = not dbg
		else
			game.keypressed(key)
		end
		if editor.active then
			--if menu.keypressed(key) then return end
			editor.context:keyEvent(key, editor.context.keyDown)
			if editor.context.firstResponder.cellClass~=LoveUI.TextfieldCell then
				if key == love.key_m then
					editor.default_action = editor.popup_move
				elseif key == love.key_r then
					editor.default_action = editor.popup_rot
				elseif key == love.key_l then
					editor.default_action = editor.popup_place
				elseif key == love.key_d then
					editor.default_action = editor.popup_del
				end
			end
		end
	end
end

function love.keyreleased(key)
	if editor.active then
		editor.context:keyEvent(key, editor.context.keyUp)
	end
end

function love.joystickpressed(j, button)
	game.joystickpressed(j, button)
end

function getobjat(x, y)
	for k, v in pairs(game.map.Objects) do
		for K, V in ipairs(v._shapes) do
			if V:testPoint(x, y) then
				return k
			end
		end
	end
end

function love.mousepressed(x, y, button)
	editor.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	editor.mousereleased(x, y, button)
end
 
--camera.lateInit()
--editor.cursorobject=loadobjectlite("player")
--editor.cursortexture=editor.cursorobject.Resources.texture
