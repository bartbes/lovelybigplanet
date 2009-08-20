require "libs/LoveUI/LoveUI.lua"
LoveUI.requireall()

editor = { active = false, cursortexture = nil }

editor.context=LoveUI.Context:new();
editor.button_settings=LoveUI.Button:new(LoveUI.Rect:new(10, 10, 128, 32));
editor.button_settings.value = "Settings"
editor.button_clear=LoveUI.Button:new(LoveUI.Rect:new(148, 10, 128, 32));
editor.button_clear.value = "Clear"
editor.button_clear:setAction(function ()
	game.map.Objects = {}
end)
editor.button_load=LoveUI.Button:new(LoveUI.Rect:new(286, 10, 128, 32));
editor.button_load.value = "Load"
editor.button_save=LoveUI.Button:new(LoveUI.Rect:new(424, 10, 128, 32));
editor.button_save.value = "Save"
editor.context:addSubview(editor.button_settings, editor.button_clear,
	editor.button_load, editor.button_save)

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
