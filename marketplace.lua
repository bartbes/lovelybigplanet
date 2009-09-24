marketplace = {context = LoveUI.Context:new(), active = false}
marketplace.view = LoveUI.View:new(LoveUI.Rect:new(100, 100, 500, 500), LoveUI.Size:new(500, 500))
marketplace.button_news = LoveUI.Button:new(LoveUI.Rect:new(10, 10, 80, 32));
marketplace.button_news.value = "News"
marketplace.button_topmaps = LoveUI.Button:new(LoveUI.Rect:new(90, 10, 80, 32));
marketplace.button_topmaps.value = "Top maps"
marketplace.button_topobjs = LoveUI.Button:new(LoveUI.Rect:new(170, 10, 80, 32));
marketplace.button_topobjs.value = "Top objects"
marketplace.button_search = LoveUI.Button:new(LoveUI.Rect:new(250, 10, 80, 32));
marketplace.button_search.value = "Search"
marketplace.button_share = LoveUI.Button:new(LoveUI.Rect:new(330, 10, 80, 32));
marketplace.button_share.value = "Share"
marketplace.view:addSubview(marketplace.button_news, marketplace.button_topmaps, marketplace.button_topobjs,
		marketplace.button_search, marketplace.button_share)

marketplace.context:addSubview(marketplace.view)


function marketplace.update(dt)
	marketplace.context:update(dt)
	love.timer.sleep(15)
end

function marketplace.draw(dt)
	marketplace.context:display()
end

function marketplace.load()
	setCamera(cameras.marketplace)
	love.graphics.setBackgroundColor(255, 255, 255)
	love.update = marketplace.update
	love.draw = marketplace.draw
	marketplace.active = true
end

function marketplace.unload()
	marketplace.active = false
	mainmenu.load()
end

function marketplace.keypressed(key)
	if key == love.key_escape then
		marketplace.unload()
	else
		marketplace.context:keyEvent(key, marketplace.context.keyDown)
	end
end

function marketplace.mousereleased(x, y, button)
	if marketplace.active then
		marketplace.context:mouseEvent(x, y, button, marketplace.context.mouseUp)
	end
end

function marketplace.mousepressed(x, y, button)
	if marketplace.active then
		marketplace.context:mouseEvent(x, y, button, marketplace.context.mouseDown)
	end
end