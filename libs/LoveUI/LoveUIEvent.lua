
LoveUI.Event=LoveUI.Object:new()
local buttonNumber=0;

function LoveUI.Event:init(context, mouseLocation, keysDown,  timestamp, eventType)
	self.context=context;
	--do conversions?
	self.mouseLocation=mouseLocation;
	self.modifierFlags=modifierFlags;
	self.timestamp=timestamp
	self.eventType=eventType;
	self.keysDown=keysDown;
	return self;
end

LoveUI.Event.mouseEvent=function(self, mouseLocation, button, keysDown, timestamp, context, eventNumber, clickCount)
	-- allocs and inits an object with no parameters
	local mouseEvent = LoveUI.Event:new(context, mouseLocation, keysDown, timestamp, LoveUI.MOUSE);
	mouseEvent.eventNumber=eventNumber;
	mouseEvent.clickCount=clickCount;
	mouseEvent.button=button;
	return mouseEvent;	
end

LoveUI.Event.keyEvent=function(self, mouseLocation, keyCode, keysDown, timestamp, context, keyRepeatCount)
	-- allocs and inits an object with no parameters
	local keyEvent = LoveUI.Event:new(context, mouseLocation, keysDown, timestamp, LoveUI.KEY);
	keyEvent.keyRepeatCount=keyRepeatCount;
	keyEvent.keyCode=keyCode; --keyCode
	return keyEvent;	
end
