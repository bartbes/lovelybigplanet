hud = {}

local oldUpdate
local oldKeypressed
local function msgUpdate() end
local function msgKeypressed(key)
	if key == love.key_return then
		hud.messagebox = nil
		update = oldUpdate
		keypressed = oldKeypressed
	end
end

function hud.draw()
	setCamera(cameras.hud)
	local col = love.graphics.getColor()
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	love.graphics.setColor(175, 175, 50)
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
	if hud.score then
		love.graphics.drawf(tostring(game.score), width/2-5, 30, 20, love.align_center)
	end
	if dbg then
		love.graphics.setColor(255, 0, 0)
		local x = width-120
		local basey = love.graphics.getHeight()/2
		local line = love.graphics.getFont():getHeight() + 2
		love.graphics.draw("FPS: " .. love.timer.getFPS(), x, basey)
		love.graphics.draw("Jump: " .. tostring(game.allowjump), x, basey+line)
		love.graphics.draw("Finished: " .. tostring(game.finished), x, basey+2*line)
	end
	if hud.messagebox then
		love.graphics.setColor(0, 0, 0, 100)
		love.graphics.rectangle(love.draw_fill, 0, 0, width, height)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle(love.draw_fill, width/4, height/4, width/2, height/4)
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw("Press Enter to continue", width*5/8, height/2-10)
		love.graphics.drawf(hud.messagebox, width/2-50, height*3/8-20, width/10, love.align_center)
	end
	love.graphics.setColor(col)
	setCamera(cameras.default)
end

function hud.messageBox(text)
	if not oldUpdate then oldUpdate = update end
	if not oldKeypressed then oldKeypressed = keypressed end
	update = msgUpdate
	keypressed = msgKeypressed
	hud.messagebox = text
end
