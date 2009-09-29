function startgame(map, noplay)
	mainmenu.unload()
	hud.score = false
	hud.lvl1 = false
	hud.lvl2 = false
	--following needs to be replaced by a state loader
	--[[love.update = game.update
	love.draw = game.draw]]
	--ok, let's do the stuff we'd normally do in load
	--we create a world, set gravity, the collision callback, and load the map
	game.world = love.physics.newWorld(love.graphics.getWidth() * 2 * 30, love.graphics.getHeight() * 2 * 30)
	game.world:setMeter(1)
	game.world:setGravity(0, -9.81)
	game.world:setCallbacks(game.collision)
	game.map = loadmap(map, game.worlds)
	--the player can't sleep, but this doesn't seem to help, weird..
	game.map.Objects.player._body:setAllowSleeping(false)
	center = {}
	center.x = love.graphics.getWidth()/2
	center.y = love.graphics.getHeight()/2
	--some variables which need to be initialized
	game.allowjump = true
	game.activelayer = 1
	game.layers = 2
	game.finished = false
	game.score = 0
	editor.mapstarted()
	getCamera():setOrigin(game.map.Objects.player._body:getX()-love.graphics.getWidth()/2, game.map.Objects.player._body:getY()-love.graphics.getHeight()/2)
	if game.map.Mission and not noplay then LBP.messageBox(game.map.Mission) end
	if game.map.Resources.ambiance and not noplay then LBP.play(game.map.Resources.ambiance, true) end
	LBP.showScore(game.map.ShowScore)
	if game.map.init then game.map.init() end
end

game = {}

function game.update(dt)
	console:update()
	if editor.active then
		editor.context:update(dt)
		local x, y = love.mouse.getPosition( )
		if editor.rotatemode then
			local o = game.map.Objects[editor.selectedobject]
			local ox, oy = cameras.default:pos(o._body:getX(), o._body:getY())
			o._body:setAngle(math.atan2(x-ox, y-oy))
		else
			if x < 40 then
				local g = getCamera()
				local ox, oy = g:getOrigin()
				g:setOrigin(ox - (40-x)/40, oy)
			elseif x > (camera.love.graphics.getWidth() - 40) then
				local g = getCamera()
				local ox, oy = g:getOrigin()
				g:setOrigin(ox + (x-camera.love.graphics.getWidth()+40)/40, oy)
			end
			if y < 40 and x > 562 then
				local g = getCamera()
				local ox, oy = g:getOrigin()
				g:setOrigin(ox, oy + (40-y)/40)
			elseif y > (camera.love.graphics.getHeight() - 40) then
				local g = getCamera()
				local ox, oy = g:getOrigin()
				g:setOrigin(ox, oy - (y-camera.love.graphics.getHeight()+40)/40)
			end
		end
		love.timer.sleep(15)
		return
	end
	--allow flying if we are debugging
	if dbg then game.allowjump = true end
	--FIX: setAllowSleep fails, do it manually
	game.map.Objects.player._body:wakeUp()
	--get the velocity, process the input, and set it, preserves untouched velocity..
	local x, y = game.map.Objects.player._body:getLinearVelocity()
	if activejoystick then
		local joyx = love.joystick.getAxis(activejoystick, love.joystick_axis_horizontal)
		if math.abs(joyx) >= 0.05 then
			x = joyx * 3.5
		end
		if love.joystick.getAxis(activejoystick, love.joystick_axis_vertical) <= -0.5 and game.allowjump then
			game.allowjump = false
			y = 5
		end
		if love.joystick.getAxis(activejoystick, love.joystick_axis_vertical) >= 0.5 and dbg then
			y = -7.5
		end
	end
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
	if love.keyboard.isDown(love.key_down) and dbg then
		y = - 7.5
	end
	game.map.Objects.player._body:setLinearVelocity(x, y)
	--players don't use their heads for walking
	local angle = game.map.Objects.player._body:getAngle()
	if angle > 1.35 then
		game.map.Objects.player._body:setAngle(0)
	elseif angle < -1.35 then
		game.map.Objects.player._body:setAngle(0)
	end
	--finally, we told Box2D what we want, produce some results..
	game.world:update(dt)
	--follow the player
	getCamera():setOrigin(game.map.Objects.player._body:getX()-love.graphics.getWidth()/2, game.map.Objects.player._body:getY()-love.graphics.getHeight()/2)
	--check if he finished, round the position first
	local x, y = game.map.Objects.player._body:getPosition()
	if not game.finished and math.floor(x+0.5) == game.map.Finish.x and math.floor(y+0.5) == game.map.Finish.y and game.map.Objects.player._shapes[1]:getCategory() == game.map.Finish.position and math.abs(select(2, game.map.Objects.player._body:getLinearVelocity())) < 0.01 then
		--is there a map callback, if so, call it
		if (game.map.finished and game.map.finished()) or (not game.map.finished) then
			game.finished = true
			game.score = game.score + 10000
		end
	end
	if x < -30 or x > 30 and y > 20 or y < -20 then
		startgame(game.map._name)
	end
	if game.map.update then game.map.update(dt) end
	--preserve some CPU, may need some tweaking when the engine becomes heavier
	love.timer.sleep(15)
end

function game.draw()
	--draw the background, of course
	love.graphics.draw(game.map.Resources.background.resource, center.x, center.y, 0, game.map.BackgroundScale.x/150, (game.map.BackgroundScale.y or game.map.BackgroundScale.x)/150)
	--ask the map to draw each layer, usually done using the standard functions
	game.map:drawLayers()
	--same goes for menu
	menu.draw()
	if editor.active then
		local sel
		if editor.selectedobject then
			sel = game.map.Objects[editor.selectedobject]
			love.graphics.setColor(100, 100, 255, 255)
			love.graphics.setBlendMode(love.blend_additive)
			LBP.draw(sel)
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.setBlendMode(love.blend_alpha)
		end
		setCamera(cameras.editor)
		if editor.selectedobject and sel
					--and editor.default_action == editor.popup_place
				then
			local x, y = cameras.default:pos(sel._body:getX(), sel._body:getY())
			local txt = "Layers: "..table.concat(sel._positions,", ")
			local f = love.graphics.getFont()
			local w, h = f:getWidth(txt), f:getHeight()
			love.graphics.setColor(0, 0, 0, 155)
			love.graphics.rectangle(love.draw_fill, x-w/2-5, y-h-30, w+10, h+5)
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.print(txt, x-w/2, y-30)
		end
		local x, y = love.mouse.getPosition( )
		if editor.cursortexture and editor.view_settings.hidden and (y > 52 or x > 460) and (editor.view_objects.hidden or (x < 370 or x > 480 or y > 42+42 * #editor.objectbuttons)) then
			love.graphics.setColor(255, 255, 255, 150)
			local a = editor.cursorobject._lite and 0 or -editor.cursorobject._body:getAngle()
			setCamera(cameras.default)
			local Px, Py = cameras.default:unpos(x, y)
			love.graphics.draw(editor.cursortexture.resource, Px, Py, a, editor.cursorobject.TextureScale.x/150, (editor.cursorobject.TextureScale.y or editor.cursorobject.TextureScale.x)/150)
			setCamera(cameras.hud)
			love.graphics.setColor(255, 255, 255, 255)
		end
		setCamera(cameras.hud)
		editor.context:display()
		if not editor.cursorobject then
			love.graphics.setColor(0, 0, 0, 155)
			local f = love.graphics.getFont()
			love.graphics.rectangle(love.draw_fill, 460, 10, f:getWidth(editor.default_action.value)+10, f:getHeight()+10)
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.print(editor.default_action.value, 465, 26)
		end
		setCamera(cameras.default)
	else
		--draw HUD
		hud.draw()
	end
end

function game.collision(a, b, coll)
	--did a player collide? if so, cue our nice lazy way of solving stuff
	--let the player jump! (allow it)
	if a == "player" or b == "player" then
		game.allowjump = true
	end
	if game.map.Objects[a].collision then game.map.Objects[a]:collision(b) end
	if game.map.Objects[b].collision then game.map.Objects[b]:collision(a) end
	if game.map.collision then game.map:collision(a, b) end
end

function game.switchlayer(layer)
	--we need to go to another layer, this is in a seperate function to prevent
	--code duplication, though the code which calls this is pretty similar every
	--time
	--courtesy of Robin, comments welcome
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
	if menu.keypressed(key) then return end
	if not editor.active or editor.context.firstResponder.cellClass~=LoveUI.TextfieldCell then
		if key == love.key_z then --z is switch to next layer
			game.switchlayer((game.activelayer % game.layers) + 1)
		elseif key == love.key_a then --a to previous
			game.switchlayer(((game.activelayer-2) % game.layers) + 1)
		--now we'll check for the number keys, if one is pressed, switch to appropriate
		--layer, if it exists.
		elseif key > love.key_0 and key <= love.key_9 then
			local l = key - love.key_0
			if game.layers >= l then
				game.switchlayer(l)
			end
		elseif key > love.key_kp0 and key <= love.key_kp9 then
			local l = key - love.key_kp0
			if game.layers >= l then
				game.switchlayer(l)
			end
		end
	end
end

function game.joystickpressed(j, button)
	if j ~= activejoystick then return end
	if button == 0 then
		game.switchlayer((game.activelayer % game.layers) + 1)
	elseif button == 1 then
		game.switchlayer(((game.activelayer-2) % game.layers) + 1)
	end
end
