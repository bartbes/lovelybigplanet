MAP.Name = "Test map"
MAP.Creator = "Bart Bes"
MAP.Version = 0.1
MAP.Resources = { background = "samplebackground" } --I need only this resource for this map itself, resources of the object will be loaded by the object.
MAP.Objects = { player = { "player", 2, 15, Foreground }, platform = { "platform", 2, 1, Foreground } } --Load the objects, and their resources

--[[
function MAP:drawBackgroundObjects()
	LBP.draw(self.Objects.platform)
	LBP.draw(self.Objects.platform2)
	LBP.draw(self.Objects.platform3)
end

function MAP:drawForegroundObjects()
	LBP.draw(self.Objects.player)
end
]]
