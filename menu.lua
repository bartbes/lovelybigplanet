menu = {} --master table
menu.state = false --menu.state defines what menu or submenu is shown ( see: menu.draw() )
menu.options = { main = { "Resume", "Restart", "Main menu", "Quit" },
				 --res = { {x = 640, y = 360}, {x = 800, y = 600}, {x = 1024, y = 700}, {x = 1280, y = 720}, {x = 1680, y = 1050} },
				 load = {} }  --defines the options per menu
menu.bwidth = 64 --width of a menu button
menu.bheight = 16 --height of a menu button
menu.selectedbutton = {main = 1, settings = 1, load = 1} --the number of the selected button per menu
menu.selectedres = 1 --the selected resolutions id
local arrowlimage = love.graphics.newImage("resources/snakeface/arrowl.png")
local arrowrimage = love.graphics.newImage("resources/snakeface/arrowr.png")

function menu.load() --hooks the menu in and 'pauses' the game
	love.update = menu.update
	menu.state = "main"
end

function menu.cleanup() --reinstates normal game function and removes menu, DO NOT JUST CALL menu.state = false to remove the menu, call menu.cleanup()
	love.update = game.update
	menu.state = false
end

function menu.draw() --decides what state to draw, then draws it
	setCamera(cameras.hud)
	local height = love.graphics.getHeight()
	local width = love.graphics.getWidth()
	local prevcolor = {love.graphics.getColor()}
	if menu.state == "main" then
		local numoptions = #menu.options.main
		local mw = menu.bwidth+12
		local my = numoptions*menu.bheight+25
		love.graphics.setColor(105, 105, 20)
		love.graphics.rectangle(2, width/2-mw/2-10, height/2-my/2-5, mw+20, my+10)
		love.graphics.setColor(175, 175, 50)
		love.graphics.rectangle(2, width/2-mw/2-5, height/2-my/2, mw+10, my)
		for i = 1, numoptions do
			if i == menu.selectedbutton.main then
				menu.drawbutton(menu.options.main[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), true, 0, true)
			else
				menu.drawbutton(menu.options.main[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), false, 0, true)
			end
		end
	end
	love.graphics.setColor(unpack(prevcolor)) --retains original colouring for game elements
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
end

function menu.keypressed(key) --catches all keypresses and changes the menu display accordingly. This one is quite hard to read unless you understand the way states work :/
	if not menu.state then return false end --if we are not in the menu, return
	if menu.options[menu.state] then --only works for states with options
		if key == love.key_down then
			if menu.selectedbutton[menu.state] < #menu.options[menu.state] then
				menu.selectedbutton[menu.state] = menu.selectedbutton[menu.state] + 1
			else
				menu.selectedbutton[menu.state] = 1
			end
		end
		if key == love.key_up then
			if menu.selectedbutton[menu.state] > 1 then
				menu.selectedbutton[menu.state] = menu.selectedbutton[menu.state] - 1
			else
				menu.selectedbutton[menu.state] = #menu.options[menu.state]
			end
		end
	end
	if key == love.key_return then
		if menu.options.main[menu.selectedbutton.main] == "Resume" then menu.cleanup()
		elseif menu.options.main[menu.selectedbutton.main] == "Quit" then love.event.quit()
		elseif menu.options.main[menu.selectedbutton.main] == "Main menu" then menu.cleanup(); mainmenu.load()
		elseif menu.options.main[menu.selectedbutton.main] == "Restart" then menu.cleanup(); startgame(game.map._name)
		end
	end
	return true --we were in the menu, return true, the game won't parse the keypress any further
end

function prepareload() -- or, more correctly: prepare the list of games that can be loaded
	menu.options.load = {}
	local maps = love.filesystem.enumerate("maps")
	for i, v in ipairs(maps) do
		menu.options.load[i] = string.sub(v, 1, -5)
	end
end
