LBP = {}

function LBP.draw(object)
	love.graphics.draw(object.Resources.texture, object._body:getX(), object._body:getY())
end
