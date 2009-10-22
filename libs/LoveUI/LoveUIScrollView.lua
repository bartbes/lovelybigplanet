--[[
Guide to LoveUI.ScrollView.

Properties:
	--Property
		--[Example Values] description
		
	hidden
		[true/false] set false to hide and disable scrollView
	enabled
		[true/false] whether to enable scrollBars
	opaque
		[true/false] whether to draw blackground
	backgroundColor
	
	setOffset(aPoint)
	
	addOffset(aPoint)
	
	setFrame(aFrame)
		to change origin, size of scrollView
	setSize(aSize)
]]--
--NEEDS TO BE REFACTORED.
--USE CASES TO DETERMINE IF SCOLLBARS NEEDED; I THINK THIS WILL BE THE MOST ACCURATE APPROACH
LoveUI.require("LoveUIView.lua")
LoveUI.require("LoveUIClipView.lua")
LoveUI.require("LoveUIScroller.lua");

LoveUI.ScrollView=LoveUI.View:new();

function LoveUI.ScrollView:init(frame, contentSize, ...)
	LoveUI.View.init(self, frame, ...)
	self.contentView=LoveUI.View:new(LoveUI.Rect:new(0, 0, contentSize:get()));
	self.scrollbarWidth=15;
	
	self.opaque=true;
	
	self.enabled=true
	
	self.horizontalScroller=nil;
	self.verticalScroller=nil;
	
	self.horizontalScrollerHidden=false
	self.verticalScrollerHidden=false;
	
	self:createScrollers()
	self:createClipView()
	return self;
end
function LoveUI.ScrollView:createScrollers()
	if self.horizontalScroller then
		self:removeSubview(self.horizontalScroller);
	end
	if self.verticalScroller then
		self:removeSubview(self.verticalScroller);
	end
	self.horizontalScroller=nil;
	self.verticalScroller=nil;
	
	--Check if fine without scrollers
	if (self.contentView.frame.size.width <= self.frame.size.width and self.contentView.frame.size.height <= self.frame.size.height) or (self.horizontalScrollerHidden and self.verticalScrollerHidden) then
		
		return nil;
	end
	
	
	local contentSize=self.contentView.frame.size:copy();
	--Check if fine with just vertical scroller
	if (not self.verticalScrollerHidden and self.contentView.frame.size.width <= self.frame.size.width) or self.horizontalScrollerHidden then
		
		self.verticalScroller=LoveUI.Scroller:new(LoveUI.Point:new(self.frame.size.width-self.scrollbarWidth, 0), self.frame.size.height, self.frame.size.height*self.frame.size.height/contentSize.height, self.scrollbarWidth, true);
		self:addSubview(self.verticalScroller)
		self.verticalScroller:setAction(self.verticalScrolled, LoveUI.EventDefault, self); 
			LoveUI.bind(self.verticalScroller, "enabled", self, "enabled",
				function (isenabled) return isenabled end, 
				function(isenabled, value) return nil; end);
		return nil;
	end
	
	--Check if fine with just horizontal scroller
	if (not self.horizontalScrollerHidden and self.contentView.frame.size.height <= self.frame.size.height) or self.verticalScrollerHidden then
		
		self.horizontalScroller=LoveUI.Scroller:new(LoveUI.Point:new(0, self.frame.size.height-self.scrollbarWidth), self.frame.size.width, self.frame.size.width*self.frame.size.width/contentSize.width, self.scrollbarWidth, false);
		
		self:addSubview(self.horizontalScroller)
		self.horizontalScroller:setAction(self.horizontalScrolled, LoveUI.EventDefault, self); 
		LoveUI.bind(self.horizontalScroller, "enabled", self, "enabled",
			function (isenabled) return isenabled end, 
			function(isenabled, value) return nil; end);
		return nil;
	end
	
	
	--set both scrollers if reached here.
	if self.verticalScrollerHidden or self.horizontalScrollerHidden then 
		return
	end
	
	self.horizontalScroller=LoveUI.Scroller:new(LoveUI.Point:new(0, self.frame.size.height-self.scrollbarWidth), self.frame.size.width-self.scrollbarWidth, self.frame.size.width*(self.frame.size.width-self.scrollbarWidth)/contentSize.width, self.scrollbarWidth, false);
		
	self.verticalScroller=LoveUI.Scroller:new(LoveUI.Point:new(self.frame.size.width-self.scrollbarWidth, 0), self.frame.size.height-self.scrollbarWidth, self.frame.size.height*(self.frame.size.height-self.scrollbarWidth)/contentSize.height, self.scrollbarWidth, true);
	
	self:addSubview(self.horizontalScroller, self.verticalScroller)
	
	self.horizontalScroller:setAction(self.horizontalScrolled, LoveUI.EventDefault, self); 
		LoveUI.bind(self.horizontalScroller, "enabled", self, "enabled",
			function (isenabled) 
				return isenabled
			end
		,	function(isenabled, value)
				return nil;
			end);
	
	self.verticalScroller:setAction(self.verticalScrolled, LoveUI.EventDefault, self); 
		LoveUI.bind(self.verticalScroller, "enabled", self, "enabled",
			function (isenabled) 
				return isenabled
			end
		,	function(isenabled, value)
				return nil;
			end);
end


function LoveUI.ScrollView:createClipView()
	
	local clipFrame=LoveUI.Rect:new(self.frame:get());
	if self.horizontalScroller then
		clipFrame.size.height=clipFrame.size.height-self.scrollbarWidth
	end
	if self.verticalScroller then
		clipFrame.size.width=clipFrame.size.width-self.scrollbarWidth
	end
	clipFrame.origin.y=0
	clipFrame.origin.x=0
	self.clipView=self.clipView or LoveUI.ClipView:new(clipFrame);
	self.clipView:setFrame(clipFrame)
	self.clipView:addSubview(self.contentView);
	self:addSubview(self.clipView);
	
	LoveUI.bind(self.clipView, "opaque", self, "opaque",
		function (isopaque) 
			return isopaque
		end
	,	function(isopaque, value)
			self.opaque=value;
		end);
end

function LoveUI.ScrollView:keyDown(theEvent)
	if theEvent.keyCode==love.key_up and self.verticalScroller then
		self:addOffset(LoveUI.Point:new(0, 10))
		return
	end
	
	if theEvent.keyCode==love.key_down and self.verticalScroller then
		self:addOffset(LoveUI.Point:new(0, -10))
		return
		
	end
	if theEvent.keyCode==love.key_right and self.horizontalScroller then
		self:addOffset(LoveUI.Point:new(-10, 0))
		return
		
	end
	if theEvent.keyCode==love.key_left and self.horizontalScroller then
		self:addOffset(LoveUI.Point:new(10, 0))
		return
		
	end
	
	LoveUI.Control.keyDown(self, theEvent);
end

function LoveUI.ScrollView:setContentSize(contentSize)
	self.contentView.frame.size=contentSize:copy();
	
	self.clipView:setOffset(LoveUI.Point:new(0,0))
	self.clipView:removeSubview(self.contentView);
	self:removeSubview(self.clipView);
	
	self:createScrollers()
	
	self:createClipView()
	if self.superview then
		self:calculateScissor();
	end
		
end

function LoveUI.ScrollView:hideHorizontalScroller()
	self.horizontalScrollerHidden=true
	self:setFrame(self.frame);
end

function LoveUI.ScrollView:hideVerticalScroller()
	self.horizontalScrollerHidden=true
	self:setFrame(self.frame);
end

function LoveUI.ScrollView:showHorizontalScroller()
	self.horizontalScrollerHidden=false
	self:setFrame(self.frame);
end

function LoveUI.ScrollView:showVerticalScroller()
	self.horizontalScrollerHidden=false
	self:setFrame(self.frame);
end


function LoveUI.ScrollView:setFrame(frame)
	self.frame=frame;
	self.clipView:setOffset(LoveUI.Point:new(0,0))
	self.clipView:removeSubview(self.contentView);
	self:removeSubview(self.clipView);
	
	self:createScrollers()
	self:createClipView()
	if self.superview then
		self:calculateScissor();
	end
end

function LoveUI.ScrollView:setSize(aSize)
	self:setFrame(LoveUI.Rect:new(self.frame.origin:get(), aSize:get()));
end


function LoveUI.ScrollView:setOffset(aPoint)
	if self.verticalScroller then
		self.verticalScroller:setValue(-aPoint.y/(self.contentView.frame.size.height-self.frame.size.height));
		self.clipView:setOffset(LoveUI.Point:new(self.clipView.offset.x, -self.verticalScroller:getValue()*(self.contentView.frame.size.height-self.frame.size.height)));
			
	end
	if self.horizontalScroller then
		self.horizontalScroller:setValue(-aPoint.x/(self.contentView.frame.size.width-self.frame.size.width));
		self.clipView:setOffset(LoveUI.Point:new(-self.horizontalScroller:getValue()*(self.contentView.frame.size.width-self.frame.size.width), self.clipView.offset.y));
	end

end

function LoveUI.ScrollView:addOffset(aPoint)
	local aPoint=self.clipView.offset+aPoint
	return self:setOffset(aPoint)
end

function LoveUI.ScrollView:display()
	if self.opaque then
		LoveUI.graphics.setColor(unpack(self.backgroundColor))
		LoveUI.graphics.rectangle('fill', self.frame:get())
	end
end

function LoveUI.ScrollView:postDisplay()
	--After displaying subviews
		LoveUI.graphics.setColor(0,0,0,0)
		LoveUI.graphics.rectangle('line',self.frame:get())
end


function LoveUI.ScrollView:acceptsFirstResponder()
	return true;
end

function LoveUI.ScrollView:mouseDown(anEvent)
	if anEvent.button==love.mouse_wheeldown and self.verticalScroller and self.enabled then
		local originalValue=self.verticalScroller:getValue()
		local newScrollerValue=-(self.clipView.offset.y-10)/(self.contentView.frame.size.height-self.frame.size.height);
		self.verticalScroller:setValue(newScrollerValue);
		--self.clipView:setOffset(LoveUI.Point:new(self.clipView.offset.x, -self.verticalScroller:getValue()*(self.contentView.frame.size.height-self.frame.size.height)));
		if self.verticalScroller:getValue()==originalValue then
			LoveUI.View.mouseDown(self, anEvent)
			return
		end
		return
	end
	if anEvent.button==love.mouse_wheelup and self.verticalScroller and self.enabled then
		local originalValue=self.verticalScroller:getValue()
		local newScrollerValue=-(self.clipView.offset.y+10)/(self.contentView.frame.size.height-self.frame.size.height);
		self.verticalScroller:setValue(newScrollerValue);
		self.clipView:setOffset(LoveUI.Point:new(self.clipView.offset.x, -self.verticalScroller:getValue()*(self.contentView.frame.size.height-self.frame.size.height))); -- WHY DO I NEED THIS LINE OF CODE??? omfg
		if self.verticalScroller:getValue()==originalValue then
			LoveUI.View.mouseDown(self, anEvent)
			return
		end
		return
	end
	LoveUI.View.mouseDown(self, anEvent)
end

function LoveUI.ScrollView:horizontalScrolled(sender, event, value)
	local o=0
	if self.verticalScroller then
		o=self.scrollbarWidth
	end
	self.clipView:setOffset(LoveUI.Point:new(-value*(self.contentView.frame.size.width-self.frame.size.width+o), self.clipView.offset.y))
end

function LoveUI.ScrollView:verticalScrolled(sender, event, value)
	local o=0
	if self.horizontalScroller then
		o=self.scrollbarWidth
	end
	self.clipView:setOffset(LoveUI.Point:new(self.clipView.offset.x, -value*(self.contentView.frame.size.height-self.frame.size.height+o)))
end

function LoveUI.ScrollView:removeScrollers()
	self:removeSubview(self.horizontalScroller);
	self:removeSubview(self.verticalScroller);
	self.horizontalScroller=nil;
	self.verticalScroller=nil;
end
