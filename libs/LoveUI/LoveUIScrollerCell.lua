LoveUI.require("LoveUIActionCell.lua")
LoveUI.ScrollerCell=LoveUI.ActionCell:new()

function LoveUI.ScrollerCell:init(view, image, ...)
	-- e.g local o=LoveUI.Object:alloc():init();
	LoveUI.ActionCell.init(self, view, image, ...);
	self.value=0
	self.image=image;
	self.handleDragged=false;
	self.lastMouseDownEvent=nil;
	return self;
end

function LoveUI.ScrollerCell:drawBackground(frame, view)
	LoveUI.graphics.setColor(unpack(self.controlView.backgroundColor))
	local size=frame.size;
	if view.opaque then
		LoveUI.graphics.rectangle(2, 0, 0, size.width, size.height)
	end
	LoveUI.graphics.draw(self.image, frame.size.width/2, frame.size.height/2,0, frame.size.width/self.image:getWidth(), frame.size.height/self.image:getHeight());
end

function LoveUI.ScrollerCell:drawHandle(frame, view)
	if self.controlView.enabled then
		LoveUI.graphics.setColor(unpack(self.controlView.handleColor))
	end
	local size;
	
	if view.vertical then
		size=LoveUI.Size:new(frame.size.width-2, view.handleLength);
	else
		size=LoveUI.Size:new(view.handleLength, frame.size.height-2);
	end
	
	local ho, vo=0, 0;
	if view.vertical then
		ho=1;
		vo=1+self.value;
	else
		vo=1;
		ho=1+self.value;
	end
	if view.opaque then
		LoveUI.graphics.rectangle(2, ho, vo, size.width, size.height)
	end
	local curImage=self.scrollerImage
	
	local frame=self:getHandleFrame();
	
	LoveUI.graphics.draw(curImage, frame.size.width/2 + frame.origin.x, frame.size.height/2 + frame.origin.y,0, frame.size.width/self.scrollerImage:getWidth(), frame.size.height/self.scrollerImage:getHeight());
end

function LoveUI.ScrollerCell:getHandleFrame()
	local frame=LoveUI.Rect:new(0,0,0,0);
	if self.controlView.vertical then
		frame.size=LoveUI.Size:new(self.controlView.frame.size.width-2, self.controlView.handleLength);
		frame.origin=LoveUI.Point:new(1, 1+self.value);
	else
		frame.size=LoveUI.Size:new(self.controlView.handleLength, self.controlView.frame.size.height-2);
		frame.origin=LoveUI.Point:new(1+self.value, 1);
	end
	return frame;
end

function LoveUI.ScrollerCell:mouseDown(theEvent)
	if theEvent.button~=love.mouse_left then
		if self.controlView.nextResponder then
			self.controlView.nextResponder:mouseDown(theEvent)
		end
		return;
	end
	--self.color=LoveUI.graphics.newColor(0, 0, 255);
	if LoveUI.mouseInRect(theEvent.mouseLocation, self.controlView:convertRectToView(self:getHandleFrame())) then
		self.state=LoveUI.ON;
		self.handleDragged=true;
		self.lastMouseDownEvent=theEvent;
		self.lastMouseDownEvent.value=self.value
	elseif  LoveUI.mouseInRect(theEvent.mouseLocation, self.controlView.superview:convertRectToView(self.controlView.frame)) then
		self.handleDragged=false;
		--jump handler
		local bOriginX, bOriginY=self.controlView:convertOriginToBase()
		local m;
		if self.controlView.vertical then
			if (bOriginY+ self.value - theEvent.mouseLocation.y) > 0 then m=-1 else m=1 end;
			self.value=self.value+ self.controlView.handleLength*m --bOriginY - 19
		else
			if (bOriginX+ self.value - theEvent.mouseLocation.x) > 0 then m=-1 else m=1 end;
			self.value=self.value+ self.controlView.handleLength*m --bOriginX - 19
		end
		self:capValue();
	end
end

function LoveUI.ScrollerCell:update(dt)
	-- if mouse moves out then off the view. Might want to move this check to context to save processor.
	local aPoint=LoveUI.Point:new(love.mouse.getPosition());
	local aRect= self.controlView.superview:convertRectToView(self.controlView.frame);
	if self.state==LoveUI.ON and self.handleDragged then
		local dv=0;
		local mousePosition=LoveUI.Point:new(love.mouse.getPosition());
		local handleFrame=self.controlView:convertRectToView(self:getHandleFrame());
		if self.controlView.vertical then
			dv=mousePosition.y-self.lastMouseDownEvent.mouseLocation.y;
			self.value=dv+self.lastMouseDownEvent.value
		else
			dv=mousePosition.x-self.lastMouseDownEvent.mouseLocation.x;
			self.value=dv+self.lastMouseDownEvent.value
		end
		
		self:capValue();
		
	end
end

function LoveUI.ScrollerCell:capValue()
	if self.value > 1 then
		self.value=math.min(self.value, self.controlView.totalLength- self.controlView.handleLength - 2);
	else
		self.value=math.max(0, self.value);
	end
	self:activateControlEvent(self.controlView, LoveUI.EventDefault ,theEvent, self.controlView:getValue());
	self:activateControlEvent(self.controlView, LoveUI.EventValueChanged ,theEvent, self.controlView:getValue());
end

function LoveUI.ScrollerCell:mouseUp(theEvent)
	if theEvent.button~=love.mouse_left then
		if self.controlView.nextResponder then
			self.controlView.nextResponder:mouseUp(theEvent)
		end
		return;
	end
	--self.color=LoveUI.graphics.newColor(0, 0, 255);
	self.handleDragged=false;
	if self.state==LoveUI.ON then
		self.state=LoveUI.OFF;
		self:activateControlEvent(self.controlView, LoveUI.EventMouseClicked ,theEvent);
	end
	self.mouse_is_down=false;
end
