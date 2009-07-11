LBP = {}

function LBP.draw(object)
	love.graphics.draw(object.Resources.texture, object._body:getX(), object._body:getY(), object._body:getAngle(), object.TextureScale.x/150, (object.TextureScale.y or object.TextureScale.x)/150)
end
