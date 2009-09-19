--[[
Copyright (c) 2009 Bart Bes

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
]]

console = {}

local console_mt = { __index = console }

function console:create()
	local t = setmetatable({}, console_mt)
	t:load()
	return t
end

function console:load()
	self.font = love.graphics.newFont(love._vera_ttf, 10)
	self.color = {200, 200, 255, 200}
	self.visible = false
	self.yperc = 30
	self.currentline = ""
	self.scrollback = {}
	self.scrollbacklength = 30
	self.oldcommands = {}
	self.oldcommandlength = 10
	self.oldcommandindex = 0
	self.fenv = _G
	self.outf = function(...) self:print(...) end
	self.quitf = love.event.quit
	function self.printoverride(...)
		self.outf(...)
	end
	function self.quitoverride()
		self.quitf()
	end
	self.mt = {}
	function self.mt.__index(t, i)
		if i == "print" then
			return self.printoverride
		elseif i == "quit" then
			return self.quitoverride
		end
		return self.fenv[i]
	end
	function self.mt.__newindex(t, i, v)
		self.fenv[i] = v
	end
	self.env = setmetatable({}, self.mt)
end

function console:setOutputFunction(f)
	self.outf = f
end

function console:setfenv(t)
	self.fenv = t
end

function console:setQuitFunction(f)
	self.quitf = f
end

function console:update(dt)
end

function console:draw()
	if not self.visible then return end
	local oldColor = {love.graphics.getColor()}
	local oldFont = love.graphics.getFont()
	local width, height = love.graphics.getWidth(), love.graphics.getHeight()
	local bottom = height*(self.yperc/100)
	love.graphics.setColor(unpack(self.color))
	love.graphics.setFont(self.font)
	love.graphics.rectangle(love.draw_fill, 0, 0, width, bottom)
	love.graphics.setColor(255, 255, 255, 200)
	local max = #self.scrollback
	for i, v in ipairs(self.scrollback) do
		love.graphics.print(v, 0, bottom-14-12*(max-i))
	end
	love.graphics.line(0, bottom, width, bottom)
	love.graphics.line(0, bottom-12, width, bottom-12)
	love.graphics.print(self.currentline, 0, bottom-2)
	love.graphics.setColor(unpack(oldColor))
	if oldFont then love.graphics.setFont(oldFont) end
end

function console:toggle()
	self.visible = not self.visible
end

function console:setVisible(vis)
	self.visible = vis
end

function console:setToggleKey(key)
	self.toggleKey = key
end

function console:keypressed(key, u)
	if not self.visible and key ~= self.toggleKey then
		return false
	end
	if key == self.toggleKey then
		self:toggle()
	elseif key == love.key_backspace then
		self.currentline = self.currentline:sub(1, -2)
	elseif key == love.key_return then
		self:execute(self.currentline)
		self.currentline = ""
	elseif key == love.key_up then
		if self.oldcommandindex > 1 then
			self.oldcommandindex = self.oldcommandindex - 1
			self.currentline = self.oldcommands[self.oldcommandindex]
		end
	elseif key == love.key_down then
		if self.oldcommandindex <= #self.oldcommands then
			self.oldcommandindex = self.oldcommandindex + 1
			if self.oldcommandindex <= #self.oldcommands then
				self.currentline = self.oldcommands[self.oldcommandindex]
			else
				self.currentline = ""
			end
		end
	elseif u ~= 0 then
		self.currentline = self.currentline .. string.char(u)
	end
	return true
end

function console:keyreleased(key, u)
	if not self.visible then
		return false
	end
	return true
end

function console:print(...)
	local t = {...}
	for i, v in pairs(t) do
		t[i] = tostring(v)
	end
	local str = table.concat(t, "      ")
	for s in str:gmatch("[^\n]+") do
		table.insert(self.scrollback, s)
	end
	if #self.scrollback == self.scrollbacklength then
		table.remove(self.scrollback, 1)
	end
end

function console:execute(text)
	text = text:gsub("^=", "return ")
	table.insert(self.oldcommands, text)
	if #self.oldcommands == self.oldcommandlength then
		table.remove(self.oldcommands, 1)
	end
	self.oldcommandindex = #self.oldcommands+1
	self.outf("> " .. text)
	local block, err = loadstring(text, "Console input")
	if not block then
		self:print(err)
	else
		setfenv(block, self.env)
		self:print(select(2, pcall(block)))
	end
end
