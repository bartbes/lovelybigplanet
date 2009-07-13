mapClass = {}
function mapClass.new()
	local t = {}
	setmetatable(t, {__index=mapClass})
	return t
end

function mapClass:drawBackgroundObjects()
	for k,v in pairs(self.Objects) do
		if v._position == 2 then
			if game.activelayer ~= 2 then love.graphics.setColor(100, 100, 100, 150) end
			LBP.draw(v)
			if game.activelayer ~= 2 then love.graphics.setColor(255, 255, 255, 255) end
		end
	end
end

function mapClass:drawForegroundObjects()
	for k,v in pairs(self.Objects) do
		if v._position == 1 then
			if game.activelayer ~= 1 then love.graphics.setColor(100, 100, 100, 150) end
			LBP.draw(v)
			if game.activelayer ~= 1 then love.graphics.setColor(255, 255, 255, 255) end
		end
	end
end
