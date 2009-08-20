--[[
TableView Datasource Methods:
'self' refers to tableView

function attributesForColumn(tableview, columnIndex, columnHidden)
	return	columnHeaderString, columnWidthInteger
end

function viewForCell(tableview, rowIndex, columnIndex)
	--tableview queries a value at row, column
	return (string or number)
end

function numberOfRows (tableview)
	--tableview queries the number of rows in table.
	return (number)
end

function numberOfColumns (tableview)
	--tableview queries the number of columns in table.
	return (number)
end

function sortColumn(tableview, columnindex, ascending)

end 

TableView
sorting
headers=true, false
]]--

LoveUI.require("LoveUIScrollView.lua");

LoveUI.require("LoveUITableViewCell.lua");
LoveUI.require("LoveUITableViewHeaderCell.lua");
LoveUI.TableView=LoveUI.Control:new();

function LoveUI.TableView:init(frame, datasource, ...)
	LoveUI.Control.init(self, frame, ...)
	self.dataSource=datasource;
	self.enabled=true
	self.opaque=true;
	self.tabAccessible=true;
	self.hasHeaders=true;
	self.scrollView=LoveUI.ScrollView:new(LoveUI.Rect:new(0,0,frame.size:get()), LoveUI.Rect:new(0,0,frame.size:get()));
	self.headerHeight=20
	self.headerView=LoveUI.ClipView:new(LoveUI.Rect:new(0,0,frame.size.width, self.headerHeight));
	local headerView=self.headerView;
	headerView.backgroundColor=LoveUI.defaultMetalColor;
		function headerView.display(hself)	
			if self.opaque then
				local size=self.frame.size;
				LoveUI.graphics.setColor(hself.backgroundColor)
				LoveUI.graphics.rectangle(2, 0, 0, size.width, size.height)
			end
			local frame=hself.frame;
			local curImage=LoveUI:getImage("light-gloss-top-bottom.png");
			LoveUI.graphics.draw(curImage, frame.size.width/2, frame.size.height/2,0, frame.size.width/curImage:getWidth(), frame.size.height/curImage:getHeight());
			
		end
		
	self.headers={};
	self:addSubview(self.scrollView)
	self.rowViews={};
	self.selectedIndex=0;
	self.selectedValues=nil;
	self.selecting=true;
	self.sorting=true;
	--bind headerView's offset to scrollView's one so header scrolls same as rows.
	local scrollViewClipViewOffset={};
	scrollViewClipViewOffset[1]=LoveUI.Point:new(0,0);
	LoveUI.bind(self.scrollView.clipView, "offset",self.headerView, "offset",
			function (headerViewoffset) 
				--self.headerView:setOffset(LoveUI.Point:new(headerViewoffset, 0))
				return scrollViewClipViewOffset[1]
			end
			
		,	function(headerViewoffset, value)
				self.headerView:setOffset(LoveUI.Point:new(value.x, 0))
				scrollViewClipViewOffset[1]=value;
				return nil;
			end);
	
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
			
		
	self.rowSpacing=1;
	self.columnSpacing=1;
	self.rowHeight=20;
	self.selectedIndex=nil;
	self.controlEvents={}
	
	if self.dataSource then
		self:reloadData()
	end
	return self;
end

function LoveUI.TableView:setFrame(aFrame)
	self.frame=aFrame;
	self.scrollView:setFrame(LoveUI.Rect:new(0,0,aFrame.size:get()));
	self:calculateScissor();
end

function LoveUI.TableView:setSize(aSize)
	self.frame.size=aSize:copy();
	self.scrollView:setFrame(LoveUI.Rect:new(0,0,aSize:get()));
	self:calculateScissor();
end

function LoveUI.TableView:reloadData()

	local numberOfRows=self.dataSource.numberOfRows(self);
	local numberOfCols=self.dataSource.numberOfColumns(self);
	while #self.scrollView.contentView.subviews > 0 do
		self.scrollView.contentView:removeSubview(self.scrollView.contentView.subviews[1]);
	end
	while #self.subviews > 0 do
		self:removeSubview(self.subviews[1]);
	end
	
	while #self.headerView.subviews > 0 do
		self.headerView:removeSubview(self.headerView.subviews[1]);
	end
	
	self:addSubview(self.scrollView);
	
	self.scrollView:setFrame(LoveUI.Rect:new(0,0,self.frame.size:get()));
	
	local totalColumnWidths=0;
	
	if self.hasHeaders then
		self:addSubview(self.headerView);
		self.scrollView:setFrame(LoveUI.Rect:new(0,self.headerHeight,self.frame.size.width, self.frame.size.height-self.headerHeight));
		--self.scrollView:setOrigin(LoveUI.Point:new(0, self.headerHeight));
		--self.scrollView:setSize(LoveUI.Size:new(self.frame.size.width, self.frame.size.height-self.headerHeight));
	end
	
	
	for i=1, numberOfCols, 1 do
		local columnHeader, columnWidth, columnShow=self.dataSource.attributesForColumn(self, i)
		totalColumnWidths=totalColumnWidths+columnWidth+self.columnSpacing;
	end
	
	local culmulativeColuWidth=0
	for i=1, numberOfCols, 1 do
		local columnHeader, columnWidth, columnHidden=self.dataSource.attributesForColumn(self, i)
		
		local colX=culmulativeColuWidth;
		if not columnHidden then 
			culmulativeColuWidth=culmulativeColuWidth+(columnWidth+self.columnSpacing);
		end
		local header=self.headers[i];
		if header==nil then
			header=LoveUI.TableViewHeaderCell:new(LoveUI.Rect:new(colX, 0, columnWidth, self.headerHeight), self);
			self.headers[i]=header;
			
			LoveUI.bind(self.headers[i], "opaque", self, "opaque",
					function (isopaque) 
						return isopaque
					end,	nil);
		end
		self.headerView:addSubview(header)
		header.hidden=columnHidden;
		header:setFrame(LoveUI.Rect:new(colX, 0, columnWidth, self.headerHeight));
		
		if i==numberOfCols then
			header.frame.size.width=columnWidth+self.scrollView.scrollbarWidth-numberOfCols*self.columnSpacing;
		end
		
		header.value=columnHeader;
	
		
		--self.headerView:addSubview(LoveUI.Textfield:new(LoveUI.Rect:new(0,0,40,40)));
		
		for j=1, numberOfRows, 1 do
			local rowFrame=LoveUI.Rect:new(0, (j-1)*(self.rowHeight+self.rowSpacing), math.max(totalColumnWidths, self.frame.size.width), self.rowHeight);
			if (self.rowViews[j]) then
				self.rowViews[j]:setFrame(rowFrame)
			end
			
			if (not self.rowViews[j]) then
				self.rowViews[j]=LoveUI.View:new(rowFrame)
				local curRow=self.rowViews[j];
				function curRow.mouseDown(rViewSelf, theEvent)
					if theEvent.button==love.mouse_left and self.enabled then
						self:rowClicked(rViewSelf, j)
					else
						if rViewSelf.nextResponder then
							rViewSelf.nextResponder:mouseDown(theEvent)
						end
					end
				end
				function curRow.display(rViewSelf)
					if rViewSelf.opaque then
						local size=rViewSelf.frame.size;
						local currentColor=rViewSelf.backgroundColor;
						if self.selectedIndex==j then
							currentColor=self.selectColor;
						end
						LoveUI.graphics.setColor(currentColor)
						LoveUI.graphics.rectangle(2, 0, 0, size.width, size.height)
					end
				end
				LoveUI.bind(self.rowViews[j], "opaque", self, "opaque",
					function (isopaque) 
						return isopaque
					end,	nil);
			end
			
			
			if j%2==1 then
				self.rowViews[j].backgroundColor=love.graphics.newColor(128, 128, 255, 32)
			end
			if not columnHidden then
				local cell=self.dataSource.viewForCell(self, j, i);
				
				cell.frame=LoveUI.Rect:new(colX, self.rowSpacing, columnWidth, self.rowHeight)
				if cell.superview==nil then
					self.rowViews[j]:addSubview(cell)
				end
			end
		end
		
	end
	for index, rowView in pairs(self.rowViews) do
		self.scrollView.contentView:addSubview(rowView);
	end
	
	self.scrollView:setContentSize(LoveUI.Size:new(math.max(totalColumnWidths, self.frame.size.width), (self.rowHeight+self.rowSpacing)*(numberOfRows)+5))
end


function LoveUI.TableView:headerClicked(header, headerValue, headerState)
	local colIndex=0;
		for k, view in pairs(self.headerView.subviews) do
			if ( view~=header) then
				if headerState then
					view.state=LoveUI.OFF;
				end
			else
				colIndex=k;
			end
		end
		
	self.dataSource.sortColumn(self, colIndex, headerState==LoveUI.ASCENDING)
	self.selectedIndex=0;
	for k, row in pairs(self.rowViews) do
		if ((row.subviews[1] or {}).value==self.selectedValues) then
			self.selectedIndex=k
			break;
		end
	end
end


function LoveUI.TableView:rowClicked(rowView, rowIndex)
	if (self.selecting) then
	self.selectedIndex=rowIndex;
	self.selectedValues=(rowView.subviews[1] or {}).value; -- bad assumption; first column is primary key
	end
end

function LoveUI.TableView:setSelectedIndex(index)
	self.selectedIndex=index;
	self.selectedValues=(self.rowViews[index].subviews[1] or {}).value; -- bad assumption; first column is primary key
	
	
	self:activateControlEvent(self, LoveUI.EventDefault ,theEvent, self.selectedIndex);
	self:activateControlEvent(self, LoveUI.EventValueChanged ,theEvent, self.selectedIndex);
	
end



function LoveUI.TableView:setAction(anAction, forControlEvent, aTarget)
	if type(anAction)~="function" then
		LoveUI.error("anAction must be a function that is called when event forControlEvent occurs.", 2)
	end
	if forControlEvent==nil then forControlEvent=LoveUI.EventDefault end
	if aTarget then
		self.controlEvents[forControlEvent]=function (...) anAction(aTarget, ...) end ;
	else
		self.controlEvents[forControlEvent]=anAction
	end
end

function LoveUI.TableView:activateControlEvent(sender, forControlEvent, ...)
	
	if self.controlEvents[forControlEvent]~=nil then
		self.controlEvents[forControlEvent](sender, ...);
	end
end


function LoveUI.TableView:getSelectedIndex()
	--returns 0 if no selection
	return self.selectedIndex;
end



