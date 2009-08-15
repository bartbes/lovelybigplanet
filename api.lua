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
	love.graphics.draw(object.Resources.texture, object._body:getX(), object._body:getY(), object._body:getAngle(), object.TextureScale.x/150, (object.TextureScale.y or object.TextureScale.x)/150)
	if dbg then
		for i,circle in ipairs(object.Circle or {}) do
			love.graphics.circle(love.draw_line, circle[1]+object._body:getX(), circle[2]+object._body:getY(), circle[3]) --very basic, very crude
		end
	end
end

function rLBP.addScore(pnt) --the function to add points to the score, as suggested by TechnoKat
	game.score = game.score + pnt
end

local mt = {}
function mt:__index(i)
	return rLBP[i]
end

function mt:__newindex(i, v)
	error("[GENERAL PROTECTION ERROR]:\nAPI OVERWRITE DETECTED\nACTION PROHIBITED")
end

setmetatable(LBP, mt)