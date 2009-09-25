local function setmode(self)
	marketplace.button_news.cell.isdown = false
	marketplace.button_topmaps.cell.isdown = false
	marketplace.button_topobjs.cell.isdown = false
	marketplace.button_search.cell.isdown = false
	marketplace.button_share.cell.isdown = false
	marketplace.viewmode = self.value
	self.cell.isdown = true
end
local function preparebutton(btn)
	btn.opaque = false
	--btn.textColor = {255,255,255}
	--btn.backgroundColor = {0,255,0,100}
end

local sep = 1
local width = 120
local swidth = sep+width

marketplace = {context = LoveUI.Context:new(), active = false}
marketplace.view = LoveUI.View:new(LoveUI.Rect:new(100, 100, 800, 500), LoveUI.Size:new(800, 600))
marketplace.button_news = LoveUI.Button:new(LoveUI.Rect:new(10, 10, width, 32));
marketplace.button_news.value = "News"
marketplace.button_news:setAction(setmode)
preparebutton(marketplace.button_news)
marketplace.button_topmaps = LoveUI.Button:new(LoveUI.Rect:new(10+swidth, 10, width, 32));
marketplace.button_topmaps.value = "Top maps"
marketplace.button_topmaps:setAction(setmode)
preparebutton(marketplace.button_topmaps)
marketplace.button_topobjs = LoveUI.Button:new(LoveUI.Rect:new(10+swidth*2, 10, width, 32));
marketplace.button_topobjs.value = "Top objects"
marketplace.button_topobjs:setAction(setmode)
preparebutton(marketplace.button_topobjs)
marketplace.button_search = LoveUI.Button:new(LoveUI.Rect:new(10+swidth*3, 10, width, 32));
marketplace.button_search.value = "Search"
marketplace.button_search:setAction(setmode)
preparebutton(marketplace.button_search)
marketplace.button_share = LoveUI.Button:new(LoveUI.Rect:new(10+swidth*4, 10, width, 32));
marketplace.button_share.value = "Share"
marketplace.button_share:setAction(setmode)
preparebutton(marketplace.button_share)
setmode(marketplace.button_news)

marketplace.textview = LoveUI.TextView:new(LoveUI.Rect:new(10, 42, 604, 500), LoveUI.Size:new(400, 800))
marketplace.textview.value = 'test'
marketplace.view:addSubview(marketplace.button_news, marketplace.button_topmaps, marketplace.button_topobjs,
		marketplace.button_search, marketplace.button_share,
		marketplace.textview
		)

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