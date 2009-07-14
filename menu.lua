menu = {}
menu.state = false
menu.options = { 'Resume', 'Save', 'Load', 'Settings', 'Credits', 'Quit' }
menu.settingsoptions = { 'Resume', 'Quit'  }
menu.bwidth = 64
menu.bheight = 16
menu.mainselectedbutton = 1
menu.settingsselectedbutton = 1

--Unless you absolutely must, don't touch this file -SnakeFace

function menu.load()
	update = menu.update
	menu.state = "main"
end

function menu.cleanup()
	update = game.update
	menu.state = false
end

function menu.draw()
	if menu.state == "main" then
		setCamera(cameras.hud)
		local numoptions = #menu.options
		local height = love.graphics.getHeight()
		local width = love.graphics.getWidth()
		local prevcolor = love.graphics.getColor()
		love.graphics.setColor(175, 175, 50)
		local mw = menu.bwidth+12
		local my = numoptions*menu.bheight+32
		love.graphics.rectangle(2, width/2-mw/2, height/2-my/2, mw, my)
		for i = 1, numoptions do
		if i == menu.mainselectedbutton then
			menu.drawbutton(menu.options[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), true)
		else
			menu.drawbutton(menu.options[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), false)
			end
		end
		love.graphics.setColor(prevcolor)
	end
	if menu.state == "save" then
		setCamera(cameras.hud)
		local height = love.graphics.getHeight()
		local width = love.graphics.getWidth()
		local prevcolor = love.graphics.getColor()
		love.graphics.setColor(175, 175, 50)
		love.graphics.rectangle(2, width/2-50, height/2-50, 100, 100)
		love.graphics.setColor(25, 25, 25)
		love.graphics.draw("Game saving not supported yet", width/2 + 25, height/2 + 25)
		love.graphics.setColor(prevcolor)
	end
	if menu.state == "load" then
		setCamera(cameras.hud)
		local height = love.graphics.getHeight()
		local width = love.graphics.getWidth()
		local prevcolor = love.graphics.getColor()
		love.graphics.setColor(175, 175, 50)
		love.graphics.rectangle(2, width/2-50, height/2-50, 100, 100)
		love.graphics.setColor(25, 25, 25)
		love.graphics.draw("Game loading not supported yet", width/2 + 25, height/2 + 25)
		love.graphics.setColor(prevcolor)
	end
	if menu.state == "settings" then
		setCamera(cameras.hud)
		local numoptions = #menu.settingsoptions
		local height = love.graphics.getHeight()
		local width = love.graphics.getWidth()
		local prevcolor = love.graphics.getColor()
		love.graphics.setColor(175, 175, 50)
		local mw = menu.bwidth+12
		local my = numoptions*menu.bheight+32
		love.graphics.rectangle(2, width/2-mw/2, height/2-my/2, mw, my)
		for i = 1, numoptions do
		if i == menu.settingsselectedbutton then
			menu.drawbutton(menu.settingsoptions[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), true)
		else
			menu.drawbutton(menu.settingsoptions[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), false)
			end
		end
		love.graphics.setColor(prevcolor)
	end
	if menu.state == "credits" then
		setCamera(cameras.hud)
		local height = love.graphics.getHeight()
		local width = love.graphics.getWidth()
		local prevcolor = love.graphics.getColor()
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
		love.graphics.setColor(prevcolor)
	end
		setCamera(cameras.default)
end
function menu.drawbutton(str, x, y, selected)
	local prevcolorb = love.graphics.getColor()
	love.graphics.setColor(125, 125, 10)
	love.graphics.rectangle(1, x, y, menu.bwidth, menu.bheight)
if selected then
	love.graphics.setColor(255, 255, 255)
else
	love.graphics.setColor(25, 25, 25)
end
	love.graphics.draw(str, x+2, y+12)
	love.graphics.setColor(prevcolorb)
end

function menu.update(dt)
end

function menu.keypressed(key)
if menu.state == 'main' then
	if key == love.key_down then
		if menu.mainselectedbutton < #menu.options then
		menu.mainselectedbutton = menu.mainselectedbutton + 1
		elseif menu.mainselectedbutton >= #menu.options then
		menu.mainselectedbutton = 1
	end
end
	if key == love.key_up then
		if menu.mainselectedbutton <= #menu.options and menu.mainselectedbutton > 1 then
		menu.mainselectedbutton = menu.mainselectedbutton - 1
		elseif menu.mainselectedbutton <= 1 then
		menu.mainselectedbutton = #menu.options
	end
end
end
if menu.state == 'settings' then
	if key == love.key_down then
		if menu.settingsselectedbutton < #menu.settingsoptions then
		menu.settingsselectedbutton = menu.settingsselectedbutton + 1
		elseif menu.settingsselectedbutton >= #menu.settingsoptions then
		menu.settingsselectedbutton = 1
	end
end
	if key == love.key_up then
		if menu.settingsselectedbutton <= #menu.settingsoptions and menu.settingsselectedbutton > 1 then
		menu.settingsselectedbutton = menu.settingsselectedbutton - 1
		elseif menu.settingsselectedbutton <= 1 then
		menu.settingsselectedbutton = #menu.settingsoptions
	end
end
end
	if key == love.key_return then
	if menu.state == 'save' then menu.cleanup() end
	if menu.state == 'load' then menu.cleanup() end
	if menu.state == 'credits' then menu.cleanup() end
	if menu.state == 'main' and menu.options[menu.mainselectedbutton] == 'Resume' then menu.cleanup() end
	if menu.state == 'main' and menu.options[menu.mainselectedbutton] == 'Quit' then love.system.exit() end
	if menu.state == 'main' and menu.options[menu.mainselectedbutton] == 'Save' then menu.state = 'save' end
	if menu.state == 'main' and menu.options[menu.mainselectedbutton] == 'Load' then menu.state = 'load' end
	if menu.state == 'main' and menu.options[menu.mainselectedbutton] == 'Settings' then menu.state = 'settings' end
	if menu.state == 'main' and menu.options[menu.mainselectedbutton] == 'Credits' then menu.state = 'credits' end
	end
end
