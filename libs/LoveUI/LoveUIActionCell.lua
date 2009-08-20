LoveUI.require("LoveUICell.lua")
LoveUI.ActionCell=LoveUI.Cell:new()

function LoveUI.ActionCell:init(controlView, ...)
	-- e.g local o=LoveUI.Object:alloc():init();
	LoveUI.Cell.init(self, ...)
	self.controlEvents={};
	self.controlView=controlView
	return self;
end

function LoveUI.ActionCell:setActionForEvent(anAction, forControlEvent, aTarget)
	if type(anAction)~="function" then
		LoveUI.error("anAction must be a function that is called when event forControlEvent occurs.", 2)
	end
	if forControlEvent==nil then forControlEvent=LoveUI.EventDefault end
	if aTarget then
		self.controlEvents[forControlEvent]=function (...) anAction(aTarget, ...) end ;
	else
		self.controlEvents[forControlEvent]=anAction
	end
end

function LoveUI.ActionCell:activateControlEvent(sender, forControlEvent, ...)
	if self.controlEvents[forControlEvent]~=nil then
		self.controlEvents[forControlEvent](sender, ...);
	end
end