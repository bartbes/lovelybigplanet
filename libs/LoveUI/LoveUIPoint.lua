LoveUI.require("LoveUIObject.lua")
LoveUI.Point=LoveUI.Object:new();

function LoveUI.Point:init(x, y)
	self.x=x;
	self.y=y;
	return self;
end

LoveUI.Point:setmetamethod("__add", function (aPoint, bPoint)
	return LoveUI.Point:new(aPoint.x+bPoint.x, aPoint.y+bPoint.y);
end)

LoveUI.Point:setmetamethod("__sub", function (aPoint, bPoint)
	return LoveUI.Point:new(aPoint.x-bPoint.x, aPoint.y-bPoint.y);
end)

function LoveUI.Point:isEqual(aPoint)
	
	return self.x==aPoint.x and self.y==aPoint.y;
end

function LoveUI.Point:get()
	
	return self.x, self.y;
end

