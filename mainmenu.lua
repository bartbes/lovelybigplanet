function setRes(x, y)
	love.graphics.setMode(x, y, mainmenu.fullscreen, true, 0)
	local aspectratio = love.graphics.getWidth()/love.graphics.getHeight()
	cameras.default = camera.stretchToResolution(10*aspectratio, 10)
	cameras.default:setScreenOrigin(0, 1)
	cameras.default:scaleBy(1, -1)
	mainmenu.start'settings'
end
mainmenu = {
	options = {
			main = {'Start game', 'Start campaign', 'Start tutorial', 'Load game', 'Start editor', 'Settings', 'Credits', 'Exit'},
			settings = {'Back', 'Fullscreen', 'Screensize'},
			resolution = {'Back', '640x360', '800x600', '1024x700', '1280x720', '1680x1050' }
			},
	actions = {
			main = {function () startgame'testmap' end, function () startgame'map1' end,
					function () startgame'testmap' end, function () end,
					function () mainmenu.unload();startgame('newmap', true);editor.active=true end,
					function () mainmenu.start'settings' end,
					function () mainmenu.credits.start() end,
					function () love.event.quit() end
					},
			settings = {function () mainmenu.start'main' end, function () love.graphics.toggleFullscreen(); mainmenu.fullscreen = true; mainmenu.start'settings' end,
						function () mainmenu.start'resolution' end,
					},
			resolution = {function () mainmenu.start'settings' end,
							function () setRes(640,360) end, function () setRes(800,600) end,
							function () setRes(1024,700) end, function () setRes(1280,720) end, 
							function () setRes(1680,1050) end, 
					}
			},
	itemx = 600,
	logox = -400,
	logodx = 50,
	state = 1,
	fadetime = .35,
	active = false,
	start = function (new,first)
		mainmenu.current = new
		mainmenu.ys = {}
		mainmenu.y_tos = {}
		mainmenu.lines = 900
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
	end,
	credits = {
			names = {
					"Bartbes", "Project starter, general coding",
					"Robin", "Physics, editor, main menu & testing",
					"SnakeFace", "General coding & artwork",
					"Qubodup", "Artwork"
				},
			index = 0,
			x = 0,
			timeout = 0,
		start = function()
			mainmenu.credits.index = 0
			mainmenu.credits.x = love.graphics.getWidth()+10
			mainmenu.credits.timeout = 0
			mainmenu.state=3
			mainmenu.fadeincountdown = mainmenu.fadetime
			mainmenu.fadeoutcountdown = nil
		end
		},
	fullscreen = false
	}

function mainmenu.load ()
	setCamera(cameras.hud)
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
	elseif mainmenu.state==3 then
		--credits
		local c = mainmenu.credits
		local halfw = love.graphics.getWidth()*.5-50
		if c.timeout > 0 then
			c.timeout = c.timeout - dt
		else
			if c.x > halfw then
				c.x = c.x - ((c.x-halfw)*3.8+20)*dt
				if c.x < halfw then
					c.timeout = .1
				end
			else
				c.x = c.x - ((halfw-c.x)*3.8+20)*dt
				if c.x < -100 then
					c.index = c.index + 1
					if c.index*2+1 > #c.names then
						mainmenu.start'main'
					end
					c.x = halfw*2+110
					c.timeout = .1
				end
			end
		end
		if mainmenu.fadeoutcountdown then
			mainmenu.fadeoutcountdown = mainmenu.fadeoutcountdown - dt
			if mainmenu.fadeoutcountdown < 0 then mainmenu.start'main' end
		end
		if mainmenu.fadeincountdown then
			mainmenu.fadeincountdown = mainmenu.fadeincountdown - dt
			if mainmenu.fadeincountdown < 0 then mainmenu.fadeincountdown=nil end
		end
	end
	love.timer.sleep(15)
end

function mainmenu.draw ()
	love.graphics.setColor(0,0,0)
	if mainmenu.state==1 then
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
	elseif mainmenu.state==3 then
		--credits
		local c = mainmenu.credits
		love.graphics.print(c.names[c.index*2+1], c.x, 200)
		love.graphics.print(c.names[c.index*2+2], c.x, 240)
		love.graphics.setColor(0,255,0)
		local x
		local x2
		if c.x >love.graphics.getWidth()/2-50 then
			x = love.graphics.getWidth()-c.x-160
			x2 = x+20
		else
			x = c.x-60
			x2 = x+20
		end
		love.graphics.line(x, 0, x, love.graphics.getHeight())
		love.graphics.line(x2, 0, x2, love.graphics.getHeight())
		love.graphics.setColor(0,255,0,50)
		love.graphics.rectangle(love.draw_fill, x, 0, x2-x, love.graphics.getHeight())
	else
		love.graphics.print("Not yet implemented... press escape...", 100, 100)
	end
	if mainmenu.fadeoutcountdown then
		love.graphics.setColor(255,255,255,255-(mainmenu.fadeoutcountdown/mainmenu.fadetime*255))
		love.graphics.rectangle(love.draw_fill, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	end
	if mainmenu.fadeincountdown then
		love.graphics.setColor(255,255,255,(mainmenu.fadeincountdown/mainmenu.fadetime*255))
		love.graphics.rectangle(love.draw_fill, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
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
			for i=1,#mainmenu.ys do
				mainmenu.y_tos[i] = -i*30
			end
			mainmenu.y_tos[mainmenu.selected] = mainmenu.ys[mainmenu.selected]
			mainmenu.fadeoutcountdown = mainmenu.fadetime
		end
	else
		if key == love.key_escape then
			mainmenu.start("main")
		end
	end
end
