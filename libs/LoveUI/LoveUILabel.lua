--[[
Guide to LoveUI.Label.

Properties:
	--Property
		--[Example Values] description
		
	hidden
		[true/false] set false to hide and disable Label
	textColor
		[love.graphics.newColor(0,0,0)] set to change text color
	opaque
		[true/false] whether to draw blackground
	value
		["aString"] set value
	backgroundColor
		[aColor] set background color
	font
		[aFont] set text font.
]]--

LoveUI.require("LoveUIControl.lua")
LoveUI.Label=LoveUI.Control:new()

function LoveUI.Label:init(frame, text)
	-- e.g local o=LoveUI.Object:alloc():init();
	LoveUI.Control.init(self, frame);
	self.value=text;
	self.opaque=true;
	self.font=LoveUI.DEFAULT_FONT
	self.backgroundColor=LoveUI.defaultBackgroundColor;
	self.textColor=LoveUI.defaultTextColor;
	return self;
end

function LoveUI.Label:display()
	--self.cell:display(self.frame, self);
	LoveUI.graphics.setFont(self.font);
	LoveUI.graphics.setColor(self.backgroundColor);
	if self.opaque then
		LoveUI.graphics.rectangle(2, 0, 0, self.frame.size:get());
	end
	LoveUI.graphics.setColor(self.textColor);
	LoveUI.graphics.draw(self.value, 10, self.frame.size.height/2+ self.font:getHeight()/2);
end

--function LoveUI.Button:update(dt)
	--self.cell:update(dt)
--end

--function LoveUI.Button:mouseDown(theEvent)
	--self.color=love.graphics.newColor(0, 0, 255);
		
	--self.cell:mouseDown(theEvent);
--end

--function LoveUI.Button:acceptsFirstResponder()
--	return self.enabled;
--end

--function LoveUI.Button:setAction(action, controlEvent, aTarget)
--	self.cell:setActionForEvent(action, controlEvent, aTarget)
--end

--function LoveUI.Button:mouseUp(theEvent)
--	self.cell:mouseUp(theEvent);	
--end