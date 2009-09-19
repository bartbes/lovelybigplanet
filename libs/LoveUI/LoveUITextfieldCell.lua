LoveUI.require("LoveUIActionCell.lua")
LoveUI.TextfieldCell=LoveUI.ActionCell:new();

function LoveUI.TextfieldCell:init(view, image, ...)
	-- e.g local o=LoveUI.Object:alloc():init();
	LoveUI.ActionCell.init(self, view, ...);
	self.image=image
	--self.backgroundColor=LoveUI.graphics.newColor(255, 255, 255);
	self.selectStart=0; -- position of selection cursor.
	self.selectLength=0; -- length of selection
	self.offset=0; -- how many pixels is the text shifted to the right.
	self.cushion=6; -- How much room between left edge of textfield to the right edge of the first character
	self.cursorLastShown=0; -- Cursor disappears every 0.5 seconds for 0.5 seconds. This variable records this time.
	self.showCursor=true; -- Whether cursor is seen at this moment in time.
	self.lastMouseDownEvent=nil; -- Last time mouse pressed into text field
	
	return self;
end


			
function LoveUI.TextfieldCell:performClick(sender)
	
end

function LoveUI.TextfieldCell:textHasChanged()
	--Whenever text has changed in the textfield, this function is called.
	--This function then activates the corresponding controlEvent.
	self:activateControlEvent(self.controlView, LoveUI.EventTextHasChanged, theEvent);
end
function LoveUI.TextfieldCell:deleteBackward(sender)
	if self.selectLength~=0 then
		self:insertText("", self);
		return
	end
	if self.selectStart>0 then
		self.value=string.sub(self.value, 1, self.selectStart-1)..string.sub(self.value, self.selectStart+1)
		self.selectStart=self.selectStart-1
		self:textHasChanged();
	end
end

function LoveUI.TextfieldCell:deleteForward(sender)
	if self.selectLength~=0 then
		self:insertText("", self);
		return
	end
	self.value=string.sub(self.value, 1, self.selectStart)..string.sub(self.value, self.selectStart+2)
	self:textHasChanged();
end

function LoveUI.TextfieldCell:normalize()
	self.value=tostring(self.value)
	if self.selectStart<0 then
		self.selectStart=0
	end
	if self.selectStart>#tostring(self.value) then
		self.selectStart=#tostring(self.value)
	end
	local widthToSelectEnd = self.controlView.font:getWidth(string.sub(tostring(self.value),1,self.selectStart+self.selectLength));
	local widthToSelectStart = self.controlView.font:getWidth(string.sub(tostring(self.value),1,self.selectStart));
	local lastCharX= self.cushion-self.offset+self.controlView.font:getWidth(tostring(self.value))
	local cursorx=widthToSelectEnd - self.offset+self.cushion
	
	if cursorx > self.controlView.frame.size.width-self.cushion-1  then --if cursor/edge of select rectangle too far right--try keep text screen full
		self.offset=widthToSelectEnd -self.controlView.frame.size.width+self.cushion*1.5
	elseif cursorx < self.cushion then -- if cursor/edge of select rectangle too far left
		self.offset=widthToSelectEnd
	elseif self.controlView.font:getWidth(tostring(self.value))<self.controlView.frame.size.width-self.cushion then
		self.offset=0 
	elseif lastCharX<self.controlView.frame.size.width-self.cushion and self.offset>self.cushion then
		self.offset=self.controlView.font:getWidth(tostring(self.value))-self.controlView.frame.size.width 
	end
end


function LoveUI.TextfieldCell:insertText(text, sender)
	-- Insert the supplied string at the insertion point or selection, deleting the selection if there is one.
	if self.selectLength<0 then
		self.selectStart=self.selectStart+self.selectLength
		self.selectLength=-self.selectLength
	end
	
	self.value=string.sub(self.value, 1, self.selectStart)..text..string.sub(self.value, self.selectStart+self.selectLength+1)
	self.selectStart=self.selectStart+#text

	self.selectLength=0;
	self:textHasChanged();
end

function LoveUI.TextfieldCell:drawImage(frame, view)
	LoveUI.graphics.setColor(unpack(self.controlView.backgroundColor))
	local size=frame.size;
	
	if view.opaque then
		LoveUI.graphics.rectangle(2, 0,0, size.width, size.height)
	end
	
	local curImage=self.image;
	if curImage then
		LoveUI.graphics.draw(curImage, frame.size.width/2, frame.size.height/2,0, frame.size.width/self.image:getWidth(), frame.size.height/self.image:getHeight());
	end
end


function LoveUI.TextfieldCell:resignFirstResponder()
	
	if not LoveUI.mouseInRect(LoveUI.Point:new(love.mouse.getX(), love.mouse.getY()), self.controlView.superview:convertRectToView(self.controlView.frame)) or true then
		self.controlView.shouldResignFirstResponder=true;
	end
	
	if (self.controlView.shouldResignFirstResponder) then
		self.controlView.isFirstResponder=false;
		self.state=LoveUI.OFF;
		self.offset=0
		self.selectStart=0
		self.selectLength=0
	end
	return self.controlView.shouldResignFirstResponder
end


function LoveUI.TextfieldCell:mouseDown(theEvent)
	if theEvent.button==love.mouse_right then
		self.selectStart=0
		self.selectLength=#self.value
		return;
	end
	if theEvent.button~=love.mouse_left then
		if self.controlView.nextResponder then
			self.controlView.nextResponder:mouseDown(theEvent)
		end
		return;
	end
	self.controlView.shouldResignFirstResponder=false;
	local mousePos=self.controlView:convertPointFromBase(theEvent.mouseLocation);
	
		
	if not LoveUI.mouseInRect(theEvent.mouseLocation, self.controlView.superview:convertRectToView(self.controlView.frame)) then
		self.controlView.shouldResignFirstResponder=true;
		--repeat mouse click, because the textfield blocked the first mouseclick when resigning first responder was refused.
		self.controlView.context:reclick();
		--error('A')
	else
		--error('A')
		self.selectStart=self:getTextLocation(self.controlView:convertPointFromBase(theEvent.mouseLocation)) --put cursor to position of mouse click
		self.selectLength=0
		self.lastMouseDownEvent=theEvent
	end
end

function LoveUI.TextfieldCell:getTextLocation(aPoint) --get the nth char, at location of x, relative to left edge
	local xValue=aPoint.x+self.offset
	if xValue <= 0 then
		return 0;
	end
	if xValue >=self.controlView.font:getWidth(self.value) then
		return #tostring(self.value);
	end
	for i = 1, #tostring(self.value), 1 do 
		if (self.controlView.font:getWidth(string.sub(self.value,0,i))>xValue) then
		return i-1
		end 
	end
	return 0
end

function LoveUI.TextfieldCell:mouseUp(theEvent)
	if theEvent.button~=love.mouse_left then
		if self.controlView.nextResponder then
			self.controlView.nextResponder:mouseDown(theEvent)
		end
		return;
	end
	
	if theEvent.clickCount>2 then
		self.controlView:selectAll()
	end
	
	self:activateControlEvent(self.controlView, LoveUI.EventMouseClicked ,theEvent);
end

function LoveUI.TextfieldCell:keyDown(theEvent)
	--check code range
	local key=theEvent.keyCode;
	
	if key > 31 and key<127 then
		local char = string.char( key )
		if love.keyboard.isDown( love.key_lshift ) or love.keyboard.isDown( love.key_rshift ) then
			local chars={} --when keys shifted
			chars["1"]="!";chars["a"]="A";chars["k"]="K";chars["u"]="U";chars["]"]="}"
			chars["2"]="@";chars["b"]="B";chars["l"]="L";chars["v"]="V";chars["\\"]="|"
			chars["3"]="#";chars["c"]="C";chars["m"]="M";chars["w"]="W";chars[";"]=":"
			chars["4"]="$";chars["d"]="D";chars["n"]="N";chars["x"]="X";chars["\'"]="\""
			chars["5"]="%";chars["e"]="E";chars["o"]="O";chars["y"]="Y";chars[","]="<"
			chars["6"]="^";chars["f"]="F";chars["p"]="P";chars["z"]="Z";chars["."]=">"
			chars["7"]="&";chars["g"]="G";chars["q"]="Q";chars["`"]="~";chars["/"]="?"
			chars["8"]="*";chars["h"]="H";chars["r"]="R";chars["-"]="_";
			chars["9"]="(";chars["i"]="I";chars["s"]="S";chars["="]="+";
			chars["0"]=")";chars["j"]="J";chars["t"]="T";chars["["]="{";chars[" "]=" ";
			--char = string.upper( char )
			char=chars[char];
		end
		self:insertText(char, self)
		self:normalize()
	elseif key == love.key_tab then
		self:insertText("	", self)
	elseif key == love.key_backspace then
		self:deleteBackward(self);
		self:normalize()
	elseif key == love.key_delete then
		self:deleteForward(self);
	elseif key == love.key_left then
		if love.keyboard.isDown(love.key_lshift) or  love.keyboard.isDown(love.key_rshift) then
			if self.selectStart+self.selectLength>0 then
				self.selectLength=self.selectLength-1
			end
		else -- if no select rectangle
			if self.selectLength==0 and self.selectStart>0 then
				self.selectStart=self.selectStart-1
			else
				self.selectLength=0
			end
		end
	elseif key == love.key_right then
		if love.keyboard.isDown(love.key_lshift) or  love.keyboard.isDown(love.key_rshift) then
			if self.selectStart+self.selectLength<#tostring(self.value) then
				self.selectLength=self.selectLength+1
			end
		else -- if no select rectangle
			if self.selectLength==0 and self.selectStart<#tostring(self.value) then
				self.selectStart=self.selectStart+1
			else
				self.selectStart=self.selectStart+1+self.selectLength
				self.selectLength=0
			end
		end
	end
	self:normalize()
end
function LoveUI.TextfieldCell:display(frame, view)
	self:drawImage(frame, view);
	self:drawText(frame, view);
	self:drawSelection(frame, view)
	self:drawBorder(frame, view)
end
function LoveUI.TextfieldCell:update(dt)
	self.showCursor=true;
	if love.timer.getTime()-self.cursorLastShown > 1 then
		self.showCursor=true
		self.cursorLastShown=love.timer.getTime();
	elseif love.timer.getTime()-self.cursorLastShown>0.5 then
		self.showCursor=false;
	end
	
	if (love.mouse.isDown(love.mouse_left) and self.lastMouseDownEvent~=nil) and self.controlView.isFirstResponder then --dragging the rectangle
		local mousePoint=self.controlView:convertPointFromBase(LoveUI.Point:new(love.mouse.getPosition()))
		if self.controlView:convertPointFromBase(self.lastMouseDownEvent.mouseLocation).x ~= mousePoint.x then
			self.selectLength=self:getTextLocation(mousePoint)-self.selectStart;
		end
		self:normalize()
	end
end

function LoveUI.TextfieldCell:drawBorder(frame, view)
	LoveUI.graphics.setColor(180,180,180,255)
	LoveUI.graphics.setLineStyle( love.line_rough )
	LoveUI.graphics.rectangle(love.draw_line, 0,0, frame.size.width-1, frame.size.height-1) --textfield border
	LoveUI.graphics.setColor(0,0,0,255)
	LoveUI.graphics.setLineStyle( love.line_smooth )
	LoveUI.graphics.line(0, 1, frame.size.width, 1) --text field shadow at top
end

function LoveUI.TextfieldCell:drawText(frame, view)
	self.value=tostring(self.value);
	LoveUI.graphics.setFont(view.font);
	LoveUI.graphics.setColor(unpack(self.controlView.textColor));
	LoveUI.graphics.draw((self.value or ''), self.cushion-self.offset, frame.size.height/2+5)
end

function LoveUI.TextfieldCell:drawSelection(frame, view)
	self.value=tostring(self.value);
	
		LoveUI.graphics.setLineStyle( love.line_rough )
		local xloc=view.font:getWidth(string.sub(self.value, 1, self.selectStart))+self.cushion-self.offset
		if self.selectLength==0 then
			if self.showCursor and view.isFirstResponder then
				LoveUI.graphics.setColor(unpack(self.controlView.textColor))
				LoveUI.graphics.line(xloc, 3,xloc ,frame.size.height-3)
			end
			
		else
			LoveUI.graphics.setColor(unpack(self.controlView.selectColor)) --select rect color
			if self.selectLength>0 then
				LoveUI.graphics.rectangle(love.draw_fill, xloc, 3, view.font:getWidth(string.sub(self.value,self.selectStart+1,self.selectStart+self.selectLength)) ,frame.size.height-6)
			else
				local selWid=view.font:getWidth(string.sub(self.value,self.selectStart+self.selectLength+1, self.selectStart))
				LoveUI.graphics.rectangle(love.draw_fill, xloc-selWid, 3, selWid ,frame.size.height-5)
			end
		end
	
end
