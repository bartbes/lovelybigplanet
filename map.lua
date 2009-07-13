mapClass = {}
function mapClass.new()
	local t = {}
	setmetatable(t, {__index=mapClass})
	return t
end

function mapClass:drawLayer(layer)
	for k, v in pairs(self.Objects) do
		if v._shapes[1]:getCategory() == layer then
			if game.activelayer ~= layer then love.graphics.setColor(100, 100, 100, 150) end
			LBP.draw(v)
			if game.activelayer ~= layer then love.graphics.setColor(255, 255, 255, 255) end
		end
	end
end
