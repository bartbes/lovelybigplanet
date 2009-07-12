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
	game.worlds[1]:setCallback(game.collision)
	game.worlds[2]:setCallback(game.collision)
	game.map = loadmap(map, game.worlds)
	center = {}
	center.x = love.graphics.getWidth()/2
	center.y = love.graphics.getHeight()/2
	game.allowjump = true
end

game = {}

function game.update(dt)
	local x, y = game.map.Objects.player._body:getVelocity()
	if love.keyboard.isDown(love.key_left) then
		x = -3
	end
	if love.keyboard.isDown(love.key_right) then
		x = 3
	end
	if love.keyboard.isDown(love.key_up) and game.allowjump then
		game.allowjump = false
		y = 5
	end
	game.map.Objects.player._body:setVelocity(x, y)
	game.worlds[1]:update(dt)
	game.worlds[2]:update(dt)
end

function game.draw()
	love.graphics.draw(game.map.Resources.background, center.x, center.y)
	game.map:drawBackgroundObjects()
	game.map:drawForegroundObjects()
end

function game.collision(a, b, coll)
	if a == "player" then
		game.allowjump = true
	end
end
