menu = {} --master table
menu.state = false --menu.state defines what menu or submenu is shown ( see: menu.draw() )
menu.bary = -10
menu.options = { "Resume", "Restart", "Main menu", "Quit" }
menu.bheight = 16 --height of a menu button
menu.selectedbutton = 1 --the number of the selected button

function menu.load() --hooks the menu in and 'pauses' the game
	love.update = menu.update
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
		local mw = menu.bwidth+12
		local my = numoptions*menu.bheight+25
		--love.graphics.setColor(105, 105, 20)
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle(love.draw_fill, 0, height/2-my/2-5, width, my+10)
		love.graphics.setColor(0, 0, 0)
		for i = 1, numoptions do
			love.graphics.print(menu.options[i], width/2-menu.bwidth/2-2, height/2-my/2+i*(menu.bheight+4))
		end
		love.graphics.setColor(0,255,0)
		love.graphics.line(0, menu.bary-13, love.graphics.getWidth(), menu.bary-13)
		love.graphics.line(0, menu.bary+5, love.graphics.getWidth(), menu.bary+5)
		love.graphics.setColor(0,255,0,50)
		love.graphics.rectangle(love.draw_fill, 0, menu.bary-13, love.graphics.getWidth(), 20)
		love.graphics.setColor(unpack(prevcolor)) --retains original colouring for game elements
	end
	setCamera(cameras.default) --makes sure the game behind the menu is properly drawn
end

function menu.drawbutton(str, x, y, selected, ep, border, width) --draws the buttons in the menu. args: string to display, xpos, ypos, if button is selected option, extra padding incase of options being too large, whether or not to draw the border, width of button to draw(default is menu.bwidth)
	local prevcolorb = {love.graphics.getColor()}
	love.graphics.setColor(125, 125, 10)
	width = width or menu.bwidth
	if border and width then love.graphics.rectangle(1, x-5, y, width + ep + 10, menu.bheight) end
	if selected then
		love.graphics.setColor(255, 255, 255)
	else
		love.graphics.setColor(25, 25, 25)
	end
	love.graphics.print(str, x-2, y+12)
	love.graphics.setColor(unpack(prevcolorb))
end

function menu.update(dt) --deprecated in use, but just to be on the safe side ;)
	setCamera(cameras.hud)
	menu.bary = menu.bary + (love.graphics.getHeight()/2-(#menu.options*menu.bheight+25)/2+menu.selectedbutton*(menu.bheight+4)-menu.bary)*dt*4
	setCamera(cameras.default)
	love.timer.sleep(15)
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
