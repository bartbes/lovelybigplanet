menu = {}
menu.state = false
menu.options = { 'Resume', 'Save', 'Load', 'Settings', 'Quit' }
menu.bwidth = 64
menu.bheight = 16

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
		love.graphics.setColor(175, 175, 50)
		local mw = menu.bwidth+12
		local my = numoptions*menu.bheight+32
		love.graphics.rectangle(1, width/2-mw/2, height/2-my/2, mw, my)
		for i = 1, numoptions do
			menu.drawbutton(menu.options[i], width/2-menu.bwidth/2, height/2-my/2+i*menu.bheight)
		end
		setCamera(cameras.default)
	end
end

function menu.drawbutton(str, x, y)
	love.graphics.rectangle(1, x, y, menu.bwidth, menu.bheight)
	love.graphics.draw(str, x+2, y+12)
end

function menu.update(dt)
end
