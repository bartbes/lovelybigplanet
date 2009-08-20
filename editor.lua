require "libs/LoveUI/LoveUI.lua"
LoveUI.requireall()

editor = { active = false }

editor.context=LoveUI.Context:new();
editor.button1=LoveUI.Button:new(LoveUI.Rect:new(10, 100, 128, 32));
editor.button1.value = "Launch missile"


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
