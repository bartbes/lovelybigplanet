--[[ CAMERA
-- Description: Supplies an interface for scrolling, scaling, and rotating a scene.
-- Contributors: Osuf Oboys
-- Version:3d, April 24, 2009
-- This product is released under the Lovely Public Community License v. 1.0.
-- Provided that you do not alter this file and call your project a new version of CAMERA,
-- then you are free to do whatever you want, including removing this header and the
-- accompanying license. Otherwise, see the accompanying license.
--]]

-- TODO: particle system scaling
-- TODO: negative scales should substitute a position with the corner that is in the upper upper left after the scaling.
-- TODO: 

camera = {love={graphics={},mouse={}}}
camera.class = {}
camera.class.__index = camera.class

local	twopi = math.pi + math.pi

-- (screenox, screenoy): the position of (ox, oy) on the screen
-- (0,0): upper left (until the next LÖVE version)
-- (1,0): upper right, (0,1): lower left, (1,1): lower right
-- (0.5, 0.5): center of screen
-- TODO: rotation
function camera.new(scalex, scaley, ox, oy, screenox, screenoy, rotation)
	local	cam = {}
	setmetatable(cam, camera.class)
	
	cam.scalex = scalex or 1
	cam.scaley = scaley or 1
	cam.ox = ox or 0
	cam.oy = oy or 0
	cam.screenox = screenox or 0
	cam.screenoy = screenoy or 0
	cam.rotation = rotation or 0
	cam.cosrot = 1
	cam.sinrot = 0
	
	return cam
end

function camera.stretchToResolution(fromwidth, fromheight, towidth, toheight, ox, oy, screenox, screenoy, rotation)
	fromwidth = fromwidth or love.graphics.getWindowWidth()
	fromheight = fromheight or love.graphics.getWindowHeight()
	towidth = towidth or love.graphics.getWindowWidth()
	toheight = toheight or love.graphics.getWindowHeight()
	return camera.new(towidth / fromwidth, toheight / fromheight, ox, oy, screenox, screenoy, rotation)
end

function camera.class:pos(x, y)
	x = x or 0
	y = y or 0
	x,y = ((x - self.ox) * self.cosrot - (y - self.oy) * self.sinrot) * self.scalex + love.graphics.getWindowWidth() * self.screenox,
		((y - self.oy) * self.cosrot + (x - self.ox) * self.sinrot) * self.scaley + love.graphics.getWindowHeight() * self.screenoy
	return x, y
end
function camera.class:unpos(x, y)
	x = (x or 0)
	y = (y or 0)
	x = (x - love.graphics.getWindowWidth() * self.screenox) / self.scalex
	y = (y - love.graphics.getWindowHeight() * self.screenoy) / self.scaley
	return self.ox + x * self.cosrot + y * self.sinrot, self.oy + y * self.cosrot - x * self.sinrot
end
function camera.class:transformBox(x, y, w, h)
	x, y = self:pos(x,y)
	w = w * self.scalex
	h = h * self.scaley
	if w < 0 then x = x + w; w = -w; end
	if h < 0 then y = y + h; h = -h; end
	return x, y, w, h
end
function camera.class:untransformBox(x, y, w, h)
	x, y = self:unpos(x,y)
	w = w / self.scalex
	h = h / self.scaley
	if w < 0 then x = x + w; w = -w; end
	if h < 0 then y = y + h; h = -h; end
	return x, y, w, h
end

-- How should scaling work for rotations?
function camera.class:scaleSym(s)
	return s * (self.scalex^2 / 2 + self.scaley^2 / 2)^0.5
end
function camera.class:unscaleSym(s)
	return s / (self.scalex^2 / 2 + self.scaley^2 / 2)^0.5
end
function camera.class:scale(x, y)
	return math.abs(x * self.scalex), math.abs(y * self.scaley)
end
function camera.class:getRotationSizeFactors(x,y)
	return math.abs(x * self.cosrot) + math.abs(y * self.sinrot),
		math.abs(y * self.cosrot) + math.abs(x * self.sinrot)
end
function camera.class:scaleWithRot(x, y)
	return math.abs(x * self.scalex * self.cosrot) + math.abs(y * self.scaley * self.sinrot),
		math.abs(y * self.scaley * self.cosrot) + math.abs(x * self.scalex * self.sinrot)
end
function camera.class:scaleX(x)
	return math.abs(x * self.scalex)
end
function camera.class:scaleY(y)
	return math.abs(y * self.scaley)
end
function camera.class:unscale(x, y)
	return math.abs(x / self.scalex), math.abs(y / self.scaley)
end
-- This cannot be determined if the rotation is 0.5pi or 1.5 pi.
function camera.class:unscaleWithRot(x, y)
	local	z = self.scalex * self.scaley * (self.cosrot^2 - self.sinrot^2)
	if z == 0 then
		-- Not a bug, should say 'x' on both sides.
		return self.scalex * x / (self.scalex + self.scaley), self.scaley * x / (self.scalex + self.scaley)
	end
	return (math.abs(x * self.cosrot * self.scaley) - math.abs(y * self.sinrot * self.scalex)) / z,
		(math.abs(y * self.cosrot * self.scalex) - math.abs(x * self.sinrot * self.scaley)) / z
end
function camera.class:unscaleX(x)
	return math.abs(x / self.scalex)
end
function camera.class:unscaleY(y)
	return math.abs(y / self.scaley)
end
function camera.class:setOrigin(ox,oy)
	self.ox = ox; self.oy = oy
end
function camera.class:getOrigin()
	return self.ox, self.oy
end
function camera.class:setRotation(rot)
	self.rotation = rot
	self.cosrot = math.cos(math.rad(self.rotation))
	self.sinrot = math.sin(math.rad(self.rotation))
end
function camera.class:rotateBy(rot, ox, oy)
	if ox then
		self.ox = self.ox + (ox - self.ox) * (1 - self.cosrot) + (oy - self.oy) * self.sinrot
		self.oy = self.oy + (oy - self.oy) * (1 - self.cosrot) - (ox - self.ox) * self.sinrot
	end
	self:setRotation((rot + self.rotation) % 360)
end
function camera.class:getRotation()
	return self.rotation
end
function camera.class:setScreenOrigin(ox,oy)
	self.screenox = ox; self.screenoy = oy
end
function camera.class:getScreenOrigin()
	return self.screenox, self.screenoy
end
function camera.class:setScaleFactor(sx, sy)
	self.scalex = sx; self.scaley = sy
end
function camera.class:scaleBy(sx, sy)
	sx = sx or 1
	sy = sy or sx
	self.scalex = self.scalex * sx
	self.scaley = self.scaley * sy
end
function camera.class:scaleXToAspectRatio()
	--self.scalex = love.graphics.getWindowWidth() / love.graphics.getWindowHeight() * self.scaley
	self.scalex = self.scaley
end
function camera.class:scaleYToAspectRatio()
	--self.scaley = love.graphics.getWindowHeight() / love.graphics.getWindowWidth() * self.scalex
	self.scaley = self.scalex
end
function camera.class:getScaleFactor()
	return self.scalex, self.scaley
end

camera.present = camera.new()
camera.mouseCamera = nil

function setCamera(cam)
	if cam then camera.present = cam end
end
function getCamera()
	return camera.present
end

function setMouseCamera(cam)
	camera.mouseCamera = cam
end
function getMouseCamera()
	return camera.mouseCamera
end

---- Superseding ----

camera.love.graphics.getWidth = love.graphics.getWidth
love.graphics.getWindowWidth = love.graphics.getWidth
function love.graphics.getWidth()
	return camera.present:unscaleX(love.graphics.getWindowWidth())
end
function love.graphics.getWidthWithRot()
	
end

camera.love.graphics.getHeight = love.graphics.getHeight
love.graphics.getWindowHeight = love.graphics.getHeight
function love.graphics.getHeight()
	return camera.present:unscaleY(love.graphics.getWindowHeight())
end

camera.love.graphics.setScissor = love.graphics.setScissor
function love.graphics.setScissor(x, y, w, h)
	if x and y then
		x, y, w, h = camera.present:transformBox(x, y, w, h)
		camera.love.graphics.setScissor(x, y, math.ceil(w), math.ceil(h)) --needed by Leif GUI
	else
		camera.love.graphics.setScissor()
	end
end

camera.love.graphics.getScissor = love.graphics.getScissor
function love.graphics.getScissor()
	local	x, y, w, h = camera.love.graphics.getScissor()
	if not x then return nil; end
	x, y, w, h = camera.present:untransformBox(x, y, w, h)
	return x, y, w, h
end

-- TODO: count line CRs?
function string.linecount(s)
	local	count = 0
	local	lf = string.byte("\n", 1)
	for i=1,s:len() do
		if s:byte(i) == lf then count = count + 1; end
	end
	return count+1
end

function string.lineiter(s)
	s = s.."\n"
	return s:gmatch("([^\r\n]*)\r*\n\r*")
end

function camera.isShapeVisible(shape)
	local	minvisx, minvisy, maxvisx, maxvisy = camera.love.graphics.getScissor()
	if minvisx then
		maxvisx = minvisx + maxvisx
		maxvisy = minvisy + maxvisy
	else
		minvisx = 1; maxvisx = love.graphics.getWindowWidth()
		minvisy = 1; maxvisy = love.graphics.getWindowHeight()
	end
	local	x1,y1,x2,y2,x3,y3,x4,y4 = shape:getBoundingBox()
	x1, y1 = getCamera():pos(x1, y1)
	x3, y3 = getCamera():pos(x3, y3)
	if getCamera().rotation ~= 0 then
		x2, y2 = getCamera():pos(x2, y2)
		x4, y4 = getCamera():pos(x4, y4)
		minx = math.min(x1, x2, x3, x4)
		miny = math.min(y1, y2, y3, y4)
		maxx = math.max(x1, x2, x3, x4)
		maxy = math.max(y1, y2, y3, y4)
	else
		minx = math.min(x1, x3)
		miny = math.min(y1, y3)
		maxx = math.max(x1, x3)
		maxy = math.max(y1, y3)
	end
	return maxx >= minvisx and minx <= maxvisx and maxy >= minvisy and miny <= maxvisy
end

-- Supports newlines
function camera.getTextWidth(text, font)
	font = font or love.graphics.getFont()
	local	maxwidth = 0
	for line in string.lineiter(text) do
		maxwidth = math.max(maxwidth, font:getWidth(line))
	end
	return maxwidth
end
function camera.getFontWidth(font, text)
	return camera.getTextWidth(text, font)
end

function camera.getTextHeight(text, limit, font)
	font = font or love.graphics.getFont()
	if limit then
		text = camera.splitTextByTextWidth(text, limit, font)
	end
	return text:linecount() * font:getHeight() * font:getLineHeight()
end

-- Height of text besides the first line.
function camera.getTextTailHeight(text, limit, font)
	font = font or love.graphics.getFont()
	if limit then
		text = camera.splitTextByTextWidth(text, limit, font)
	end
	return (text:linecount() - 1) * font:getHeight() * font:getLineHeight()
end

function camera.splitTextByTextWidth(text, width, font)
	font = font or love.graphics.getFont()
	local	s = ""
	for line in string.lineiter(text) do
		if camera.getTextWidth(line, font) <= width then
			s = s..line.."\n"
		else
			local	tmps = ""
			for token in line:gmatch("%s*[^%s]+") do
				if tmps:len() == 0 or camera.getTextWidth(tmps..token, font) <= width then
					tmps = tmps..token
				else
					s = s..tmps.."\n"
					--TODO remove preceding whitespaces
					tmps = token
				end
			end
			s = s..tmps.."\n"
		end
	end
	return s:sub(1,s:len()-1)
end

--TODO: particle system
camera.love.graphics.draw = love.graphics.draw
function love.graphics.draw(elem, x, y, angle, sx, sy)
	x, y = camera.present:pos(x,y)
	angle = (angle or 0) + camera.present.rotation
	sx = sx or 1
	sy = sy or sx
	sx = sx * (math.abs(math.cos(math.rad(angle))^2 * camera.present.scalex) +
		math.abs(math.sin(math.rad(angle))^2 * camera.present.scaley))
	sy = sy * (math.abs(math.cos(math.rad(angle))^2 * camera.present.scaley) +
		math.abs(math.sin(math.rad(angle))^2 * camera.present.scalex))
	if camera.present.scalex * camera.present.scaley < 0 then
		angle = -angle
	end
	local	nextElem = elem
	if type(elem) == "string" then
		local	c = love.graphics:getFont():getHeight() * love.graphics:getFont():getLineHeight()
		if camera.present.scaley < 0 then
			x = x - sx * c * math.sin(math.rad(angle))
			y = y + sy * c * math.sin(math.rad(angle))
		end
		for line in string.lineiter(elem) do
			camera.love.graphics.draw(line, x, y, angle, sx, sy)
			x = x - sx * c * math.sin(math.rad(angle))
			y = y + sy * c * math.cos(math.rad(angle))
		end
	else
		if not pcall(camera.love.graphics.draw, elem, x, y, angle, sx, sy) then
			camera.love.graphics.draw(elem, x, y)
		end
	end
end
function love.graphics.drawParticles(system, x, y)
	x, y = camera.present:pos(x,y)
	camera.love.graphics.draw(system, x, y)
end

camera.love.graphics.drawf = love.graphics.drawf
function love.graphics.drawf(s, x, y, limit, align, sx, sy)
	x, y = camera.present:pos(x,y)
	align = align or love.align_left
	s = camera.splitTextByTextWidth(s, limit * math.abs(camera.present.scalex))
	sx = sx or 1
	sy = sy or sx
	sx = sx * math.abs(camera.present.scalex)
	sy = sy * math.abs(camera.present.scaley)
	local	angle = camera.present.rotation
	local	cosrot = camera.present.cosrot
	local	sinrot = camera.present.sinrot
	if camera.present.scalex * camera.present.scaley < 0 then
		sinrot = -sinrot
		angle = -angle
	end
	limit = limit * math.abs(camera.present.scalex)
	local	mul = align == love.align_center and 0.5 or align == love.align_right and 1 or 0
	for line in string.lineiter(s) do
		local	width = sx * camera.getTextWidth(line)
		camera.love.graphics.draw(line, x + (limit - width) * mul * cosrot, y + (limit - width) * mul * sinrot, angle, sx, sy)
		x = x - sx * love.graphics:getFont():getHeight() * love.graphics:getFont():getLineHeight() * sinrot
		y = y + sy * love.graphics:getFont():getHeight() * love.graphics:getFont():getLineHeight() * cosrot
	end
end

--TODO ox, oy local or not?
camera.love.graphics.draws = love.graphics.draws
function love.graphics.draws(image, x, y, cx, cy, w, h, angle, sx, sy, ox, oy)
	angle = (angle or 0) + camera.present.rotation
	sx = sx or 1
	sy = sy or sx
	x, y = camera.present:pos(x,y)
	if ox and oy then
		ox, oy = camera.present:pos(ox,oy)
	end
	sx = sx * math.abs(camera.present.scalex)
	sy = sy * math.abs(camera.present.scaley)
	if camera.present.scalex * camera.present.scaley < 0 then
		angle = -angle
	end
	if ox and oy then
		camera.love.graphics.draws(image, x, y, cx, cy, w, h, angle, sx, sy, ox, oy)
	else
		camera.love.graphics.draws(image, x, y, cx, cy, w, h, angle, sx, sy)
	end
end

camera.love.graphics.point = love.graphics.point
function love.graphics.point(x, y)
	x, y = camera.present:pos(x,y)
	camera.love.graphics.point(x, y)
end

camera.love.graphics.line = love.graphics.line
function love.graphics.line(x1, y1, x2, y2)
	x1, y1 = camera.present:pos(x1, y1)
	x2, y2 = camera.present:pos(x2, y2)
	camera.love.graphics.line(x1, y1, x2, y2)
end

camera.love.graphics.triangle = love.graphics.triangle
function love.graphics.triangle(t, x1, y1, x2, y2, x3, y3)
	x1, y1 = camera.present:pos(x1, y1)
	x2, y2 = camera.present:pos(x2, y2)
	x3, y3 = camera.present:pos(x3, y3)
	camera.love.graphics.triangle(t, x1, y1, x2, y2, x3, y3)
end

camera.love.graphics.rectangle = love.graphics.rectangle
function love.graphics.rectangle(t, x, y, w, h)
	love.graphics.polygon(t, x, y, x + w, y, x + w, y + h, x, y + h)
end

camera.love.graphics.quad = love.graphics.quad
function love.graphics.quad(t, x1, y1, x2, y2, x3, y3, x4, y4)
	x1, y1 = camera.present:pos(x1, y1)
	x2, y2 = camera.present:pos(x2, y2)
	x3, y3 = camera.present:pos(x3, y3)
	x4, y4 = camera.present:pos(x4, y4)
	camera.love.graphics.quad(t, x1, y1, x2, y2, x3, y3, x4, y4)
end

-- Ovals not supported
camera.love.graphics.circle = love.graphics.circle
function love.graphics.circle(t, x, y, r, points)
	x, y = camera.present:pos(x, y)
	r = camera.present:scaleSym(r)
	if points then
		camera.love.graphics.circle(t, x, y, r, points)
	else
		camera.love.graphics.circle(t, x, y, r)
	end
end

camera.love.graphics.polygon = love.graphics.polygon
function love.graphics.polygon(t, ...)
	if #arg > 0 then
		if (type((arg[1])) == "table") then
			arg = arg[1]
		end
		if camera.present then
		for i=1,#arg/2 do
			arg[2*i-1],arg[2*i] = camera.present:pos(arg[2*i-1], arg[2*i])
		end
		end
		camera.love.graphics.polygon(t, unpack(arg))
	end
end

camera.love.graphics.setLineWidth = love.graphics.setLineWidth
function love.graphics.setLineWidth(width)
	camera.love.graphics.setLineWidth(camera.present:scaleX(width))
end

camera.love.graphics.setLine = love.graphics.setLine
function love.graphics.setLine(width, ...)
	camera.love.graphics.setLine(camera.present:scaleX(width), ...)
end

camera.love.graphics.getLineWidth = love.graphics.getLineWidth
function love.graphics.getLineWidth()
	return camera.present:unscaleX(camera.love.graphics.getLineWidth())
end

camera.love.graphics.setPointSize = love.graphics.setPointSize
function love.graphics.setPointSize(size)
	camera.love.graphics.setPointSize(camera.present:scaleSym(size))
end

camera.love.graphics.setPoint = love.graphics.setPoint
function love.graphics.setPoint(size, ...)
	camera.love.graphics.setPoint(camera.present:scaleSym(size), ...)
end

camera.love.graphics.getPointSize = love.graphics.getPointSize
function love.graphics.getPointSize()
	return camera.present:unscaleSym(camera.love.graphics.getPointSize())
end

camera.love.graphics.getMaxPointSize = love.graphics.getMaxPointSize
function love.graphics.getMaxPointSize()
	return camera.present:unscaleSym(camera.love.graphics.getMaxPointSize())
end

function camera.lateInit()
	camera.mousepressed_default = mousepressed or function() end
	camera.mousereleased_default = mousereleased or function() end
	camera.love.mouse.getX = love.mouse.getX
	camera.love.mouse.getY = love.mouse.getY
	camera.love.mouse.getPosition = love.mouse.getPosition
	camera.love.mouse.setPosition = love.mouse.setPosition
	function mousepressed(x, y, ...)
		local	oldCamera = getCamera()
		if camera.mouseCamera then
			setCamera(camera.mouseCamera)
		end
		x, y = camera.present:unpos(x,y)
		setCamera(oldCamera)
		local	ret = camera.mousepressed_default(x, y, ...)
		return ret
	end
	function mousereleased(x, y, ...)
		local	oldCamera = getCamera()
		if camera.mouseCamera then
			setCamera(camera.mouseCamera)
		end
		x, y = camera.present:unpos(x, y)
		setCamera(oldCamera)
		local	ret = camera.mousereleased_default(x, y, ...)
		return ret
	end
	function love.mouse.getX()
		local	x, y = camera.present:unpos(camera.love.mouse.getX(), camera.love.mouse.getY())
		return x
	end
	function love.mouse.getY()
		local	x, y = camera.present:unpos(camera.love.mouse.getX(), camera.love.mouse.getY())
		return y
	end
	function love.mouse.getPosition()
		return camera.present:unpos(camera.love.mouse.getPosition())
	end
	function love.mouse.setPosition(x, y)
		return camera.love.mouse.setPosition(unpack(camera.present:scale(x,y)))
	end
end
