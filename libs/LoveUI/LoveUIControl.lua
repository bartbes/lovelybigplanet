LoveUI.require("LoveUIView.lua")
LoveUI.Control=LoveUI.View:new();

function LoveUI.Control:init(frame, cell)
	-- e.g local o=LoveUI.Object:alloc():init();
	LoveUI.View.init(self, frame);
	self.cellClass=LoveUI.Cell;
	self.cell=cell;
	self.value="";
	self.enabled=true;
	self.ignoresMultiClick=false;
	self.font=LoveUI.DEFAULT_FONT;
	
	self.action=nil;
	self.target=nil;
	
	
	if self.cell then
		local tcellValue=self.cell.value
		LoveUI.bind(self.cell, "value", self, "value",
				function (selfValue) 
					return selfValue
				end
			,	function(selfValue, v)
					self.value=v;
				end);
				
		self.cell.value=tcellValue
	end
	return self;
end

function LoveUI.Control:stringValue()
	-- return value as string
	return tostring(self.value)
end

function LoveUI.Control:performClick(sender)
	
end

function drawCell(dt)
end

function updateCell()
end