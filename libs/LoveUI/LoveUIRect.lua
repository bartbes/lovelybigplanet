LoveUI.require("LoveUIObject.lua")
LoveUI.require("LoveUIPoint.lua")
LoveUI.require("LoveUISize.lua")
LoveUI.Rect=LoveUI.Object:new();

function LoveUI.Rect:init(x, y, width, height)
	self.origin=LoveUI.Point:new(x, y);
	self.size=LoveUI.Size:new(width, height);
	return self;
end

function LoveUI.Rect:get()
	return self.origin.x, self.origin.y, self.size.width, self.size.height;
end

function LoveUI.Rect:isEqual(aRect)
	return self.origin:isEqual(aRect.origin) and self.size:isEqual(aRect.size);
end