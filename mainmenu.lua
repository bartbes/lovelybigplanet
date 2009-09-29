local function startplaying(name)
	mainmenu.unload()
	editor.allowed = false
	startgame(name)
end

local function loadGame()
	startplaying(mainmenu.options.load[mainmenu.selected])
end

local function prepareload ()
	mainmenu.options.load = {}
	mainmenu.actions.load = {}
	local maps = love.filesystem.enumerate("maps")
	for i, v in ipairs(maps) do
		if 		v:sub(-4, -1) == ".lua" and --only load .lua files
				v:sub(1, 3) ~= 'map' and --can't load campaign scenarios
				v ~= 'newmap.lua' then --don't show newmap
			table.insert(mainmenu.options.load, string.sub(v, 1, -5))
			table.insert(mainmenu.actions.load, loadGame)
		end
	end
	table.insert(mainmenu.options.load, 'Back')
	table.insert(mainmenu.actions.load, function () mainmenu.start'play' end)
	mainmenu.start'load'
end


mainmenu = {
	options = {
			main = {'Play', 'Share', 'Edit', 'Settings', 'Credits', 'Exit'},
			play = {'Start game', 'Start campaign', 'Start tutorial', 'Load game', 'Back'},
			settings = {'Screensize', 'Fullscreen', 'Back', },
			resolution = {'Back', },
			load = {'?'}
			},
	actions = {
			main = {function () mainmenu.start'play' end, function () mainmenu.unload() ;marketplace.load() end, 
					function () startplaying('newmap', true);editor.allowed=true;editor.active=true end,
					function () mainmenu.start'settings' end,
					function () mainmenu.credits.start() end,
					function () quitgame() end
					},
			play = {function () startplaying'testmap' end, function () startplaying("map" .. campaignmap) end,
					function () startplaying'map0' end, prepareload, function () mainmenu.start'main' end
					},
			settings = {function () mainmenu.start'resolution' end, function () love.graphics.toggleFullscreen(); mainmenu.fullscreen = true; mainmenu.start'settings' end,
						function () mainmenu.start'main' end,
					},
			resolution = {function () mainmenu.start'settings' end, },
			load = {loadGame}
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
		local n = #mainmenu.options[new]
		local basey = love.graphics.getHeight()/4
		for i=1,n do
			mainmenu.ys[i] = -10
			mainmenu.y_tos[i] = i*20+basey
		end
		mainmenu.y_tos[n] = n*20+basey+3
		mainmenu.selected = 1
		mainmenu.state = 1
		mainmenu.fadeoutcountdown = nil
		if first then
			mainmenu.fadeincountdown = nil
		else
			mainmenu.fadeincountdown = mainmenu.fadetime
		end
		mainmenu.itemx = love.graphics.getWidth()/2
	end,
	credits = {
			names = {
					"Bart van Strien", "bartbes", "Project starter, general coding",
					"Robin Wellner", "Robin", "Physics, editor, main menu & testing",
					"SnakeFace", "", "General coding & artwork",
					"Qubodup", "", "Artwork",
					"Linus Sjogren", "thelinx", "Donates host"
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
	setCamera(cameras.mainmenu)
	mainmenu.start('main', true)
	love.graphics.setBackgroundColor(255, 255, 255)
	love.graphics.setLineWidth(2)
	mainmenu.active = true
	editor.active = false
	love.update = mainmenu.update
	love.draw = mainmenu.draw
end
function mainmenu.unload ()
	love.graphics.setBackgroundColor(0,0,0)
	setCamera(cameras.hud) --> strangely, I have to do this to fix line width
	love.graphics.setLineWidth(1)
	setCamera(cameras.default)
	mainmenu.active = false
	love.update = game.update
	love.draw = game.draw
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
				c.x = c.x - ((c.x-halfw)*4.8+10)*dt
				if c.x < halfw then
					c.timeout = .15+ 0.01*(#c.names[c.index*3+1]+#c.names[c.index*3+2]+#c.names[c.index*3+3])
				end
			else
				c.x = c.x - ((halfw-c.x)*6.8+7)*dt
				if c.x < -100 then
					c.index = c.index + 1
					if c.index*3+1 > #c.names then
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
		local basey = love.graphics.getHeight()/4
		love.graphics.print(c.names[c.index*3+1], c.x, basey)
		love.graphics.print(c.names[c.index*3+2], c.x, basey+20)
		love.graphics.print(c.names[c.index*3+3], c.x, basey+60)
		love.graphics.setColor(0,255,0)
		local x
		if c.x >love.graphics.getWidth()/2-50 then
			x = love.graphics.getWidth()-c.x-160
		else
			x = c.x-60
		end
		love.graphics.line(x, 0, x, love.graphics.getHeight())
		love.graphics.line(x+20, 0, x+20, love.graphics.getHeight())
		love.graphics.setColor(0,255,0,50)
		love.graphics.rectangle(love.draw_fill, x, 0, 20, love.graphics.getHeight())
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


for i,mode in ipairs(love.graphics.getModes()) do
	table.insert(mainmenu.options.resolution, 1, mode.width .. 'x' .. mode.height)
	table.insert(mainmenu.actions.resolution, 1, function () setRes(mode.width, mode.height, mainmenu.fullscreen); mainmenu.start "settings" end)
end
