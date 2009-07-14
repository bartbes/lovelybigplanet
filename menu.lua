menu = {}
menu.state = false
menu.options = { 'Resume', 'Save', 'Load', 'Settings', 'Credits', 'Quit' }
menu.bwidth = 64
menu.bheight = 16
menu.selectedbutton = 1

--Unless you absolutely must, don't touch this file -SnakeFace

function menu.load()
	update = menu.update
	menu.state = true
end

function menu.cleanup()
	update = game.update
	menu.state = false
end

function menu.draw()
	if menu.state then
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
		if i == menu.selectedbutton then
			menu.drawbutton(menu.options[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), true)
		else
			menu.drawbutton(menu.options[i], width/2-menu.bwidth/2, height/2-12-my/2+i*(menu.bheight+4), false)
			end
		end
		setCamera(cameras.default)
		love.graphics.setColor(prevcolor)
	end
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
	if key == love.key_down then
		if menu.selectedbutton < #menu.options then
		menu.selectedbutton = menu.selectedbutton + 1
		elseif menu.selectedbutton >= #menu.options then
		menu.selectedbutton = 1
	end
end
	if key == love.key_return then
	if menu.options[menu.selectedbutton] == 'Resume' then menu.cleanup() end
	if menu.options[menu.selectedbutton] == 'Save' then menu.cleanup() end
	if menu.options[menu.selectedbutton] == 'Load' then menu.cleanup() end
	if menu.options[menu.selectedbutton] == 'Settings' then menu.cleanup() end
	if menu.options[menu.selectedbutton] == 'Credits' then menu.cleanup() end
	if menu.options[menu.selectedbutton] == 'Quit' then menu.cleanup() end
	end
	if key == love.key_up then
		if menu.selectedbutton <= #menu.options and menu.selectedbutton > 1 then
		menu.selectedbutton = menu.selectedbutton - 1
		elseif menu.selectedbutton <= 1 then
		menu.selectedbutton = #menu.options
	end
	end
end
