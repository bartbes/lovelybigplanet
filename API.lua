LBP = {}

function LBP.showScore(show)
	hud.score = show
end

function LBP.setLvl1(f)
	if type(f) ~= "function" then f = false end
	hud.lvl1 = f
end

function LBP.setLvl2(f)
	if type(f) ~= "function" then f = false end
	hud.lvl2 = f
end

function LBP.draw(object)
	love.graphics.draw(object.Resources.texture, object._body:getX(), object._body:getY(), object._body:getAngle(), object.TextureScale.x/150, (object.TextureScale.y or object.TextureScale.x)/150)
end
