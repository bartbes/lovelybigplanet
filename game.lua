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
	game.worlds[1]:update(dt)
	game.worlds[2]:update(dt)
end

function game.draw()
	love.graphics.draw(game.map.Resources.background, center.x, center.y)
	game.map:drawBackgroundObjects()
	game.map:drawForegroundObjects()
end

function game.keypressed(key)
	game.map.Objects.player.keypressed(key)
end

function game.keyreleased(key)
	game.map.Objects.player.keyreleased(key)
end