LoveUI.require("LoveUIActionCell.lua")
LoveUI.ButtonCell=LoveUI.ActionCell:new()

function LoveUI.ButtonCell:init(view, image, ...)
	-- e.g local o=LoveUI.Object:alloc():init();
	LoveUI.ActionCell.init(self, view, ...);
	self.image=image
	self.mouse_is_down=false
	self.key_is_down=false
	self.alternateImage=self.image;
	
	return self;
end


function LoveUI.ButtonCell:performClick(sender)
	
end

function LoveUI.ButtonCell:drawImage(frame, view)
	if self.controlView.enabled then
		LoveUI.graphics.setColor(self.controlView.backgroundColor)
	else
		LoveUI.graphics.setColor(255, 255, 255)
	end
	local size=frame.size;
	
	if view.opaque then
		LoveUI.graphics.rectangle(2, 0, 0, size.width, size.height)
	end
	local curImage=self.image;
	if self.state==LoveUI.ON then
		curImage=self.alternateImage
	end
	LoveUI.graphics.draw(curImage, frame.size.width/2, frame.size.height/2,0, frame.size.width/self.image:getWidth(), frame.size.height/self.image:getHeight());
end

function LoveUI.ButtonCell:mouseDown(theEvent)
	if theEvent.button~=love.mouse_left then
		if self.controlView.nextResponder then
			self.controlView.nextResponder:mouseDown(theEvent)
		end
		return;
	end
	--self.color=LoveUI.graphics.newColor(0, 0, 255);
	self.state=LoveUI.ON;
	self.mouse_is_down=true
end

function LoveUI.ButtonCell:update(dt)
	-- if mouse moves out then off the button. Might want to move this check to context to save processor.
	local aPoint=LoveUI.Point:new(love.mouse.getPosition());
	local aRect= self.controlView:convertRectToView(self.controlView.scissorFrame);
	if (self.mouse_is_down and LoveUI.mouseInRect(aPoint, aRect)) or self.key_is_down then
		self.state=LoveUI.ON
	else
		self.state=LoveUI.OFF
	end
end

function LoveUI.ButtonCell:display(frame, view)
	self:drawImage(frame, view);
	self:drawTitle(frame, view);
end

function LoveUI.ButtonCell:mouseUp(theEvent)
	if theEvent.button~=love.mouse_left then
		if self.controlView.nextResponder then
			self.controlView.nextResponder:mouseUp(theEvent)
		end
		return;
	end
	--self.color=LoveUI.graphics.newColor(0, 0, 255);
	if self.state==LoveUI.ON then
		self.state=LoveUI.OFF;
		self:activateControlEvent(self.controlView, LoveUI.EventDefault ,theEvent);
		self:activateControlEvent(self.controlView, LoveUI.EventMouseClicked ,theEvent);
	end
	self.mouse_is_down=false;
end
function LoveUI.ButtonCell:keyDown(theEvent)
	if (theEvent.keyCode== love.key_space or theEvent.keyCode== love.key_return) then
		
		--self.color=LoveUI.graphics.newColor(0, 0, 255);
		self.state=LoveUI.ON;
		self.key_is_down=true;
		return;
	end
	
	LoveUI.Control.keyDown(self.controlView, theEvent);
end

function LoveUI.ButtonCell:keyUp(theEvent)
	if (theEvent.keyCode== love.key_space or theEvent.keyCode== love.key_return) then
		if self.state==LoveUI.ON then
			self.state=LoveUI.OFF;
			self:activateControlEvent(self.controlView, LoveUI.EventDefault ,theEvent);
		end
		self.key_is_down=false;
		return;
	end
	LoveUI.Control.keyUp(self.controlView, theEvent);
end

function LoveUI.ButtonCell:drawTitle(frame, view)
	local curTitle=self.controlView.value;
	LoveUI.graphics.setFont(view.font);
	LoveUI.graphics.setColor(self.controlView.textColor);
	LoveUI.graphics.draw(self.controlView.value, frame.size.width/2-view.font:getWidth(self.controlView.value)/2, frame.size.height/2+view.font:getHeight()/2-1)
end