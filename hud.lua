hud = {}

--we need to store the old ones, we do this once, to prevent EVUL things from happening
local oldUpdate
local oldKeypressed
local oldJoystickpressed

--new callbacks, local, nobody else needs it
local function msgUpdate() end
local function msgKeypressed(key)
	if key == love.key_return then
		hud.messagebox = nil
		update = oldUpdate
		keypressed = oldKeypressed
		joystickpressed = oldJoystickpressed
	end
end
local function msgJoystickpressed(j, key)
	if j ~= activejoystick then return end
	if key == 0 then
		msgKeypressed(love.key_return)
	end
end

function hud.draw()
	--set the camera to the HUD camera, 1:1 scale
	setCamera(cameras.hud)
	--store the stuff we need to use a lot, this saves us from calling
	--these functions a lot, saves CPU
	local col = love.graphics.getColor()
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	--set the color
	love.graphics.setColor(175, 175, 50)
	--draw the inside
	if hud.score or dbg then
		love.graphics.rectangle(love.draw_fill, width/2-200, 0, 400, 50)
		love.graphics.triangle(love.draw_fill, width/2-200, 0, width/2-200, 50, width/2-250, 0)
		love.graphics.triangle(love.draw_fill, width/2+200, 0, width/2+200, 50, width/2+250, 0)
	end
	if hud.lvl1 or dbg then
		love.graphics.rectangle(love.draw_fill, 0, 0, 100, 30)
		love.graphics.rectangle(love.draw_fill, 0, 30, 80, 20)
		love.graphics.triangle(love.draw_fill, 80, 30, 100, 30, 80, 50)
	end
	if hud.lvl2 or dbg then
		love.graphics.rectangle(love.draw_fill, width-100, 0, 100, 30)
		love.graphics.rectangle(love.draw_fill, width-80, 30, 80, 20)
		love.graphics.triangle(love.draw_fill, width-80, 30, width-80, 50, width-100, 30)
	end
	love.graphics.setColor(0, 0, 0)
	--draw the outline
	if hud.score or dbg then
		love.graphics.line(width/2-250, 0, width/2-200, 50)
		love.graphics.line(width/2-200, 50, width/2+200, 50)
		love.graphics.line(width/2+200, 50, width/2+250, 0)
	end
	if hud.lvl1 or dbg then
		love.graphics.line(0, 50, 80, 50)
		love.graphics.line(100, 0, 100, 30)
		love.graphics.line(80, 50, 100, 30)
	end
	if hud.lvl2 or dbg then
		love.graphics.line(width, 50, width-80, 50)
		love.graphics.line(width-100, 0, width-100, 30)
		love.graphics.line(width-100, 30, width-80, 50)
	end
	--and, draw the inside
	if hud.score then
		love.graphics.drawf(tostring(game.score), width/2-5, 30, 20, love.align_center)
	end
	--debug code
	if dbg then
		love.graphics.setColor(255, 0, 0)
		local x = width-120
		local basey = love.graphics.getHeight()/2
		local line = love.graphics.getFont():getHeight() + 2
		love.graphics.draw("FPS: " .. love.timer.getFPS(), x, basey)
		love.graphics.draw("Jump: " .. tostring(game.allowjump), x, basey+line)
		love.graphics.draw("Finished: " .. tostring(game.finished), x, basey+2*line)
	end
	--mesage boxes, they are part of the HUD, so this is the perfect place
	if hud.messagebox then
		--set the color to transparent black, and draw that over the entire screen
		love.graphics.setColor(0, 0, 0, 100)
		love.graphics.rectangle(love.draw_fill, 0, 0, width, height)
		--now start drawing those contents
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle(love.draw_fill, width/4, height/4, width/2, height/4)
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw("Press Enter to continue", width*.75-165, height/2-10)
		love.graphics.drawf(hud.messagebox, width/4, height*3/8-20, width/2, love.align_center)
		--NOTE: I don't get the feeling love.align_center works as it should
	end
	--restore settings, we don't want to impact any other drawing
	love.graphics.setColor(col)
	setCamera(cameras.default)
end

function hud.messageBox(text) --create a message box
	--store the callbacks, if necessary (happens once)
	if not oldUpdate then oldUpdate = update end
	if not oldKeypressed then oldKeypressed = keypressed end
	if not oldJoystickpressed then oldJoystickpressed = joystickpressed end
	--load the new ones
	update = msgUpdate
	keypressed = msgKeypressed
	joystickpressed = msgJoystickpressed
	--set the text
	hud.messagebox = text
end
