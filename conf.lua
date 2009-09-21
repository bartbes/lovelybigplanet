function love.conf(t)
	t.title = "LovelyBigPlanet"
	t.author = "Bart Bes & others (see README)"
	--apparently the following line causes segfaults
	--t.screen = false
	--so, we'll create a tiny temporary window
	t.screen.width = 1
	t.screen.height = 1
	--t.screen.fullscreen = false
	--t.screen.vsync = ?
	--t.screen.fsaa = ?
end
