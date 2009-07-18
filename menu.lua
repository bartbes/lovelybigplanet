menu = {} --master table
menu.state = false --menu.state defines what menu or submenu is shown ( see: menu.draw() )
menu.options = { main = { "Resume", "Restart", "Save", "Load", "Settings", "Credits", "Quit" },
                 settings = { "Resume", "Fullscreen", "Resolution"  },
				 res = { {x = 640, y = 360}, {x = 800, y = 600}, {x = 1024, y = 700}, {x = 1280, y = 720}, {x = 1680, y = 1050} },
				 load = {} }  --defines the options per menu
menu.bwidth = 64 --width of a menu button
menu.bheight = 16 --height of a menu button
menu.selectedbutton = {main = 1, settings = 1, load = 1} --the number of the selected button per menu
menu.selectedres = 1 --the selected resolutions id
local arrowlimage = love.graphics.newImage("resources/arrowl.png")
local arrowrimage = love.graphics.newImage("resources/arrowr.png")

function menu.load() --hooks the menu in and 'pauses' the game
	update = menu.update
	menu.state = "main"
end

function menu.cleanup() --reinstates normal game function and removes menu, DO NOT JUST CALL menu.state = false to remove the menu, call menu.cleanup()
	update = game.update
	menu.state = false
end

function menu.draw() --decides what state to draw, then draws it
	setCamera(cameras.hud)
	local height = love.graphics.getHeight()
	local width = love.graphics.getWidth()
	local prevcolor = love.graphics.getColor()
	if menu.state == "main" then
		local numoptions = #menu.options.main
		local mw = menu.bwidth+12
		local my = numoptions*menu.bheight+40
		love.graphics.setColor(105, 105, 20)
		love.graphics.rectangle(2, width/2-mw/2-5, height/2-my/2-5, mw+10, my+10)
		love.graphics.setColor(175, 175, 50)
		love.graphics.rectangle(2, width/2-mw/2, height/2-my/2, mw, my)
		for i = 1, numoptions do
			if i == menu.selectedbutton.main then
				menu.drawbutton(menu.options.main[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), true, 0, true)
			else
				menu.drawbutton(menu.options.main[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), false, 0, true)
			end
		end
	end
	if menu.state == "save" then
		local height = love.graphics.getHeight()
		local width = love.graphics.getWidth()
		local prevcolor = love.graphics.getColor()
		love.graphics.setColor(105, 105, 20)
		love.graphics.rectangle(2, width/2-55, height/2-35, 310, 70)
		love.graphics.setColor(175, 175, 50)
		love.graphics.rectangle(2, width/2-50, height/2-30, 300, 60)
		love.graphics.setColor(25, 25, 25)
		love.graphics.draw("Saving is not yet supported", width/2 - 45, height/2)
	end
	if menu.state == "load" then
		--[[love.graphics.setColor(105, 105, 20)
		love.graphics.rectangle(2, width/2-55, height/2-35, 310, 70)
		love.graphics.setColor(175, 175, 50)
		love.graphics.rectangle(2, width/2-50, height/2-30, 300, 60)
		love.graphics.setColor(25, 25, 25)
		love.graphics.draw("Loading is not yet supported", width/2 - 45, height/2)]]
		local numoptions = #menu.options.load
		local mw = menu.bwidth+12
		local my = numoptions*menu.bheight+40
		love.graphics.setColor(105, 105, 20)
		love.graphics.rectangle(2, width/2-mw/2-5, height/2-my/2-5, mw+10, my+10)
		love.graphics.setColor(175, 175, 50)
		love.graphics.rectangle(2, width/2-mw/2, height/2-my/2, mw, my)
		for i = 1, numoptions do
			if i == menu.selectedbutton.load then
				menu.drawbutton(menu.options.load[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), true, 0, true)
			else
				menu.drawbutton(menu.options.load[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), false, 0, true)
			end
		end

	end
	if menu.state == "settings" then
		local numoptions = #menu.options.settings
		local mw = menu.bwidth+8
		local my = numoptions*menu.bheight+32
		love.graphics.setColor(105, 105, 20)
		love.graphics.rectangle(2, width/2-mw/2-5, height/2-my/2-5, mw+18, my+20)
		love.graphics.setColor(175, 175, 50)
		love.graphics.rectangle(2, width/2-mw/2, height/2-my/2, mw+8, my+10)
		for i = 1, numoptions + 1 do
			if i <= numoptions then
				if i == menu.selectedbutton.settings then
					menu.drawbutton(menu.options.settings[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), true, 2, true, 66)
				else
					menu.drawbutton(menu.options.settings[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), false, 2, true, 66)
				end
			end
			if i > numoptions then 
				menu.drawbutton(menu.options.res[menu.selectedres].x .. "x" .. menu.options.res[menu.selectedres].y, width/2-menu.bwidth/2+2, height/2-12-my/2+i*(menu.bheight+4), false, 2, false, 66)
			end
		end
		love.graphics.draw(arrowlimage, width/2-mw/2+4, height/2+my/2-3)
		love.graphics.draw(arrowrimage, width/2+mw/2+2, height/2+my/2-3)
	end
	if menu.state == "credits" then
		love.graphics.setColor(105, 105, 20)
		love.graphics.rectangle(2, width/2-55, height/2-65, 310, 130)
		love.graphics.setColor(175, 175, 50)
		love.graphics.rectangle(2, width/2-50, height/2-60, 300, 120)
		love.graphics.setColor(25, 25, 25)
		love.graphics.draw("Bartbes - General coding", width/2 - 45, height/2 - 45)
		love.graphics.draw("Qubodup - Artwork", width/2 - 45, height/2 - 30)
		love.graphics.draw("Osgeld - Editor & artwork", width/2 - 45, height/2 - 15)
		love.graphics.draw("Xcmd - Ideas & testing", width/2 - 45, height/2)
		love.graphics.draw("Appleide - Testing", width/2 - 45, height/2 + 15)
		love.graphics.draw("Robin - Physics, editor & testing", width/2 - 45, height/2 + 30)
		love.graphics.draw("SnakeFace - General coding & artwork", width/2 - 45, height/2 + 45)
	end
	love.graphics.setColor(prevcolor) --retains original colouring for game elements
	setCamera(cameras.default) --makes sure the game behind the menu is properly drawn
end

function menu.drawbutton(str, x, y, selected, ep, border, width) --draws the buttons in the menu. args: string to display, xpos, ypos, if button is selected option, extra padding incase of options being too large, whether or not to draw the border, width of button to draw(default is menu.bwidth)
	local prevcolorb = love.graphics.getColor()
	love.graphics.setColor(125, 125, 10)
	width = width or menu.bwidth
	if border and width then love.graphics.rectangle(1, x, y, width + ep, menu.bheight) end
	if selected then
		love.graphics.setColor(255, 255, 255)
	else
		love.graphics.setColor(25, 25, 25)
	end
	love.graphics.draw(str, x+2, y+12)
	love.graphics.setColor(prevcolorb)
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
	if menu.state == "settings" and menu.options.settings[menu.selectedbutton.settings] == "Resolution" then
		if key == love.key_left then
			menu.selectedres = menu.selectedres - 1
			if menu.selectedres < 1 then
				menu.selectedres = #menu.options.res
			end
		end
		if key == love.key_right then
			menu.selectedres = menu.selectedres + 1
			if menu.selectedres > #menu.options.res then
				menu.selectedres = 1
			end
		end
	end
	if key == love.key_return then
		if menu.state == "save" then menu.cleanup()
		elseif menu.state == "load" then menu.cleanup(); startgame(menu.options.load[menu.selectedbutton.load])
		elseif menu.state == "credits" then menu.cleanup()
		elseif menu.state == "settings" then
			if menu.options.settings[menu.selectedbutton.settings] == "Resolution" then love.graphics.setMode(menu.options.res[menu.selectedres].x, menu.options.res[menu.selectedres].y, false, true, 0)
				local aspectratio = love.graphics.getWidth()/love.graphics.getHeight()
				cameras.default = camera.stretchToResolution(15*aspectratio, 15)
				setCamera(cameras.default)
				cameras.default:setScreenOrigin(0, 1)
				cameras.default:scaleBy(1, -1)
			elseif menu.options.settings[menu.selectedbutton.settings] == "Fullscreen" then love.graphics.toggleFullscreen()
			elseif menu.options.settings[menu.selectedbutton.settings] == "Resume" then menu.cleanup()
			end
		elseif menu.state == "main" then
			if menu.options.main[menu.selectedbutton.main] == "Resume" then menu.cleanup()
			elseif menu.options.main[menu.selectedbutton.main] == "Quit" then love.system.exit()
			elseif menu.options.main[menu.selectedbutton.main] == "Restart" then love.system.restart()
			elseif menu.options.main[menu.selectedbutton.main] == "Save" then menu.state = "save"
			elseif menu.options.main[menu.selectedbutton.main] == "Load" then prepareload() ; menu.state = "load"
			elseif menu.options.main[menu.selectedbutton.main] == "Settings" then menu.state = "settings"
			elseif menu.options.main[menu.selectedbutton.main] == "Credits" then menu.state = "credits"
			end
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
