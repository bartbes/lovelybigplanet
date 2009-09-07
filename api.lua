LBP = {}
local rLBP = {}

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
	--local dst = ((object.Resources.texture.resource:getWidth()/2)^2+(object.Resources.texture.resource:getHeight()/2)^2)^.5
	local w = cameras.default:unscaleX(object.Resources.texture.resource:getWidth()/2)
	local h = cameras.default:unscaleY(object.Resources.texture.resource:getHeight()/2)
	local xcomp = w * math.cos(object._body:getAngle()) + h * math.cos(object._body:getAngle()+.5*math.pi)
	local ycomp = h * math.cos(object._body:getAngle()) + w * math.cos(object._body:getAngle()+.5*math.pi)
	love.graphics.draw(object.Resources.texture.resource, object._body:getX()-xcomp, object._body:getY()-ycomp, object._body:getAngle(), object.TextureScale.x/150, (object.TextureScale.y or object.TextureScale.x)/150, object.Resources.texture.resource:getWidth()/2, object.Resources.texture.resource:getHeight()/2)
	love.graphics.circle(love.draw_fill, object._body:getX(), object._body:getY(), .1)
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
