function startgame(map)
	--following needs to be replaced by a state loader
	update = game.update
	draw = game.draw
	--ok, let's do the stuff we'd normally do in load
	game.world = love.physics.newWorld(love.graphics.getWidth() * 2, love.graphics.getHeight() * 2) --shouldn't we use CAMERA?
	game.world:setGravity(0, 9.81)
	game.map = loadmap(map, game.world)
	center = {}
	center.x = love.graphics.getWidth()/2
	center.y = love.graphics.getHeight()/2
end

game = {}

function game.update(dt)
	game.world:update(dt)
end

function game.draw()
	love.graphics.draw(game.map.Resources.background, center.x, center.y)
	game.map:drawBackgroundObjects()
	game.map:drawForegroundObjects()
end

