LoveUI.require("LoveUIObject.lua")
LoveUI.GraphicsEnvironment=LoveUI.Object:new();

function LoveUI.GraphicsEnvironment:init()
	-- e.g local o=LoveUI.Object:alloc():init();
	
	self.graphics={}
	self:store();
	return self;
end
--commented out to optimise; commented out parts don't need to be stored....... yet.
function LoveUI.GraphicsEnvironment:restore()
	if self.currentScissorFrame.origin.x~=nil then
		LoveUI.graphics.setScissor (self.currentScissorFrame.origin.x, self.currentScissorFrame.origin.y, self.currentScissorFrame.size.width, self.currentScissorFrame.size.height);
	else
		LoveUI.graphics.setScissor();
	end
	LoveUI.graphics.setColor(self.currentColor);
	LoveUI.graphics.setBackgroundColor(self.currentBackgroundColor);
	if self.currentFont then
		LoveUI.graphics.setFont(self.currentFont);
	end
	LoveUI.graphics.setLineWidth(self.currentLineWidth);
	LoveUI.graphics.setLineStyle(self.currentLineStyle);
	if self.currentLineStipplePattern and self.currentLineStippleRep then
		LoveUI.graphics.setLineStipple(self.currentLineStipplePattern, self.currentLineStippleRep);
	elseif self.currentLineStipplePattern then
		LoveUI.graphics.setLineStipple(self.currentLineStipplePattern)
	else
		LoveUI.graphics.setLineStipple()
	end
	LoveUI.graphics.setPointSize(self.currentPointSize);
	LoveUI.graphics.setPointStyle(self.currentPointStyle);
	LoveUI.graphics.setBlendMode(self.currentBlendMode);
	LoveUI.graphics.setColorMode(self.currentColorMode);
end

function LoveUI.GraphicsEnvironment:store()
	self.currentScissorFrame=LoveUI.Rect:new(LoveUI.graphics.getScissor())
	self.currentColor=LoveUI.graphics.getColor()
	self.currentBackgroundColor=LoveUI.graphics.getBackgroundColor()
	self.currentFont=LoveUI.graphics.getFont()
	self.currentLineWidth=LoveUI.graphics.getLineWidth()
	self.currentLineStyle=LoveUI.graphics.getLineStyle()
	self.currentLineStipplePattern, self.currentLineStippleRep=LoveUI.graphics.getLineStipple()
	self.currentPointSize=LoveUI.graphics.getPointSize()
	self.currentPointStyle=LoveUI.graphics.getPointStyle()
	self.currentBlendMode=LoveUI.graphics.getBlendMode()
	self.currentColorMode=LoveUI.graphics.getColorMode()
	
end
