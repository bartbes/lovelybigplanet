LoveUI.require("LoveUIView.lua")
LoveUI.require("LoveUIPoint.lua")

LoveUI.ClipView=LoveUI.View:new();
function LoveUI.ClipView:init(frame, ...)
	LoveUI.View.init(self, frame, ...)
	self.offset=LoveUI.Point:new(0,0);
	self.opaque=true;
	return self;
end

function LoveUI.ClipView:getOffset()
	return self.offset
end

function LoveUI.ClipView:addOffset(aPoint)
	aPoint.x=math.floor(aPoint.x)
	aPoint.y=math.floor(aPoint.y)
	for k, view in pairs(self.subviews) do
		view.frame.origin=view.frame.origin-self.offset;
	end
	self.offset=self.offset+aPoint
	for k, view in pairs(self.subviews) do
		view.frame.origin=view.frame.origin+self.offset;
	end
	self:calculateScissor();
end

function LoveUI.ClipView:setOffset(aPoint)
	aPoint.x=math.floor(aPoint.x)
	aPoint.y=math.floor(aPoint.y)
	for k, view in pairs(self.subviews) do
		view.frame.origin=view.frame.origin-self.offset;
	end
	self.offset=aPoint
	for k, view in pairs(self.subviews) do
		view.frame.origin=view.frame.origin+self.offset;
	end
	self:calculateScissor();
end

function LoveUI.ClipView:addSubview(...)
	--table.insert(self.subviews, aView);
	for k, view in pairs({...}) do
		view.frame.origin=view.frame.origin+self.offset;
	end
	LoveUI.View.addSubview(self, ...)
end

function LoveUI.ClipView:getContentSize()
	local rightestEdge, bottomestEdge=0, 0;
	for k, view in pairs(self.subviews) do
		if view.frame.origin.x+view.frame.size.width > rightestEdge then
			rightestEdge=view.frame.origin.x+view.frame.size.width
		end
		if view.frame.origin.y+view.frame.size.height > bottomestEdge then
			bottomestEdge=view.frame.origin.y+view.frame.size.height
		end
	end
	return LoveUI.Size:new(math.max(rightestEdge, self.frame.size.width), math.max(bottomestEdge, self.frame.size.height))
end

