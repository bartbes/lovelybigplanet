mainmenu = {
	options = {
			main = {'Start game', 'Start campaign', 'Start tutorial', 'Load game', 'Start editor', 'Settings', 'Exit'},
			settings = {'Back', 'Fullscreen', 'Screensize'}
			},
	actions = {
			main = {function () startgame'testmap' end, function () startgame'map1' end,
					function () startgame'testmap' end, function () end,
					function () end, function () mainmenu.start'settings' end,
					function () love.event.quit() end
					},
			settings = {function () mainmenu.start'main' end, function () end,
						function () end,
					}
			},
	itemx = 600,
	lines = 250,
	logox = -400,
	logodx = 50,
	state = 1,
	fadetime = .35,
	active = false,
	start = function (new,first)
		mainmenu.current = new
		mainmenu.ys = {}
		mainmenu.y_tos = {}
		for i,v in ipairs(mainmenu.options[new]) do
			mainmenu.ys[i] = -10
			mainmenu.y_tos[i] = i*20+180
		end
		mainmenu.selected = 1
		mainmenu.state = 1
		mainmenu.fadeoutcountdown = nil
		if first then
			mainmenu.fadeincountdown = nil
		else
			mainmenu.fadeincountdown = mainmenu.fadetime
		end
	end,}

function mainmenu.load ()
	mainmenu.start('main', true)
	love.graphics.setBackgroundColor(255, 255, 255)
	love.graphics.setLineWidth(2)
	mainmenu.active = true
	love.update = mainmenu.update
	love.draw = mainmenu.draw
end
function mainmenu.unload ()
	love.graphics.setBackgroundColor(0,0,0)
	love.graphics.setLineWidth(1)
	mainmenu.active = false
	love.update = game.update
	love.draw = game.draw
	setCamera(cameras.default)
end



function mainmenu.update (dt)
	if mainmenu.state == 1 then
		for i,v in ipairs(mainmenu.ys) do
			mainmenu.ys[i] = mainmenu.ys[i] + (mainmenu.y_tos[i]-mainmenu.ys[i])*dt*4
		end
		mainmenu.lines = mainmenu.lines + (mainmenu.ys[mainmenu.selected]-mainmenu.lines)*dt*4
		if mainmenu.fadeoutcountdown then
			mainmenu.fadeoutcountdown = mainmenu.fadeoutcountdown - dt
			if mainmenu.fadeoutcountdown < 0 then mainmenu.state = 2;mainmenu.actions[mainmenu.current][mainmenu.selected]() end
		end
		if mainmenu.fadeincountdown then
			mainmenu.fadeincountdown = mainmenu.fadeincountdown - dt
			if mainmenu.fadeincountdown < 0 then mainmenu.fadeincountdown=nil end
		end
		mainmenu.logox = mainmenu.logox + mainmenu.logodx*dt
		if mainmenu.logox > 180 and mainmenu.logodx > 0 then
			mainmenu.logodx = mainmenu.logodx*-.2
			if mainmenu.logodx > -30 then mainmenu.logodx = 0 end
		elseif mainmenu.logox < 50 then
			mainmenu.logodx = mainmenu.logodx + (50-mainmenu.logox)/10
		end
	end
end

function mainmenu.draw ()
	if mainmenu.state==1 then
		love.graphics.setColor(0,0,0)
		for i,v in ipairs(mainmenu.options[mainmenu.current]) do
			love.graphics.print(v, mainmenu.itemx, mainmenu.ys[i])
		end
		if mainmenu.current == 'main' then
			love.graphics.print("LovelyBigPlanet", mainmenu.logox, 100)
		end
		love.graphics.setColor(0,255,0)
		love.graphics.line(0, mainmenu.lines-13, love.graphics.getWidth(), mainmenu.lines-13)
		love.graphics.line(0, mainmenu.lines+5, love.graphics.getWidth(), mainmenu.lines+5)
		love.graphics.setColor(0,255,0,50)
		love.graphics.rectangle(love.draw_fill, 0, mainmenu.lines-13, love.graphics.getWidth(), 20)
		if mainmenu.fadeoutcountdown then
			love.graphics.setColor(255,255,255,255-(mainmenu.fadeoutcountdown/mainmenu.fadetime*255))
			love.graphics.rectangle(love.draw_fill, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		end
		if mainmenu.fadeincountdown then
			love.graphics.setColor(255,255,255,(mainmenu.fadeincountdown/mainmenu.fadetime*255))
			love.graphics.rectangle(love.draw_fill, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		end
		--?
	else
		love.graphics.print("Not yet implemented... press escape...", 100, 100)
	end
end

function mainmenu.keypressed(key)
	if mainmenu.state==1 then
		if key == love.key_up then
			mainmenu.selected = mainmenu.selected - 1
			if mainmenu.selected < 1 then mainmenu.selected = #mainmenu.options[mainmenu.current] end
		elseif key == love.key_down then
			mainmenu.selected = mainmenu.selected + 1
			if mainmenu.selected > #mainmenu.options[mainmenu.current] then mainmenu.selected = 1 end
		elseif key == love.key_return or key == love.key_space then
			mainmenu.y_tos = {-100, -100, -100, -100, -100, -100, -100}
			mainmenu.y_tos[mainmenu.selected] = mainmenu.ys[mainmenu.selected]
			mainmenu.fadeoutcountdown = mainmenu.fadetime
		end
	else
		if key==love.key_escape then
			mainmenu.start('main')
		end
	end
end
