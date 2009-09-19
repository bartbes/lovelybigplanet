LoveUI.require("LoveUIView.lua");

LoveUI.TableViewHeaderCell=LoveUI.View:new();

function LoveUI.TableViewHeaderCell:init(frame, controlView)
	LoveUI.View.init(self, frame)
	self.textColor=LoveUI.defaultTextColor
	self.backgroundColor=LoveUI.defaultMetalColor;
	self.image=LoveUI:getImage("light-gloss-top-bottom.png");
	self.ascendingImage=LoveUI:getImage("heavy-gloss-top-bottom.png");
	self.descendingImage=self.ascendingImage;--LoveUI:getImage("light-gloss-bottom-top.png");
	self.borderImage=LoveUI:getImage("heavy-gloss-left-right.png");
	self.value="";
	self.enabled=true;
	self.opaque=true;
	self.controlView=controlView;
	self.state=LoveUI.OFF; -- 1, -1, or false
	return self;
end

function LoveUI.TableViewHeaderCell:display()
	LoveUI.View.display(self);
	
	local curImage;
	if (self.state == LoveUI.OFF) then
		curImage=self.image;
	elseif (self.state == LoveUI.ASCENDING) then 
		curImage=self.ascendingImage;
	elseif (self.state == LoveUI.DESCENDING) then 
		curImage=self.descendingImage;
	end
	
	local frame=self.frame;
	LoveUI.graphics.draw(curImage, frame.size.width/2, frame.size.height/2,0, frame.size.width/curImage:getWidth(), frame.size.height/curImage:getHeight());
	LoveUI.graphics.setFont(LoveUI.DEFAULT_FONT);
	LoveUI.graphics.setColor(unpack(self.textColor));
	LoveUI.graphics.draw(tostring(self.value) or '', 10, self.frame.size.height/2+5);
	LoveUI.graphics.setColor(unpack(0, 0, 0))
	LoveUI.graphics.line(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)
end


function LoveUI.TableViewHeaderCell:mouseUp(theEvent)
	LoveUI.View.mouseUp(self, theEvent);
	if (self.controlView.enabled) then
		if self.controlView.sorting then
		if (self.state == LoveUI.OFF) then 
			self.state=LoveUI.ASCENDING;
		elseif (self.state == LoveUI.ASCENDING) then 
			self.state=LoveUI.DESCENDING;
		elseif (self.state == LoveUI.DESCENDING) then 
			self.state=LoveUI.ASCENDING;
		end
		
		if (self.state~= LoveUI.OFF) then
			self.controlView:headerClicked(self, self.value, self.state);
		end
	end
	end
end
