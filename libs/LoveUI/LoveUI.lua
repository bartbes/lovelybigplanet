
local version={"unstable", 20090709.1752}  --release, revision (YYYYMMDD.HHMM)

if LoveUI==nil then
	LoveUI={};
	
	function LoveUI.PATH (path)
		local lf = love.filesystem
		path=path or ""; -- is a folder
		for k, subfile in pairs(lf.enumerate(path)) do
			local subpath=path.."/"..subfile;
			if subfile == "LoveUI.lua" and lf.isFile(subpath) then
				lf.include(subpath);
				local release, revision=unpack(version);
				local targetrelease, targetrevision=unpack(LoveUI.version)
				if release==targetrelease and revision==targetrevision then
					LoveUI.PATH=path;
					return;
				end
			end
			if not lf.isFile(subpath) and type(LoveUI.PATH)=="function" then
				LoveUI.PATH(subpath)
			end
		end
	end
	LoveUI.PATH();
	
	function LoveUI.getVersion() 
		return unpack(version);
	end
	
	setmetatable(LoveUI, LoveUI);
	local LoveUI=LoveUI
	LoveUI.images={};
	LoveUI.sounds={};
	
	LoveUI.graphics={};
	
	LoveUI.offset={x=0, y=0}
	local lo=LoveUI.offset;
	
	LoveUI.mouse={};
	LoveUI.bindings={}
	LoveUI.widgetTypes={};
	
	LoveUI.__newindex=function(t, k, v)
		if type(v)=="table" and v.frame then
			LoveUI.widgetTypes[k]=v;
		end
		rawset(t, k, v)
	end
	
	for k, v in pairs(love.graphics) do
		LoveUI.graphics[k]=v;
	end
	for k, v in pairs(love.mouse) do
		LoveUI.mouse[k]=v;
	end
	
	local lg, lm=love.graphics, love.mouse
	--The following code is for emulating pushMatrix/Translate/popMatrix
	LoveUI.graphics.draw=function(subject, x, y, ...) lg.draw(subject, x + lo.x, y+ lo.y, ...) end
	LoveUI.graphics.drawf=function(subject, x, y, ...) lg.drawf(subject, x + lo.x, y+ lo.y, ...) end
	LoveUI.graphics.draws=function(subject, x, y, ...) lg.draws(subject, x + lo.x, y+ lo.y, ...) end
	LoveUI.graphics.point=function(x, y) lg.point( x + lo.x, y+ lo.y) end
	LoveUI.graphics.line=function(x1, y1, x2, y2) lg.line(x1 + lo.x, y1+ lo.y, x2 + lo.x, y2+ lo.y) end
	LoveUI.graphics.rectangle=function(t, x, y, w, h) lg.rectangle(t, x + lo.x, y+ lo.y, w, h) end
	LoveUI.graphics.triangle=function(t, x1, y1, x2, y2, x3, y3) lg.triangle(t,x1+lo.x, y1+lo.y, x2+lo.x, y2+lo.y, x3+lo.x, y3+lo.y) end
	LoveUI.graphics.quad=function(t, x1, y1, x2, y2, x3, y3, x4, y4)lg.quad(t,x1+lo.x, y1+lo.y, x2+lo.x, y2+lo.y, x3+lo.x, y3+lo.y, x4+lo.x, y4+lo.y)end
	LoveUI.graphics.circle=function(t, x, y, ...) lg.circle(t, x + lo.x, y+ lo.y, ...) end
	LoveUI.graphics.setScissor=function(x, y, w, h)
		if x==nil then
			return lg.setScissor()
		end
		lg.setScissor(x + lo.x, y+ lo.y, w, h)
	end
	LoveUI.graphics.getScissor=function()
		local x, y, w, h=lg.getScissor(); 
		if x==nil then return nil end
	 	return x-lo.x, y-lo.y, w, h;
	end
	LoveUI.graphics.polygon=function(t, ...)
		local vars={...}
		for k, v in ipairs(vars) do
			if i%2==0 then
				vars[k]=v+lo.x
			else
				vars[k]=v+lo.y
			end
		end
		lg.polygon(t, unpack(vars));
	end
	LoveUI.mouse.getX=function() return lm.getX() - lo.x end
	LoveUI.mouse.getY=function() return lm.getY() - lo.y end
	LoveUI.mouse.getPosition=function()
		local x, y= lm.getPosition();
		return x - lo.x, y-lo.y
	end
	LoveUI.mouse.setPosition=function(x, y) lm.setPosition(x- lo.x, y- lo.y); end
			
		
	
	
	function LoveUI.error(message, level)
		-- custom error function
		-- if level is 1, then console will show the function that called LoveUI.error
		if level==nil then level= 1 end;
		error(LoveUI.PATH.." library: "..message, 2+level);
	end
	
	function LoveUI:getImage(imageName)
		if self.images[imageName]~= nil then
			return self.images[imageName]
		end
		local imagePath=LoveUI.PATH.."/images/"..imageName
		self.images[imageName] = LoveUI.graphics.newImage(imagePath)
		return self.images[imageName]
	end
	
	function LoveUI.bind(object1, key1, object2, key2, indexFunc, newindexFunc)
	
		newindexFunc=newindexFunc or function(vi, v) end
		indexFunc=indexFunc or function(v) return v end
		
		if not LoveUI.bindings[object1] then
			LoveUI.bindings[object1]={}
			
		end
		LoveUI.bindings[object1][key1]={};
		LoveUI.bindings[object1][key1].toObject=object2;
		LoveUI.bindings[object1][key1].toKey=key2;
		LoveUI.bindings[object1][key1].indexFunc=indexFunc;
		LoveUI.bindings[object1][key1].newindexFunc=newindexFunc;
		object1[key1]=nil;
		object1:setmetamethod("__index", 
			function(t, key)
				local b=LoveUI.bindings[t][key];
				if b and b.indexFunc then
					return b.indexFunc(b.toObject[b.toKey])
				end
				if rawget(t, "__baseclass") then
					return t.__baseclass[key]
				end
				return rawget(t, key);
			end)
			
		object1:setmetamethod("__newindex", 
			function(t, key, value)
				--error(tostring(value))
				local b=LoveUI.bindings[t][key]
				if b and b.newindexFunc then
					--rawset(t, key, value);
					return b.newindexFunc(b.toObject[b.toKey], value)
				end
				return rawset(t, key, value);
			end)
	end
	
	--Constants:
	LoveUI.MOUSE=1;
	LoveUI.KEY=1;
	LoveUI.OFF=false;
	LoveUI.ON=true;
	
	LoveUI.ASCENDING=1;
	LoveUI.DESCENDING=-1;
	
	LoveUI.DEFAULT_FONT=LoveUI.graphics.newFont(love.default_font, 12)
	LoveUI.SMALL_FONT=LoveUI.graphics.newFont(love.default_font, 10)
	
	
	
	LoveUI.defaultBackgroundColor=LoveUI.graphics.newColor(255, 255, 255);
	LoveUI.defaultMetalColor=LoveUI.graphics.newColor(192, 192, 192);
	LoveUI.defaultForegroundColor=LoveUI.graphics.newColor(160, 160, 200);
	LoveUI.defaultSecondaryColor=LoveUI.graphics.newColor(0, 0, 128);
	LoveUI.defaultTextColor=LoveUI.graphics.newColor(0, 0, 0);
	LoveUI.defaultSelectColor=LoveUI.graphics.newColor(50,50,255,92);
	
	--Control Events
	LoveUI.EventDefault=1;
	LoveUI.EventMouseClicked=4;
	LoveUI.EventTextHasChanged=5;
	LoveUI.EventValueChanged=5;
	
	--Basic Functions
	LoveUI.time = function()
		-- return milliseconds since start up
		return love.timer.getTime( )*1000;
	end
	
	LoveUI.mouseInRect = function (aPoint, aRect)
		return 
			aPoint.x >= aRect.origin.x and
			aPoint.y >= aRect.origin.y and
			aPoint.x <= aRect.origin.x + aRect.size.width and
			aPoint.y <= aRect.origin.y + aRect.size.height;	
	end
	
	LoveUI.require=function(fileName)
		love.filesystem.require(LoveUI.PATH.."/"..fileName);
	end
	
	LoveUI.copy=function(aTable)
		local cpy={};
		for k, v in pairs(aTable) do
			cpy[k]=v;
		end
		return cpy;
	end
	
	LoveUI.requireall=function()
		local dir=LoveUI.PATH;
		love.filesystem.require(dir.."/LoveUIContext.lua");
		love.filesystem.require(dir.."/LoveUIClipView.lua");
		love.filesystem.require(dir.."/LoveUILabel.lua");
		love.filesystem.require(dir.."/LoveUITextfield.lua");
		love.filesystem.require(dir.."/LoveUIButton.lua");
		love.filesystem.require(dir.."/LoveUIScrollView.lua");
		love.filesystem.require(dir.."/LoveUIListView.lua");
		love.filesystem.require(dir.."/LoveUITextView.lua");
		love.filesystem.require(dir.."/LoveUITableView.lua");
	end
	
	LoveUI.pushMatrix = function()
		local matrix={}
		matrix.x=lo.x
		matrix.y=lo.y
		LoveUI.graphicsMatrixStack:push(matrix);
	end
	
	LoveUI.popMatrix = function()
		local matrix=LoveUI.graphicsMatrixStack:pop();
		lo.x=matrix.x
		lo.y=matrix.y
	end
	
	
	LoveUI.translate = function(translate_x, translate_y)
		lo.x=lo.x+translate_x
		lo.y=lo.y+translate_y
	end
	
	if class==nil then
		love.filesystem.require(LoveUI.PATH.."/class.lua");
	end
	
	LoveUI.require("LoveUIStack.lua");
	LoveUI.require("LoveUIRect.lua");
	LoveUI.graphicsMatrixStack=LoveUI.Stack:new();
	LoveUI.rectZero=LoveUI.Rect:new(0,0,0,0)
else
	LoveUI={}
	LoveUI.version=version
end

