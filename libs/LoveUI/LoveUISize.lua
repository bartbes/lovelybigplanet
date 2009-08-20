LoveUI.require("LoveUIObject.lua")
LoveUI.Size=LoveUI.Object:new();

function LoveUI.Size:init(w, h)
	self.width=w;
	self.height=h;
	return self;
end

function LoveUI.Size:isEqual(aSize)
	return self.width==aSize.width and self.height==aSize.height;
end

function LoveUI.Size:get()
	return self.width, self.height;
end

