mapClass = {}
function mapClass.new()
	local t = {}
	setmetatable(t, {__index=mapClass})
	return t
end

function mapClass:drawBackgroundObjects()
	for k,v in pairs(self.Objects) do
		if v.background then
			LBP.draw(v)
		end
	end
end

function mapClass:drawForegroundObjects()
	for k,v in pairs(self.Objects) do
		if not v.background then
			LBP.draw(v)
		end
	end
end
