mapClass = {}
function mapClass.new()
	local t = {}
	setmetatable(t, {__index=mapClass})
	return t
end

function mapClass:add(object)
	self.Objects[#self.Objects+1] = assert(loadobject(#self.Objects+1, object[1], game.world, object[2], object[3], object[4], object[5]))
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
			local translucent = not active(v._shapes[1])
			if translucent then love.graphics.setColor(100, 100, 100, 150) end
			LBP.draw(v)
			if translucent then love.graphics.setColor(255, 255, 255, 255) end
		end
	end
end
