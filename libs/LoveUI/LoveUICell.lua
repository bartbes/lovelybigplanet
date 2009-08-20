LoveUI.require("LoveUIObject.lua")
LoveUI.Cell=LoveUI.Object:new();

function LoveUI.Cell:init(value, ...)
	-- e.g local o=LoveUI.Object:alloc():init();
	self.value=value;
	
	self.backgroundColor=LoveUI.graphics.newColor(255, 255, 255);
	
	self.enabled=true;
	
	self.bezeled=true; -- has gloss or not
	
	self.bordered=false; -- has border or not
	
	self.opaque=nil; -- has background or not
	
	self.state=LoveUI.OffState;
	
	self.font=LoveUI.defaultFont;
	
	return self;
end

function LoveUI.Cell:mouseDown(theEvent)

end

function LoveUI.Cell:display(frame, view)

end

function LoveUI.Cell:mouseUp(theEvent)

end

function LoveUI.Cell:performClick(sender)
	
end