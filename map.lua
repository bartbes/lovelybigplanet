mapClass = {}
function mapClass.new()
	local t = {}
	setmetatable(t, {__index=mapClass})
	return t
end

function mapClass:drawBackgroundObjects()
	for k,v in pairs(self.Objects) do
		if v._position == 2 then
			love.graphics.setColor(200, 200, 200, 220)
			LBP.draw(v)
			love.graphics.setColor(255, 255, 255, 255)
		end
	end
end

function mapClass:drawForegroundObjects()
	for k,v in pairs(self.Objects) do
		if v._position == 1 then
			LBP.draw(v)
		end
	end
end
