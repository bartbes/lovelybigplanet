MAP.Name = "Test map"
MAP.Creator = "Bart Bes"
MAP.Version = 0.1
MAP.Resources = { background = "samplebackground" } --I need only this resource for this map itself, resources of the object will be loaded by the object.
MAP.Objects = { player = { "player", 200, 300 } } --Load the objects, and their resources

function MAP:drawBackgroundObjects()
end

function MAP:drawForegroundObjects()
	LBP.draw(self.Objects.player)
end
