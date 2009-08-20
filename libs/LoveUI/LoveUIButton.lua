--[[
Guide to LoveUI.Button.

Properties:
	--Property
		--[Example Values] description
	tabAccessible
		[true/false] whether can select textfield with tab. default false.
	hidden
		[true/false] set false to hide and disable Button
	enabled
		[true/false] set false to disable Button
	textColor
		[love.graphics.newColor(0,0,0)] set to change text color
	opaque
		[true/false] whether to draw blackground
	title
		["aString"] set title
	backgroundColor
		[aColor] set background color
	font
		[aFont] set text font.
	setFrame(aFrame)
		to change origin, size of Button
		
	setAction(anAction, EventType, aTarget)
		Refer to LoveUI.lua, search for 'Control Events', possible Event Types are listed there. Not all are responded to. set eventType nil to use default.
]]--
LoveUI.require("LoveUIControl.lua")
LoveUI.require("LoveUIButtonCell.lua")
LoveUI.Button=LoveUI.Control:new()

function LoveUI.Button:init(frame)
	-- e.g local o=LoveUI.Object:alloc():init();
	LoveUI.Control.init(self,frame,  LoveUI.ButtonCell:new(self, LoveUI:getImage("light-gloss-bottom-top.png")) );
	self.enabled=true;
	self.state=LoveUI.OFF;
	self.value="Button";
	self.cellClass=LoveUI.ButtonCell;
	self.cell.alternateImage=LoveUI:getImage("heavy-gloss-top-bottom.png")
	self.opaque=true;
	self.textColor=LoveUI.defaultTextColor
	self.backgroundColor=LoveUI.defaultForegroundColor;
	return self;
end
--[[
function LoveUI.Button:copy()
	local cpy=LoveUI.Object.copy(self, "cell");
	return cpy
end
]]--
function LoveUI.Button:display()
	self.cell:display(self.frame, self);

end

function LoveUI.Button:update(dt)
	self.cell:update(dt)
end

function LoveUI.Button:mouseDown(theEvent)
	--self.color=love.graphics.newColor(0, 0, 255);
		
	self.cell:mouseDown(theEvent);
end

function LoveUI.Button:acceptsFirstResponder()
	return self.enabled;
end

function LoveUI.Button:setAction(action, controlEvent, aTarget)
	self.cell:setActionForEvent(action, controlEvent, aTarget)
end

function LoveUI.Button:mouseUp(theEvent)
	self.cell:mouseUp(theEvent);
end

function LoveUI.Button:keyDown(theEvent)
	self.cell:keyDown(theEvent);
end

function LoveUI.Button:keyUp(theEvent)
	self.cell:keyUp(theEvent);
end