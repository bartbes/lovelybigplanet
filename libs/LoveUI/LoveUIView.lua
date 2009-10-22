local LoveUI=LoveUI
LoveUI.require("LoveUIRect.lua")
LoveUI.require("LoveUIResponder.lua")
LoveUI.View=LoveUI.Responder:new();



function LoveUI.View:init(frame, ...)
	-- e.g local o=LoveUI.Object:alloc():init();
	LoveUI.Responder.init(self, frame, ...);
	self.frame=frame or LoveUI.Rect:new(-1,-1,-1,-1);
	self.scissorFrame=self.frame;
	self.subviews={};
	self.superview=nil;
	self.context=nil;
	self.opaque=false; 
	self.escapeScissor=false;
	self.hidden=false;
	self.backgroundColor=LoveUI.defaultBackgroundColor
	self.textColor=LoveUI.defaultTextColor;
	self.selectColor=LoveUI.defaultSelectColor
	return self;
end

function LoveUI.View:acceptsFirstResponder()
	return true;
end

function LoveUI.View:setFrame(aFrame)
	self.frame=aFrame;
	self:calculateScissor();
end

function LoveUI.View:setOrigin(aPoint)
	self.frame.origin=aPoint:copy();
	self:calculateScissor();
end

function LoveUI.View:setSize(aSize)
	self.frame.size=aSize:copy();
	self:calculateScissor();
end

function LoveUI.View:display()
	--error(tostring(self.class.className()))
	--if self.class.className()=="Button" then error("b") end
	if self.opaque then
		local size=self.frame.size;
		LoveUI.graphics.setColor(unpack(self.backgroundColor))
		LoveUI.graphics.rectangle('fill', 0, 0, size.width, size.height)
	end
end


function LoveUI.View:toSubviews(fn)
	fn(self);
	for k, v in pairs(self.subviews) do
		if fn(v) == false then
			return false;
		end
		v:toSubviews(fn);
	end
end
function LoveUI.View:update(dt)
	if not self.hidden then
	end
end

function LoveUI.View:convertOriginToBase()
	local p=self.superview:convertPointToBase(self.frame.origin)
	return p.x, p.y;
end

function LoveUI.View:updateSubviews(dt)
	if not self.hidden then
		for k, v in pairs(self.subviews) do
			if not v.hidden then
				LoveUI.pushMatrix()
				LoveUI.translate(v.frame.origin:get())
				v:update(dt);
				v:updateSubviews(dt);
				LoveUI.popMatrix()
			end
		end
	end
end

function LoveUI.View:calculateScissor()
	if self.superview then
		local super_frame=self:convertRectFromView(self.superview.scissorFrame, self.superview)
		local child_frame=self:convertRectFromView(self.frame, self);
		local x1, y1, x2, y2 = math.max(super_frame.origin.x, 0), math.max(super_frame.origin.y, 0), 
		math.min(super_frame.size.width+super_frame.origin.x, child_frame.size.width), 
		math.min(super_frame.size.height+super_frame.origin.y, child_frame.size.height);
		self.scissorFrame=LoveUI.Rect:new(x1, y1, x2-x1, y2-y1);
		for i, v in ipairs(self.subviews) do
			v:calculateScissor()
		end
	end
end

function LoveUI.View:getScissor()
	if not self.scissorFrame then
		self:calculateScissor();
	end
	return self.scissorFrame:get();
end

function LoveUI.View:displaySubviews()
	--a View is responsible for drawing itself and subviews
	if not self.hidden then
		for k, v in pairs(self.subviews) do
			if not v.hidden then
				
				self.context:store()
				LoveUI.pushMatrix()
				LoveUI.translate(v.frame.origin:get())
				v:preDisplay()
				
				if not v.escapeScissor then
					LoveUI.graphics.setScissor(v:getScissor())
				else
					LoveUI.graphics.setScissor();
				end
				
					v:display();
				
					v:displaySubviews();
					
				LoveUI.popMatrix()
				v:postDisplay()
				self.context:restore()
				
			end
		end
	end
end

function LoveUI.View:preDisplay()
end

function LoveUI.View:postDisplay()
	local size=self.frame.size;
	if self.tabAccessible and self.context.firstResponder == self then
		LoveUI.graphics.setColor(unpack(LoveUI.defaultSelectBgColor))
		LoveUI.graphics.rectangle('fill', self.frame.origin.x+1, self.frame.origin.y+1 , size.width-2, size.height-2)
	end
end

function LoveUI.View:getIndex()
	if self.superview then
		for k, v in pairs(self.superview.subviews) do
			if v==self then
				return k
			end
		end
	end
end

function LoveUI.View:getPreviousView()
	if not self.superview then return nil end;
	local k=self:getIndex();
	if k-1>=1 then
		return self.superview.subviews[k-1]
	end
	return nil;
end

function LoveUI.View:getPreviousViewInHierarchy()

	if #self.subviews>=1 then
		return self.subviews[#self.subviews]
	end
	
	local previousView;
	previousView=self:getPreviousView();
	
	if previousView then
		return previousView;
	end
	
	local pSuper=self.superview
	nextView=pSuper:getPreviousView()
	while not previousView do
		pSuper=pSuper.superview
		if not pSuper then
			break;
		end
		previousView=pSuper:getPreviousView()
		if previousView then
			break;
		end
	end
	
	if previousView then
		return previousView;
	else
		return self.context.contentView
	end
	
end
function LoveUI.View:getNextView()
	if not self.superview then return nil end;
	local k=self:getIndex();
	return self.superview.subviews[k+1]
end

function LoveUI.View:getNextViewInHierarchy()

	if #self.subviews>=1 then
		return self.subviews[1]
	end
	
	local nextView;
	nextView=self:getNextView();
	
	if nextView then
		return nextView;
	end
	
	local pSuper=self.superview
	nextView=pSuper:getNextView()
	while not nextView do
		pSuper=pSuper.superview
		if not pSuper then
			break;
		end
		nextView=pSuper:getNextView()
		if nextView then
			break;
		end
	end
	
	if nextView then
		return nextView;
	else
		return self.context.contentView
	end
	
end

function LoveUI.View:getNextTabAccessControl()
	local nextView=self;--=self:getNextView();
	while true do
		nextView=nextView:getNextViewInHierarchy();
		if nextView.tabAccessible and not nextView.hidden and nextView.enabled and nextView.context and nextView:acceptsFirstResponder() then
			self.context:setFirstResponder(nextView);
			break;
		end
		if nextView==self then
			return false;
		end
	end
	
	return true
end

function LoveUI.View:getPreviousTabAccessControl()
	local previousView=self;--=self:getNextView();
	while true do
		previousView=previousView:getPreviousViewInHierarchy();
		if previousView.tabAccessible and not previousView.hidden and previousView.enabled and previousView.context and previousView:acceptsFirstResponder() then
			self.context:setFirstResponder(previousView);
			break;
		end
		if previousView==self then
			return false;
		end
	end
	
	return true
end

function LoveUI.View:keyDown(theEvent)
	if theEvent.keyCode==love.key_tab and (self.tabAccessible or self==self.context.contentView) then
		if theEvent.keysDown[love.key_lshift] or theEvent.keysDown[love.key_rshift] then
			self:getPreviousTabAccessControl();
		else
			self:getNextTabAccessControl();
		end
		
	else
		LoveUI.Responder.keyDown(self, theEvent);
	end
end


function LoveUI.View:removeSubview(...)
	local views={...};
	for k, aView in pairs(views) do
		for l, v in pairs(self.subviews) do
			if v==aView then
				table.remove(self.subviews, l);
				aView.superview=nil;
				aView.context=nil;
				aView.nextResponder=nil;
				break;
			end
		end
	end
end

function LoveUI.View:apply(t)
	for k, v in pairs(t) do
		self[k]=v;
	end
end

function LoveUI.View:addSubview(...)
	local views={...};
	for k, aView in pairs(views) do
		if aView.superview==nil then
			self.subviews[#self.subviews+1]=aView
			aView.superview=self;
			aView.context=self.context;
			aView.nextResponder=self;
			aView:toSubviews(function (v) v.context=self.context end)
			aView:calculateScissor();
		else
			LoveUI.error("View to be added already has a super view! It must be removed from its super view's subviews before being added to a view as a subview again! You can copy views by going aView:copy(), which returns a copy")
		end
	end
	
end

function LoveUI.View:lastSubview()
	local lastIndex=#self.subviews;
	while self.subviews[lastIndex].hidden do
		if lastIndex==0 then
			return nil
		end
		lastIndex=lastIndex-1;
	end
	return self.subviews[lastIndex];
end

function LoveUI.View:mouseInRect(aPoint, aRect)
	return LoveUI.mouseInRect(aPoint, aRect) and not self.hidden
end

function LoveUI.View:convertPointToBase(aPoint)
	--each view's origin is in its superview's coord system
	local view=self;
	local x=aPoint.x
	local y=aPoint.y
	while view~=nil do
		x=x+view.frame.origin.x;
		y=y+view.frame.origin.y;
		view=view.superview;
	end
	return LoveUI.Point:new(x, y)
end

function LoveUI.View:convertPointFromBase(aPoint)
	local view=self;
	local x=aPoint.x
	local y=aPoint.y
	while view~=nil do
		x=x-view.frame.origin.x;
		y=y-view.frame.origin.y;
		view=view.superview;
	end
	return LoveUI.Point:new(x, y)
end

function LoveUI.View:convertRectToView(aRect, aView)
	local originThatView=0;
	if aView~=nil then
		originThatView=aView:convertPointFromBase(self:convertPointToBase(aRect.origin));
	else
		originThatView=self:convertPointToBase(aRect.origin);
	end
	return LoveUI.Rect:new(originThatView.x, originThatView.y, aRect.size.width, aRect.size.height);
end

function LoveUI.View:convertRectFromView(aRect, aView)
	local originThisView=0;
	if aView~=nil then
		originThisView=self:convertPointFromBase(aView:convertPointToBase(aRect.origin));
	else
		originThisView=self:convertPointFromBase(aRect.origin);
	end
	return LoveUI.Rect:new(originThisView.x, originThisView.y, aRect.size.width, aRect.size.height);
end

function LoveUI.View:bringToFront()

end
