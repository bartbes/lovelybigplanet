marketplace = {context = LoveUI.Context:new(), active = false}
marketplace.view = LoveUI.View:new(LoveUI.Rect:new(100, 100, 500, 500), LoveUI.Size:new(500, 500))
--marketplace.view:addSubview()

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
		marketplace.context:keyEvent(key, editor.context.keyDown)
	end
end
