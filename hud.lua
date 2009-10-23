hud = {msgFadetimemax = .15, msgFadeouttime = 0, msgFadeintime = 0}

--we need to store the old ones, we do this once, to prevent EVUL things from happening
local oldUpdate
local oldKeypressed
local oldJoystickpressed
local msgwidth

--new callbacks, local, nobody else needs it
local function msgUpdate(dt)
	if hud.msgFadeintime > 0 then
		hud.msgFadeintime = hud.msgFadeintime - dt
		if hud.msgFadeintime < 0 then
			hud.msgFadeintime = 0
		end
	end
	if hud.msgFadeouttime > 0 then
		hud.msgFadeouttime = hud.msgFadeouttime - dt
		if hud.msgFadeouttime < 0 then
			hud.msgFadeouttime = 0
			hud.messagebox = nil
			hud.speechbox = nil
			love.update = oldUpdate
			love.keypressed = oldKeypressed
			love.joystickpressed = oldJoystickpressed
		end
	end
end
local function msgKeypressed(key)
	if key == 'return' then
		hud.msgFadeouttime = hud.msgFadetimemax-hud.msgFadeintime
	end
end

local function msgJoystickpressed(j, key)
	if j ~= activejoystick then return end
	if key == 0 then
		msgKeypressed('return')
	end
end

function hud.draw()
	--set the camera to the HUD camera, 1:1 scale
	setCamera(cameras.hud)
	--store the stuff we need to use a lot, this saves us from calling
	--these functions a lot, saves CPU
	local col = {love.graphics.getColor()}
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	--set the color
	love.graphics.setColor(175, 175, 50)
	--draw the inside
	if hud.score or dbg then
		love.graphics.rectangle('fill', width/2-200, 0, 400, 50)
		love.graphics.triangle('fill', width/2-200, 0, width/2-200, 50, width/2-250, 0)
		love.graphics.triangle('fill', width/2+200, 0, width/2+200, 50, width/2+250, 0)
	end
	if hud.lvl1 or dbg then
		love.graphics.rectangle('fill', 0, 0, 100, 30)
		love.graphics.rectangle('fill', 0, 30, 80, 20)
		love.graphics.triangle('fill', 80, 30, 100, 30, 80, 50)
	end
	if hud.lvl2 or dbg then
		love.graphics.rectangle('fill', width-100, 0, 100, 30)
		love.graphics.rectangle('fill', width-80, 30, 80, 20)
		love.graphics.triangle('fill', width-80, 30, width-80, 50, width-100, 30)
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
		love.graphics.drawf(tostring(game.score), width/2-5, 30, 20, 'center')
	end
	--debug code
	if dbg then
		love.graphics.setColor(255, 0, 0)
		local x = width-120
		local basey = love.graphics.getHeight()/2
		local line = love.graphics.getFont():getHeight() + 2
		love.graphics.print("FPS: " .. love.timer.getFPS(), x, basey)
		love.graphics.print("Jump: " .. tostring(game.allowjump), x, basey+line)
		love.graphics.print("Finished: " .. tostring(game.finished), x, basey+2*line)
	end
	--mesage boxes, they are part of the HUD, so this is the perfect place
	if hud.messagebox then
		--set the color to transparent black, and draw that over the entire screen
		love.graphics.setColor(0, 0, 0, 100)
		love.graphics.rectangle('fill', 0, 0, width, height)
		--now start drawing those contents
		love.graphics.setColor(255, 255, 255)
		local lineheight = (hud.msgFadeouttime > 0 and hud.msgFadeouttime/hud.msgFadetimemax or (hud.msgFadeintime > 0 and 1-hud.msgFadeintime/hud.msgFadetimemax or 1)) * height/4
		love.graphics.rectangle('fill', 0, height/4, width, lineheight)
		love.graphics.setColor(0,255,0)
		love.graphics.setLineWidth(2)
		love.graphics.line(0, height/4, width, height/4)
		love.graphics.line(0, height/4+lineheight, width, height/4+lineheight)
		love.graphics.line(0, height/4+lineheight-20, width, height/4+lineheight-20)
		love.graphics.setColor(0,255,0,100)
		love.graphics.rectangle('fill', 0, height/4+lineheight-20, width, 20)
		love.graphics.setColor(0, 0, 0)
		love.graphics.print("Press Enter to continue", width*.75-165, height/4+lineheight-6)
		if hud.msgFadeintime ==0 and hud.msgFadeouttime ==0 then
			love.graphics.drawf(hud.messagebox, width/4, height*3/8-20, width/2, 'center')
		end
		--NOTE: I don't get the feeling love.align_center works as it should
	end
	if hud.speechbox then
		love.graphics.setColor(255, 255, 255)
		local lineheight = (hud.msgFadeouttime > 0 and hud.msgFadeouttime/hud.msgFadetimemax or (hud.msgFadeintime > 0 and 1-hud.msgFadeintime/hud.msgFadetimemax or 1)) * 100
		love.graphics.rectangle('fill', 20, height-lineheight-20, width-40, lineheight)
		love.graphics.setColor(0,255,0)
		love.graphics.setLineWidth(2)
		love.graphics.line(20, height-lineheight-20, width-20, height-lineheight-20)
		love.graphics.line(20, height-lineheight, width-20, height-lineheight)
		love.graphics.line(20, height-lineheight-20, 20, height-20)
		love.graphics.line(width-20, height-lineheight-20, width-20, height-20)
		love.graphics.line(20, height-20, width-20, height-20)
		love.graphics.setColor(0,255,0,100)
		love.graphics.rectangle('fill', 20, height-lineheight-20, width-40, 20)
		love.graphics.setColor(0, 0, 0)
		if hud.msgFadeintime ==0 and hud.msgFadeouttime ==0 then
			love.graphics.print(hud.speaker, 24, height-lineheight-6)
			love.graphics.print(hud.speechbox, 28, height-lineheight+20)
			love.graphics.print("Press Enter to continue", width-msgwidth-30, height-30)
		end
	end
	--restore settings, we don't want to impact any other drawing
	love.graphics.setColor(unpack(col))
	console:draw()
	setCamera(cameras.default)
end

function hud.messageBox(text) --create a message box
	--store the callbacks, if necessary (happens once)
	if not oldUpdate then oldUpdate = love.update end
	if not oldKeypressed then oldKeypressed = love.keypressed end
	if not oldJoystickpressed then oldJoystickpressed = love.joystickpressed end
	--load the new ones
	love.update = msgUpdate
	love.keypressed = msgKeypressed
	love.joystickpressed = msgJoystickpressed
	--set the text
	hud.messagebox = text
	hud.msgFadeintime = hud.msgFadetimemax
end

function hud.speechBox(speaker, text) --create a message box
	--store the callbacks, if necessary (happens once)
	if not oldUpdate then oldUpdate = love.update end
	if not oldKeypressed then oldKeypressed = love.keypressed end
	if not oldJoystickpressed then oldJoystickpressed = love.joystickpressed end
	--load the new ones
	love.update = msgUpdate
	love.keypressed = msgKeypressed
	love.joystickpressed = msgJoystickpressed
	--set the text
	hud.speechbox = text
	hud.speaker = speaker
	hud.msgFadeintime = hud.msgFadetimemax
	if not msgwidth then
		msgwidth = love.graphics.getFont():getWidth("Press Enter to continue")
	end
end

--Testing function:
function sB()
	hud.speechBox("rude", "OBEY!")
end
