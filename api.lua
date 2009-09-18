LBP = {}
local rLBP = {}

local replaceprops = {
	name = "_name",
	internalname = "_internalname",
	shapes = "_shapes",
	body = "_body",
}

local function propertylookup(prop)
	if replaceprops[prop] then
		prop = replaceprops[prop]
	end
	return prop
end

function rLBP.getProperty(object, property)
	if type(object) ~= "table" then
		object = game.map.Objects[object or 1]
	end
	if not object then
		return error("No object")
	end
	for s in property:gmatch("[^%.]+") do
		object = object[propertylookup(s)]
	end
	return object
end

function rLBP.setProperty(object, property, value)
	if type(object) ~= "table" then
		object = game.map.Objects[object or 1]
	end
	if not object then
		return error("No object")
	end
	local lasts
	for s in property:gmatch("[^%.]+") do
		if lasts then
			object = object[lasts]
		end
		lasts = propertylookup(s)
	end
	object[lasts] = value
end

function rLBP.showScore(show) --do we want to show the score?
	hud.score = show
end

function rLBP.setLvl1(f) --set what function to call to retrieve the lvl1 value, if any
	if type(f) ~= "function" then f = false end
	hud.lvl1 = f
end

function rLBP.setLvl2(f) --same goes for lvl2
	if type(f) ~= "function" then f = false end
	hud.lvl2 = f
end

function rLBP.messageBox(msg) --give me a messagebox NOW!
	if type(msg) ~= "string" then return end
	hud.messageBox(msg)
end

function rLBP.draw(object) --the generic draw function, only takes the object, extracts the rest from it, yay!
	--also, scales to 150 px/m (yes, we use meters!)
	love.graphics.draw(object.Resources.texture.resource, object._body:getX(), object._body:getY(), object._body:getAngle(), object.TextureScale.x/150, (object.TextureScale.y or object.TextureScale.x)/150, object.Resources.texture.resource:getWidth()/2, object.Resources.texture.resource:getHeight()/2)
end

function rLBP.play(music, loop)
	if loop then
		love.audio.play(music.resource)
	else
		love.audio.play(music.music)
	end
end

function rLBP.stop(music)
	love.audio.stop(music.resource)
end

function rLBP.setLooping(music, loop)
	bool = false
	if loop then bool = true end
	music.resource:setLooping(bool)
end

function rLBP.rewind(music)
	love.audio.rewind(music.resource)
end

function rLBP.addScore(pnt) --the function to add points to the score, as suggested by TechnoKat
	game.score = game.score + pnt
end

function rLBP.round(n) --round a number
	return math.floor(n+0.5)
end

local mt = {}
function mt:__index(i)
	return rLBP[i]
end

function mt:__newindex(i, v)
	error("[GENERAL PROTECTION ERROR]:\nAPI OVERWRITE DETECTED\nACTION PROHIBITED")
end

setmetatable(LBP, mt)
