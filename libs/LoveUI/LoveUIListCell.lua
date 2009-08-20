LoveUI.ListCell=LoveUI.View:new();

function LoveUI.ListCell:init(frame, contentView, theListView, index, ...)
	LoveUI.View.init(self, frame, ...)
	self.value=""
	self.listView=theListView;
	self.contentView=contentView;
	self.index=index;
	self:addSubview(contentView);
	self.textColor=LoveUI.defaultTextColor
	self.selected=false;
	self.enabled=true;
	self.opaque=true
	return self;
end

function LoveUI.ListCell:display()
	LoveUI.View.display(self);
	LoveUI.graphics.setFont(LoveUI.DEFAULT_FONT);
	if self.selected then
		if self.enabled then
			LoveUI.graphics.setColor(self.listView.selectColor);
		else
			LoveUI.graphics.setColor(50,50,50,32);
		end
		LoveUI.graphics.rectangle(2, 0,0,self.frame.size:get())
	end
	LoveUI.graphics.setColor(self.textColor);
	LoveUI.graphics.draw(tostring(self.value) or '', 10, 20);
end

function LoveUI.ListCell:setContentView(aView)
	if self.subviews[1] then
		self.removeSubview(self.subviews[1])
	end
	--aView=aView:copy();
	self:addSubview(aView);
	self.contentView=aView;
	self.contentView:setFrame(LoveUI.Rect:new(0,0, self.frame.size:get()))
end

function LoveUI.ListCell:mouseDown(theEvent)
	if theEvent.button==love.mouse_left and self.enabled then
		self.listView:setSelectedIndex(self.index, theEvent);
	else
		if self.nextResponder then
			self.nextResponder:mouseDown(theEvent)
		end
	end
end
