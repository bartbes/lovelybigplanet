LoveUI.require("LoveUIObject.lua");
LoveUI.Responder=LoveUI.Object:new();
--[[
The default responder chain for a key event message begins with the first responder in a context; the default responder chain for a mouse event begins with the view on which the user event occurred. 
]]--

function LoveUI.Responder:acceptsFirstResponder()
	-- Overridden by subclasses to return true if the receiver accepts first responder status.
	return false;
	-- By default a responder object refuses to become a first responder.
end

function LoveUI.Responder:becomeFirstResponder()
	-- Notifies the receiver that it's about to become first responder in its LoveUI.Context
	return true;
	-- Returning false refuses to be first responder. Never invoke this directly.
end

function LoveUI.Responder:keyDown(theEvent)
	-- The default implementation simply passes this message to the next responder.
	if self.nextResponder then
		self.nextResponder:keyDown(theEvent)
	end
end

function LoveUI.Responder:keyUp(theEvent)
	-- The default implementation simply passes this message to the next responder.
	if self.nextResponder then
		self.nextResponder:keyUp(theEvent)
	end
end

function LoveUI.Responder:mouseDown(theEvent)
	-- The default implementation simply passes this message to the next responder.
	if self.nextResponder then
		self.nextResponder:mouseDown(theEvent)
	end
end

function LoveUI.Responder:mouseUp(theEvent)
	-- The default implementation simply passes this message to the next responder.
	if self.nextResponder then
		self.nextResponder:mouseUp(theEvent)
	end
end

function LoveUI.Responder:resignFirstResponder()
	-- Notifies the receiver that it's been asked to relinquish its status as first responder in its window.
	return true;
end

function LoveUI.Responder:setNextResponder(aResponder)
	local t=self.nextResponder;
	self.nextResponder=aResponder;
	if aResponder and aResponder.setNextResponder then
		aResponder:setNextResponder(t);
	end
		--inserting aResponder into responder chain.
	-- Sets the receiver's next responder.
end
