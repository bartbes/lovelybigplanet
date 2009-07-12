function startgame(map)
	--following needs to be replaced by a state loader
	update = game.update
	draw = game.draw
	--ok, let's do the stuff we'd normally do in load
	game.worlds = {}
	game.worlds[1] = love.physics.newWorld(love.graphics.getWidth() * 2, love.graphics.getHeight() * 2)
	game.worlds[2] = love.physics.newWorld(love.graphics.getWidth() * 2, love.graphics.getHeight() * 2)
	game.worlds[1]:setGravity(0, -9.81)
	game.worlds[2]:setGravity(0, -9.81)
	game.map = loadmap(map, game.worlds)
	center = {}
	center.x = love.graphics.getWidth()/2
	center.y = love.graphics.getHeight()/2
end

game = {}

function game.update(dt)
	if love.keyboard.isDown(love.key_left) then
		game.map.Objects.player._body:setVelocity(-3, 0)
	end
	if love.keyboard.isDown(love.key_right) then
		game.map.Objects.player._body:setVelocity(3, 0)
	end
	if love.keyboard.isDown(love.key_up) then
		game.map.Objects.player._body:setVelocity(game.map.Objects.player._body:getVelocity(), 5)
	end
	game.worlds[1]:update(dt)
	game.worlds[2]:update(dt)
end

function game.draw()
	love.graphics.draw(game.map.Resources.background, center.x, center.y)
	game.map:drawBackgroundObjects()
	game.map:drawForegroundObjects()
end
