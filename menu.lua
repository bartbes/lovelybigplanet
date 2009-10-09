menu = {} --master table
menu.state = false --menu.state defines what menu or submenu is shown ( see: menu.draw() )
menu.options = { "Resume", "Restart", "Main menu", "Quit" }
menu.bheight = 16 --height of a menu button
menu.selectedbutton = 1 --the number of the selected button

function menu.load() --hooks the menu in and 'pauses' the game
	love.update = menu.update
	menu.selectedbutton = 1
	menu.bary = camera.love.graphics.getHeight()/2-(#menu.options*menu.bheight+25)/2+menu.selectedbutton*(menu.bheight+4)
	menu.state = "main"
end

function menu.cleanup() --reinstates normal game function and removes menu, DO NOT JUST CALL menu.state = false to remove the menu, call menu.cleanup()
	love.update = game.update
	menu.state = false
end

function menu.draw() --decides what state to draw, then draws it
	if menu.state == "main" then
		setCamera(cameras.hud)
		local height = love.graphics.getHeight()
		local width = love.graphics.getWidth()
		local prevcolor = {love.graphics.getColor()}
		local numoptions = #menu.options
		local my = numoptions*menu.bheight+25
		--love.graphics.setColor(105, 105, 20)
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle(love.draw_fill, 0, height/2-my/2-5, width, my+10)
		love.graphics.setColor(0, 0, 0)
		for i = 1, numoptions do
			love.graphics.print(menu.options[i], width/3, height/2-my/2+i*(menu.bheight+4))
		end
		love.graphics.setColor(0,255,0)
		love.graphics.line(0, menu.bary-13, width, menu.bary-13)
		love.graphics.line(0, menu.bary+5, width, menu.bary+5)
		love.graphics.setColor(0,255,0,50)
		love.graphics.rectangle(love.draw_fill, 0, menu.bary-13, width, 20)
		love.graphics.setColor(unpack(prevcolor)) --retains original colouring for game elements
	end
	setCamera(cameras.default) --makes sure the game behind the menu is properly drawn
end

function menu.update(dt) --deprecated in use, but just to be on the safe side ;)
	menu.bary = menu.bary + (camera.love.graphics.getHeight()/2-(#menu.options*menu.bheight+25)/2+menu.selectedbutton*(menu.bheight+4)-menu.bary)*dt*4
	love.timer.sleep(20)
end

function menu.keypressed(key) --catches all keypresses and changes the menu display accordingly. This one is quite hard to read unless you understand the way states work :/
	if not menu.state then return false end --if we are not in the menu, return
	if menu.options then --only works for states with options
		if key == love.key_down then
			if menu.selectedbutton < #menu.options then
				menu.selectedbutton = menu.selectedbutton + 1
			else
				menu.selectedbutton = 1
			end
		end
		if key == love.key_up then
			if menu.selectedbutton > 1 then
				menu.selectedbutton = menu.selectedbutton - 1
			else
				menu.selectedbutton = #menu.options
			end
		end
	end
	if key == love.key_return then
		if menu.options[menu.selectedbutton] == "Resume" then menu.cleanup()
		elseif menu.options[menu.selectedbutton] == "Quit" then quitgame()
		elseif menu.options[menu.selectedbutton] == "Main menu" then menu.cleanup(); mainmenu.load()
		elseif menu.options[menu.selectedbutton] == "Restart" then menu.cleanup(); startgame(game.map._name)
		end
	end
	return true --we were in the menu, return true, the game won't parse the keypress any further
end
