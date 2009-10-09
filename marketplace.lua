local entries = {}

local function cleartable(t)
	for i, v in pairs(t) do
		t[i] = nil
	end
end

local function setmode(self)
	marketplace.button_news.cell.isdown = false
	marketplace.button_topmaps.cell.isdown = false
	marketplace.button_topobjs.cell.isdown = false
	marketplace.button_newmaps.cell.isdown = false
	marketplace.button_newobjs.cell.isdown = false
	marketplace.button_search.cell.isdown = false
	marketplace.button_share.cell.isdown = false
	marketplace.viewmode = self.value
	self.cell.isdown = true
	if marketplace.list then
		cleartable(entries)
		marketplace.list:reloadData()
		if self.value == "Top maps" then
			network:getlist("map10")
		elseif self.value == "Top objects" then
			network:getlist("obj10")
		elseif self.value == "New maps" then
			network:getlist("mapnew")
		elseif self.value == "New objects" then
			network:getlist("objnew")
		elseif self.value == "News" then
			network:getlist("news")
		end
	end
end
local function preparebutton(btn)
	btn.opaque = false
end

local sep = 1
local width = 78
local swidth = sep+width

marketplace = {context = LoveUI.Context:new(), active = false}
marketplace.view = LoveUI.View:new(LoveUI.Rect:new(20, 30, 10+swidth*7+300, 500), LoveUI.Size:new(10+swidth*7, 600))
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
marketplace.button_newmaps = LoveUI.Button:new(LoveUI.Rect:new(10+swidth*3, 10, width, 32));
marketplace.button_newmaps.value = "New maps"
marketplace.button_newmaps:setAction(setmode)
preparebutton(marketplace.button_newmaps)
marketplace.button_newobjs = LoveUI.Button:new(LoveUI.Rect:new(10+swidth*4, 10, width, 32));
marketplace.button_newobjs.value = "New objects"
marketplace.button_newobjs:setAction(setmode)
preparebutton(marketplace.button_newobjs)
marketplace.button_search = LoveUI.Button:new(LoveUI.Rect:new(10+swidth*5, 10, width, 32));
marketplace.button_search.value = "Search"
marketplace.button_search:setAction(setmode)
preparebutton(marketplace.button_search)
marketplace.button_share = LoveUI.Button:new(LoveUI.Rect:new(10+swidth*6, 10, width, 32));
marketplace.button_share.value = "Share"
marketplace.button_share:setAction(setmode)
preparebutton(marketplace.button_share)
setmode(marketplace.button_news)


local datasource={}
function datasource:viewForRow(aListView, rowIndex)
	local newView=LoveUI.View:new(LoveUI.rectZero);
	function newView:display()
		love.graphics.setColor(0,0,0);
		LoveUI.graphics.draw(entries[rowIndex], 10, 20);
	end
	return newView;
end
function datasource:numberOfRows(aListView)
	return #entries
end
function datasource:columnWidth(aListView)
	return 400
end
marketplace.list = LoveUI.ListView:new(LoveUI.Rect:new(10, 42, 10+swidth*7, 500), datasource)
marketplace.detailstext = LoveUI.TextView:new(LoveUI.Rect:new(10+swidth*7, 40, 10+swidth*7+250, 800), LoveUI.Size:new(250, 760))
marketplace.detailstext.value = "Details"
marketplace.detailstext.enabled = false
marketplace.view:addSubview(marketplace.button_news, marketplace.button_topmaps, marketplace.button_topobjs,
		marketplace.button_newmaps, marketplace.button_newobjs, marketplace.button_search, marketplace.button_share,
		marketplace.list, marketplace.detailstext
		)

marketplace.context:addSubview(marketplace.view)


function marketplace.update(dt)
	marketplace.context:update(dt)
	network:update()
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
	entries = {'Connecting...'}
	marketplace.list:reloadData()
	network:connect()
	setmode(marketplace.button_news)
end

function marketplace.unload()
	network:disconnect()
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

network:setcallback(function(type, length, data)
	if type == "rlst" then
		local t = network:uncsv(data)
		for i, v in ipairs(t) do
			table.insert(entries, v)
		end
		marketplace.list:reloadData()
	elseif type == "rinf" then
		marketplace.detailstext.value = "Details:\n" .. data
	end
end)

marketplace.list:setAction(function(obj)
	network:getinfo(entries[obj:getSelectedIndex()])
end, LoveUI.EventValueChanged)
