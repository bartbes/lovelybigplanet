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
	game.map.Objects.player._body:setAllowSleep(false)
	center = {}
	center.x = love.graphics.getWidth()/2
	center.y = love.graphics.getHeight()/2
	game.allowjump = true
	game.activelayer = 1
	game.layers = 2
	game.finished = false
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
	game.worlds[1]:update(dt)
	game.worlds[2]:update(dt)
	getCamera():setOrigin(game.map.Objects.player._body:getX()-love.graphics.getWidth()/2, game.map.Objects.player._body:getY()-love.graphics.getHeight()/2)
	local x, y = game.map.Objects.player._body:getPosition()
	if math.floor(x+0.5) == game.map.Finish.x and math.floor(y+0.5) == game.map.Finish.y and game.map.Objects.player._position == game.map.Finish.position then
		game.finished = true
	end
	love.timer.sleep(15)
end

function game.draw()
	love.graphics.draw(game.map.Resources.background, center.x, center.y, 0, game.map.BackgroundScale.x/150, (game.map.BackgroundScale.y or game.map.BackgroundScale.x)/150)
	game.map:drawBackgroundObjects()
	game.map:drawForegroundObjects()
	setCamera(cameras.hud)
	drawhud()
	setCamera(cameras.default)
end

function game.collision(a, b, coll)
	lastcollision = {a, b}
	if a == "player" or b == "player" then
		game.allowjump = true
	end
end

function game.keypressed(key)
	if key == love.key_down then
		game.activelayer = game.activelayer + 1
		if game.activelayer > game.layers then
			game.activelayer = 1
		end
		local tempplayer = game.map.Objects.player
		local velx, vely = tempplayer._body:getVelocity()
		local spin = tempplayer._body:getSpin()
		game.map.Objects.player = loadobject("player", "player", game.worlds[game.activelayer], tempplayer._body:getX(), tempplayer._body:getY(), tempplayer._body:getAngle(), game.activelayer)
		tempplayer._body:destroy()
		tempplayer = nil
		game.map.Objects.player._body:setVelocity(velx, vely)
		game.map.Objects.player._body:setSpin(spin)
	end
end
