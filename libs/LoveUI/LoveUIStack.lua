local LoveUI=LoveUI
LoveUI.require("LoveUIObject.lua")
LoveUI.Stack=LoveUI.Object:new();

function LoveUI.Stack:init(tableWithContent)
	if tableWithContent==nil then
		self.stack={}
	else
		LoveUI.checktable(tableWithContent);
		self.stack=tableWithContent;
	end
	return self;
end

function LoveUI.Stack:push(item)
	table.insert(self.stack, item)
end

function LoveUI.Stack:pop()
	local item = self.stack[#self.stack]
	table.remove(self.stack)
	return item
end

function LoveUI.Stack:peek()
	return self.stack[#self.stack];
end

function LoveUI.Stack:size()
	return #self.stack;
end