function love.conf(t)
	t.title = "LovelyBigPlanet"
	t.author = "Bart Bes & others (see README)"
	--apparently the following line causes segfaults
	t.screen = false
	--t.screen.fullscreen = false
	--t.screen.vsync = ?
	--t.screen.fsaa = ?
end
