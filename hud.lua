hud = {}

function hud.draw()
	setCamera(cameras.hud)
	local col = love.graphics.getColor()
	love.graphics.setColor(175, 175, 50)
	if hud.score or dbg then
		love.graphics.rectangle(love.draw_fill, love.graphics.getWidth()/2-200, 0, 400, 50)
		love.graphics.triangle(love.draw_fill, love.graphics.getWidth()/2-200, 0, love.graphics.getWidth()/2-200, 50, love.graphics.getWidth()/2-250, 0)
		love.graphics.triangle(love.draw_fill, love.graphics.getWidth()/2+200, 0, love.graphics.getWidth()/2+200, 50, love.graphics.getWidth()/2+250, 0)
	end
	if hud.lvl1 or dbg then
		love.graphics.rectangle(love.draw_fill, 0, 0, 100, 30)
		love.graphics.rectangle(love.draw_fill, 0, 30, 80, 20)
		love.graphics.triangle(love.draw_fill, 80, 30, 100, 30, 80, 50)
	end
	if hud.lvl2 or dbg then
		love.graphics.rectangle(love.draw_fill, love.graphics.getWidth()-100, 0, 100, 30)
		love.graphics.rectangle(love.draw_fill, love.graphics.getWidth()-80, 30, 80, 20)
		love.graphics.triangle(love.draw_fill, love.graphics.getWidth()-80, 30, love.graphics.getWidth()-80, 50, love.graphics.getWidth()-100, 30)
	end
	love.graphics.setColor(0, 0, 0)
	if hud.score or dbg then
		love.graphics.line(love.graphics.getWidth()/2-250, 0, love.graphics.getWidth()/2-200, 50)
		love.graphics.line(love.graphics.getWidth()/2-200, 50, love.graphics.getWidth()/2+200, 50)
		love.graphics.line(love.graphics.getWidth()/2+200, 50, love.graphics.getWidth()/2+250, 0)
	end
	if hud.lvl1 or dbg then
		love.graphics.line(0, 50, 80, 50)
		love.graphics.line(100, 0, 100, 30)
		love.graphics.line(80, 50, 100, 30)
	end
	if hud.lvl2 or dbg then
		love.graphics.line(love.graphics.getWidth(), 50, love.graphics.getWidth()-80, 50)
		love.graphics.line(love.graphics.getWidth()-100, 0, love.graphics.getWidth()-100, 30)
		love.graphics.line(love.graphics.getWidth()-100, 30, love.graphics.getWidth()-80, 50)
	end
	if hud.score then
		love.graphics.drawf(tostring(game.score), love.graphics.getWidth()/2, 30, 20, love.align_center)
	end
	if dbg then
		love.graphics.setColor(255, 0, 0)
		local x = love.graphics.getWidth()-120
		local basey = love.graphics.getHeight()/2
		local line = love.graphics.getFont():getHeight() + 2
		love.graphics.draw("FPS: " .. love.timer.getFPS(), x, basey)
		love.graphics.draw("Jump: " .. tostring(game.allowjump), x, basey+line)
		love.graphics.draw("Finished: " .. tostring(game.finished), x, basey+2*line)
	end
	love.graphics.setColor(col)
	setCamera(cameras.default)
end
