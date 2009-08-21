require "libs/LoveUI/LoveUI.lua"
LoveUI.requireall()

editor = { active = false, cursortexture = nil }

editor.context=LoveUI.Context:new();
editor.button_settings=LoveUI.Button:new(LoveUI.Rect:new(10, 10, 128, 32));
editor.button_settings.value = "Settings"
editor.button_settings:setAction(function ()
	editor.view_settings.hidden = false
	editor.view_objects.hidden = true
end)
editor.button_clear=LoveUI.Button:new(LoveUI.Rect:new(148, 10, 128, 32));
editor.button_clear.value = "Clear"
editor.button_clear:setAction(function ()
	game.map.Objects = {}
end)
editor.button_load=LoveUI.Button:new(LoveUI.Rect:new(286, 10, 128, 32));
editor.button_load.value = "Load"
editor.button_save=LoveUI.Button:new(LoveUI.Rect:new(424, 10, 128, 32));
editor.button_save.value = "Save"
editor.button_objects=LoveUI.Button:new(LoveUI.Rect:new(562, 10, 128, 32));
editor.button_objects.value = "Tools"
editor.button_objects:setAction(function ()
	editor.view_settings.hidden = true
	editor.view_objects.hidden = false
end)

editor.view_settings = LoveUI.View:new(LoveUI.Rect:new(10, 42, 200, 300), LoveUI.Size:new(400, 400))
editor.view_settings.hidden = true
editor.settings_title = LoveUI.Textfield:new(LoveUI.Rect:new(10, 10, 128, 26))
editor.settings_title.value = "Title"
editor.settings_author = LoveUI.Textfield:new(LoveUI.Rect:new(10, 41, 128, 26))
editor.settings_author.value = "Author"
editor.settings_version = LoveUI.Textfield:new(LoveUI.Rect:new(10, 72, 128, 26))
editor.settings_version.value = "Version"
editor.view_settings:addSubview(editor.settings_title, editor.settings_author,
	editor.settings_version)

editor.view_objects = LoveUI.View:new(LoveUI.Rect:new(562, 42, 200, 300), LoveUI.Size:new(400, 400))
editor.view_objects.hidden = false
editor.objects_player=LoveUI.Button:new(LoveUI.Rect:new(10, 10, 128, 32));
editor.objects_player.value = "Place player"
editor.objects_player:setAction(function ()
	--
end)
editor.view_objects:addSubview(editor.objects_player)
	
editor.context:addSubview(editor.button_settings, editor.button_clear,
	editor.button_load, editor.button_save, editor.button_objects,
	editor.view_settings, editor.view_objects)

editor.button_settings.opaque = false
editor.button_clear.opaque = false
editor.button_load.opaque = false
editor.button_save.opaque = false
editor.button_objects.opaque = false
editor.settings_title.opaque = false
editor.settings_author.opaque = false
editor.settings_version.opaque = false
editor.objects_player.opaque = false

local clr = love.graphics.newColor(255,255,255)
editor.button_settings.textColor = clr
editor.button_clear.textColor = clr
editor.button_load.textColor = clr
editor.button_save.textColor = clr
editor.button_objects.textColor = clr
editor.settings_title.textColor = clr
editor.settings_author.textColor = clr
editor.settings_version.textColor = clr
editor.objects_player.textColor = clr



function editor.draw()
	setCamera(cameras.editor)
end

function editor.mousepressed(x, y, button)
	-- trigger some gui action
end

function editor.enable()
	
end

function editor.disable()
	
end
