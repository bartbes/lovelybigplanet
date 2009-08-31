require "libs/LoveUI/LoveUI.lua"
LoveUI.requireall()

editor = { active = false, cursortexture = nil, cursorobject = nil }

local clr = love.graphics.newColor(255,255,255)
local function preparebutton(btn)
	btn.opaque = false
	btn.textColor = clr
end
local function preparepopup(btn)
	btn.backgroundColor = clr
end

editor.context=LoveUI.Context:new();
editor.button_settings=LoveUI.Button:new(LoveUI.Rect:new(10, 10, 80, 32));
editor.button_settings.value = "Settings"
editor.button_settings:setAction(function ()
	editor.view_objects.hidden = true
	editor.view_load.hidden = true
	editor.view_settings.hidden = not editor.view_settings.hidden
end)
preparebutton(editor.button_settings)
editor.button_clear=LoveUI.Button:new(LoveUI.Rect:new(100, 10, 80, 32));
editor.button_clear.value = "Clear"
editor.button_clear:setAction(function ()
	game.map.Objects = {}
end)
preparebutton(editor.button_clear)
editor.button_load=LoveUI.Button:new(LoveUI.Rect:new(190, 10, 80, 32));
editor.button_load.value = "Load"
editor.button_load:setAction(function ()
	editor.view_settings.hidden = true
	editor.view_objects.hidden = true
	editor.view_load.hidden = not editor.view_load.hidden
end)
preparebutton(editor.button_load)
editor.button_save=LoveUI.Button:new(LoveUI.Rect:new(280, 10, 80, 32));
editor.button_save.value = "Save"
editor.button_save:setAction(function ()
	if editor.settings_filename.value == "Filename" then
		return
	end
	game.map.Name = editor.settings_title.value
	game.map.Creator = editor.settings_author.value
	game.map.Version = editor.settings_version.value
	generatemap(editor.settings_filename.value)
end)
preparebutton(editor.button_save)
editor.button_objects=LoveUI.Button:new(LoveUI.Rect:new(370, 10, 80, 32));
editor.button_objects.value = "Tools"
editor.button_objects:setAction(function ()
	editor.view_settings.hidden = true
	editor.view_load.hidden = true
	editor.view_objects.hidden = not editor.view_objects.hidden
end)
preparebutton(editor.button_objects)

editor.view_settings = LoveUI.View:new(LoveUI.Rect:new(10, 42, 200, 300), LoveUI.Size:new(400, 400))
editor.view_settings.hidden = true
editor.settings_title = LoveUI.Textfield:new(LoveUI.Rect:new(10, 10, 100, 26))
editor.settings_title.value = "Title"
preparebutton(editor.settings_title)
editor.settings_author = LoveUI.Textfield:new(LoveUI.Rect:new(10, 41, 100, 26))
editor.settings_author.value = "Author"
preparebutton(editor.settings_author)
editor.settings_version = LoveUI.Textfield:new(LoveUI.Rect:new(10, 72, 100, 26))
editor.settings_version.value = "Version"
preparebutton(editor.settings_version)
editor.settings_filename = LoveUI.Textfield:new(LoveUI.Rect:new(10, 103, 100, 26))
editor.settings_filename.value = "Filename"
preparebutton(editor.settings_filename)
editor.view_settings:addSubview(editor.settings_title, editor.settings_author,
	editor.settings_version, editor.settings_filename)


editor.view_objects = LoveUI.View:new(LoveUI.Rect:new(370, 42, 200, 500), LoveUI.Size:new(400, 500))
editor.view_objects.hidden = false
editor.objectbuttons = {}
local objs = love.filesystem.enumerate("objects")
local function placeobject (self)
	editor.cursorobject=loadobjectlite(self.value)
	editor.cursortexture=editor.cursorobject.Resources.texture
	editor.placeonce = false
	editor.view_objects.hidden = true
end
for i, v in ipairs(objs) do
	editor.objectbuttons[i] = LoveUI.Button:new(LoveUI.Rect:new(10, 42*i-32, 100, 32));
	editor.objectbuttons[i].value = string.sub(v, 1, -5)
	editor.objectbuttons[i]:setAction(placeobject)
	preparebutton(editor.objectbuttons[i])
end
local i = #objs + 1
editor.objectbuttons[i] = LoveUI.Button:new(LoveUI.Rect:new(10, 42*i-32, 100, 32));
editor.objectbuttons[i].value = "Select"
editor.objectbuttons[i]:setAction(function (self)
	editor.cursorobject=nil
	editor.cursortexture=nil
	editor.view_objects.hidden = true
end)
preparebutton(editor.objectbuttons[i])
editor.view_objects:addSubview(unpack(editor.objectbuttons))

editor.view_load = LoveUI.View:new(LoveUI.Rect:new(190, 42, 200, 300), LoveUI.Size:new(400, 400))
editor.view_load.hidden = true
editor.loadbuttons = {}
local maps = love.filesystem.enumerate("maps")
local function loadgame(self)
	startgame(self.value, true)
	editor.view_load.hidden = true
end
for i, v in ipairs(maps) do
	editor.loadbuttons[i] = LoveUI.Button:new(LoveUI.Rect:new(10, 42*i-32, 100, 32))
	editor.loadbuttons[i].value = string.sub(v, 1, -5)
	editor.loadbuttons[i]:setAction(loadgame)
	preparebutton(editor.loadbuttons[i])
end
editor.view_load:addSubview(unpack(editor.loadbuttons))

editor.view_popup = LoveUI.View:new(LoveUI.Rect:new(0, 0, 500, 500), LoveUI.Size:new(400, 400))
editor.view_popup.hidden = true
editor.popup_move = LoveUI.Button:new(LoveUI.Rect:new(0, 0, 100, 26))
editor.popup_move.value = "Move"
editor.popup_move:setAction(function (self)
	editor.view_popup.hidden = true
	--move (sh)it
	editor.cursorobject = game.map.Objects[editor.selectedobject]
	editor.cursortexture=editor.cursorobject.Resources.texture
	game.map.Objects[editor.selectedobject] = nil
	editor.selectedobject = nil
	editor.placeonce = true
end)
preparepopup(editor.popup_move)
editor.popup_rot = LoveUI.Button:new(LoveUI.Rect:new(0, 26, 100, 26))
editor.popup_rot.value = "Rotate"
editor.popup_rot:setAction(function (self)
	editor.view_popup.hidden = true
	--rotate (sh)it
	editor.rotatemode = true
end)
preparepopup(editor.popup_rot)
editor.popup_place = LoveUI.Button:new(LoveUI.Rect:new(0, 52, 100, 26))
editor.popup_place.value = "Layer(s)"
editor.popup_place:setAction(function (self)
	editor.view_popup.hidden = true
	--place (sh)it
	local p = game.map.Objects[editor.selectedobject]._positions
	local inp = false
	local I
	for i,v in ipairs(p) do
		if v == game.activelayer then
			inp = true
			I = i
			break
		end
	end
	if inp then
		table.remove(p, I)
	else
		table.insert(p, game.activelayer)
	end
	local posses = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
	for i, v2 in ipairs(p) do
		table.remove(posses, v2-i+1) -- oh god, this is awful
	end
	for i, v in ipairs(game.map.Objects[editor.selectedobject]._shapes) do
		v:setCategory(unpack(p))
		v:setMask(unpack(posses))
	end
end)
preparepopup(editor.popup_place)
editor.popup_del = LoveUI.Button:new(LoveUI.Rect:new(0, 78, 100, 26))
editor.popup_del.value = "Delete"
editor.popup_del:setAction(function (self)
	editor.view_popup.hidden = true
	--delete (sh)it
	game.map.Objects[editor.selectedobject] = nil
	editor.selectedobject = nil
end)
preparepopup(editor.popup_del)
editor.popup_cancel = LoveUI.Button:new(LoveUI.Rect:new(0, 104, 100, 26))
editor.popup_cancel.value = "Cancel"
editor.popup_cancel:setAction(function (self)
	editor.view_popup.hidden = true
	--don't do (sh)it
end)
preparepopup(editor.popup_cancel)
editor.default_action = editor.popup_move

editor.view_popup:addSubview(editor.popup_move, editor.popup_rot,
	editor.popup_place, editor.popup_del, editor.popup_cancel)

editor.context:addSubview(editor.button_settings, editor.button_clear,
	editor.button_load, editor.button_save, editor.button_objects,
	editor.view_settings, editor.view_objects, editor.view_load,
	editor.view_popup)

function mousepressed(x, y, button)
	if editor.active then
		editor.context:mouseEvent(x, y, button, editor.context.mouseDown)
		if editor.rotatemode then
			editor.rotatemode = false
			editor.selectedobject = nil
			return
		end
		if editor.view_settings.hidden and (y > 40 or x > 460) and (editor.view_objects.hidden or (x < 370 or x > 480 or y > 42+42 * #editor.objectbuttons)) and editor.view_popup.hidden then
			x, y = cameras.default:unpos(x, y)
			if editor.cursorobject then
				if editor.cursorobject._lite then
					if editor.cursorobject._name == 'player' then
						game.map.Objects.player = loadobject('player', editor.cursorobject._name, game.world, x, y, 0, {game.activelayer})
					else
						local i = 1
						while game.map.Objects[editor.cursorobject._name .. i] do
							i = i + 1
						end
						game.map.Objects[editor.cursorobject._name .. i] = loadobject(editor.cursorobject._name .. i, editor.cursorobject._name, game.world, x, y, 0, {game.activelayer})
					end
				else
					editor.cursorobject._body:setPosition(x, y)
					game.map.Objects[editor.cursorobject._internalname] = editor.cursorobject
				end
				if editor.placeonce then
					editor.selectedobject = editor.cursorobject._internalname
					editor.cursorobject = nil
					editor.cursortexture = nil
				end
			else
				if editor.selectedobject then
					local newobj = getobjat(x, y)
					if editor.selectedobject == newobj then
						if button == love.mouse_right then
							editor.view_popup.hidden = false
							editor.view_popup:setOrigin(LoveUI.Point:new(camera.love.graphics.getWidth()/2 - 50, camera.love.graphics.getHeight()/2 - 60))
						else
							editor.default_action.cell.controlEvents[LoveUI.EventDefault]()
						end
					else
						editor.selectedobject = newobj
					end
				else
					editor.selectedobject = getobjat(x, y)
					if editor.selectedobject and editor.default_action == editor.popup_del then
						editor.default_action.cell.controlEvents[LoveUI.EventDefault]() --delete immediately
					end
				end
			end
		end
	end
end
 
function mousereleased(x, y, button)
	if editor.active then
		editor.context:mouseEvent(x, y, button, editor.context.mouseUp)
	end
end
