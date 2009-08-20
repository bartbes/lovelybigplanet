LoveUI.TextView=LoveUI.Control:new();

function LoveUI.TextView:init(frame, contentSize, ...)
	LoveUI.Control.init(self, frame, ...)
	self.value=""
	self.enabled=true
	self.opaque=true;
	self.tabAccessible=true
	self.contentView=LoveUI.View:new(LoveUI.Rect:new(0,0,contentSize:get()));
	self.contentView.opaque=true
	self.contentView.display=function(view)
		love.graphics.setFont(LoveUI.DEFAULT_FONT)
		love.graphics.setColor(LoveUI.defaultTextColor);
		LoveUI.graphics.drawf(self.value, 10, 20, contentSize.width-30);
	end
	self.scrollView=LoveUI.ScrollView:new(LoveUI.Rect:new(0,0,frame.size:get()), contentSize);
	self.scrollView.contentView:addSubview(self.contentView)
	self.scrollView.nextResponder=self.nextResponder
	self.nextResponder=self.scrollView
	self:addSubview(self.scrollView)
	
	--bind scrollviews values to this one.
	LoveUI.bind(self.scrollView, "enabled", self, "enabled",
			function (isenabled) 
				return isenabled
			end
		,	function(isenabled, value)
				return nil;
			end);
			
	LoveUI.bind(self.scrollView, "opaque", self, "opaque",
			function (isopaque) 
				return isopaque
			end
		,	function(isopaque, value)
				return nil;
			end);
			
	return self;
end

function LoveUI.TextView:keyDown(theEvent)
	if theEvent.keyCode==love.key_up then
		self.scrollView:addOffset(LoveUI.Point:new(0, 10))
		return
		
	end
	if theEvent.keyCode==love.key_down then
		self.scrollView:addOffset(LoveUI.Point:new(0, -10))
		return
		
	end
	if theEvent.keyCode==love.key_right then
		self.scrollView:addOffset(LoveUI.Point:new(-10, 0))
		return
		
	end
	if theEvent.keyCode==love.key_left then
		self.scrollView:addOffset(LoveUI.Point:new(10, 0))
		return
		
	end
	
	LoveUI.View.keyDown(self, theEvent);
end



function LoveUI.TextView:setFrame(aFrame)
	self.frame=aFrame;
	self.scrollView:setFrame(LoveUI.Rect:new(0,0,aFrame.size:get()));
	self:calculateScissor();
end

function LoveUI.TextView:setSize(aSize)
	self.frame.size=aSize:copy();
	self.scrollView:setFrame(LoveUI.Rect:new(0,0,aSize:get()));
	self:calculateScissor();
end
