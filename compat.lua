if love._version == 060 then
	return
end

function load()
	love.load()
end

function update(dt)
	love.update(dt)
end

function draw()
	love.draw()
end

function keypressed(key)
	love.keypressed(key)
end

function keyreleased(key)
	love.keyreleased(key)
end

function mousepressed(x, y, button)
	love.mousepressed(x, y, button)
end

function mousereleased(x, y, button)
	love.mousereleased(x, y, button)
end

function love.graphics.print(...)
	love.graphics.draw(...)
end

love.graphics.setFont(love.default_font)
