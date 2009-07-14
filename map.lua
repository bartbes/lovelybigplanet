mapClass = {}
function mapClass.new()
	local t = {}
	setmetatable(t, {__index=mapClass})
	return t
end

local function inCategory(shape, layer)
	local categories = {shape:getCategory()}
	for i, v in ipairs(categories) do
		if v == layer then
			return true
		end
	end
	return false
end

local function active(shape)
	return inCategory(shape, game.activelayer)
end

function mapClass:drawLayer(layer)
	for k, v in pairs(self.Objects) do
		if inCategory(v._shapes[1], layer) then
			if not active(v._shapes[1]) then love.graphics.setColor(100, 100, 100, 150) end
			LBP.draw(v)
			if not active(v._shapes[1]) then love.graphics.setColor(255, 255, 255, 255) end
		end
	end
end
