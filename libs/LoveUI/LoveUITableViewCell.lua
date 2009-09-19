LoveUI.require("LoveUIScrollView.lua");

LoveUI.TableViewCell=LoveUI.View:new();

function LoveUI.TableViewCell:init()
	LoveUI.View.init(self, LoveUI.Rect:new(0,0,0,0))
	self.textColor=LoveUI.defaultTextColor
	self.value="";
	self.enabled=true;
	self.opaque=false;
	return self;
end

function LoveUI.TableViewCell:display()
	LoveUI.View.display(self);
	LoveUI.graphics.setFont(LoveUI.DEFAULT_FONT);
	LoveUI.graphics.setColor(unpack(self.textColor));
	LoveUI.graphics.draw(tostring(self.value) or '', 10, self.frame.size.height/2+LoveUI.DEFAULT_FONT:getHeight()/2-2);
end
