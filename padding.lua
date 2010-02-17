do
	local nwimage = love.graphics.newImage
	function love.graphics.newImage(source)
		if type(source) == 'string' then
			source = love.image.newImageData(source)
		end
		
		local w, h = source:getWidth(), source:getHeight()

		-- Find closest power-of-two.
		local wp = math.pow(2, math.ceil(math.log(w)/math.log(2)))
		local hp = math.pow(2, math.ceil(math.log(h)/math.log(2)))

		-- Only pad if needed:
		if wp ~= w or hp ~= h then
			local padded = love.image.newImageData(wp, hp)
			padded:paste(source, 0, 0)
			return nwimage(padded)
		end
		
		return nwimage(source)
	end
end