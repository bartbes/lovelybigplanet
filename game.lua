function startgame(map)
	--following needs to be replaced by a state loader
	update = game.update
	draw = game.draw
	--ok, let's do the stuff we'd normally do in load
	game.world = love.physics.newWorld(love.graphics.getWidth() * 2, love.graphics.getHeight() * 2)
	game.world:setGravity(0, -9.81)
	game.world:setCallback(game.collision)
	game.map = loadmap(map, game.worlds)
	game.map.Objects.player._body:setAllowSleep(false)
	center = {}
	center.x = love.graphics.getWidth()/2
	center.y = love.graphics.getHeight()/2
	game.allowjump = true
	game.activelayer = 1
	game.layers = 2
	game.finished = false
	game.score = 0
end

game = {}

function game.update(dt)
	if dbg then game.allowjump = true end
	game.map.Objects.player._body:setSleep(false)
	local x, y = game.map.Objects.player._body:getVelocity()
	if love.keyboard.isDown(love.key_left) then
		x = -3.5
	end
	if love.keyboard.isDown(love.key_right) then
		x = 3.5
	end
	if love.keyboard.isDown(love.key_up) and game.allowjump then
		game.allowjump = false
		y = 5
	end
	game.map.Objects.player._body:setVelocity(x, y)
	local angle = game.map.Objects.player._body:getAngle()
	if angle > 80 then
		game.map.Objects.player._body:setAngle(0)
	elseif angle < -80 then
		game.map.Objects.player._body:setAngle(0)
	end
	game.world:update(dt)
	getCamera():setOrigin(game.map.Objects.player._body:getX()-love.graphics.getWidth()/2, game.map.Objects.player._body:getY()-love.graphics.getHeight()/2)
	local x, y = game.map.Objects.player._body:getPosition()
	if not game.finished and math.floor(x+0.5) == game.map.Finish.x and math.floor(y+0.5) == game.map.Finish.y and game.map.Objects.player._shapes[1]:getCategory() == game.map.Finish.position then
		game.finished = true
		game.score = game.score + 10000
		if game.map.finished then game.map.finished() end
	end
	love.timer.sleep(15)
end

function game.draw()
	love.graphics.draw(game.map.Resources.background, center.x, center.y, 0, game.map.BackgroundScale.x/150, (game.map.BackgroundScale.y or game.map.BackgroundScale.x)/150)
	for i = 1, game.layers do
		game.map:drawLayer(i)
	end
	hud.draw()
	menu.draw()
end

function game.collision(a, b, coll)
	lastcollision = {a, b}
	if a == "player" or b == "player" then
		game.allowjump = true
	end
end

function game.switchlayer(layer)
	game.activelayer = layer
	local pl = game.map.Objects.player
	local posses = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
	table.remove(posses, game.activelayer) -- oh god, this is awful
	for k,v in ipairs(pl._shapes) do
		v:setCategory(game.activelayer)
		v:setMask(unpack(posses))
	end
end

function game.keypressed(key)
menu.keypressed(key)
	if key == love.key_z then
		local layer = game.activelayer + 1
		if layer > game.layers then
			layer = 1
		end
		game.switchlayer(layer)
	elseif key == love.key_a then
		local layer = game.activelayer - 1
		if layer < 1 then
			layer = game.layers
		end
		game.switchlayer(layer)
	elseif key == love.key_1 or key == love.key_kp1 then
		if game.layers >= 1 then
			game.switchlayer(1)
		end
	elseif key == love.key_2 or key == love.key_kp2 then
		if game.layers >= 2 then
			game.switchlayer(2)
		end
	elseif key == love.key_3 or key == love.key_kp3 then
		if game.layers >= 3 then
			game.switchlayer(3)
		end
	elseif key == love.key_4 or key == love.key_kp4 then
		if game.layers >= 4 then
			game.switchlayer(4)
		end
	elseif key == love.key_5 or key == love.key_kp5 then
		if game.layers >= 5 then
			game.switchlayer(5)
		end
	elseif key == love.key_6 or key == love.key_kp6 then
		if game.layers >= 6 then
			game.switchlayer(6)
		end
	elseif key == love.key_7 or key == love.key_kp7 then
		if game.layers >= 7 then
			game.switchlayer(7)
		end
	elseif key == love.key_8 or key == love.key_kp8 then
		if game.layers >= 8 then
			game.switchlayer(8)
		end
	elseif key == love.key_9 or key == love.key_kp9 then
		if game.layers >= 9 then
			game.switchlayer(9)
		end
	end
end
