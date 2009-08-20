LoveUI.require("LoveUIControl.lua")
LoveUI.require("LoveUIScrollerCell.lua")
LoveUI.require("LoveUIRect.lua")
LoveUI.Scroller=LoveUI.Control:new()


--[[
@param totalLength length of whole scroller
@param valuesLength effective range where values can be chosen.
]]--
function LoveUI.Scroller:init(location, totalLength, handleLength , thickness, isVertical)
	local frame;
	if isVertical then
		frame=LoveUI.Rect:new(location.x, location.y, thickness, totalLength)
	else
		frame=LoveUI.Rect:new(location.x, location.y, totalLength, thickness)
	end
	self.width=thickness
	
	
	self.vertical=isVertical or false;
	if self.vertical then
		self.cell=LoveUI.ScrollerCell:new(self, LoveUI:getImage("light-gloss-left-right.png"));
		self.cell.scrollerImage=LoveUI:getImage("heavy-gloss-right-left.png");
	else
		self.cell=LoveUI.ScrollerCell:new(self, LoveUI:getImage("light-gloss-top-bottom.png"));
		self.cell.scrollerImage=LoveUI:getImage("heavy-gloss-bottom-top.png");
	end
	
	LoveUI.Control.init(self, frame, self.cell);
	
	self.handleLength=handleLength;
	self.totalLength=totalLength;
	
	self.value=0;
	self.enabled=true;
	self.cellClass=LoveUI.ScrollerCell;
	
	self.opaque=true;
	self.backgroundColor=LoveUI.defaultBackgroundColor
	self.handleColor=LoveUI.defaultSecondaryColor
	return self;
end

function LoveUI.Scroller:getValue()
	return self.cell.value/(self.totalLength-self.handleLength)
end

function LoveUI.Scroller:setValue(v)
	self.cell.value=v*(self.totalLength-self.handleLength)
	self.cell:capValue();
end

function LoveUI.Scroller:display()
	self.cell:drawBackground(self.frame, self);
	self.cell:drawHandle(self.frame, self);
end

function LoveUI.Scroller:update(dt)
	self.cell:update(dt)
end

function LoveUI.Scroller:mouseDown(theEvent)
	self.cell:mouseDown(theEvent);
end

function LoveUI.Scroller:acceptsFirstResponder()
	return self.enabled;
end

function LoveUI.Scroller:setAction(action, controlEvent, aTarget)
	self.cell:setActionForEvent(action, controlEvent, aTarget);
end

function LoveUI.Scroller:mouseUp(theEvent)
	self.cell:mouseUp(theEvent);
	
end