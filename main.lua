function load()
	love.graphics.setFont(love.default_font)
	local mods = love.filesystem.enumerate("mods")
	for i, v in ipairs(mods) do
		love.filesystem.require(v)
	end
end

function draw()
	love.graphics.draw("LovelyBigPlanet.. work in progress", 5, 300)
end

