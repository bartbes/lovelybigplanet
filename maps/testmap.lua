MAP.Name = "Test map"
MAP.Creator = "Bart Bes"
MAP.Version = 0.1
MAP.Resources = { background = "samplebackground" } --I need only this resource for this map itself, resources of the object will be loaded by the object.
MAP.Objects = { player = { "player", 2, 5, 0, Foreground }, platform = { "platform", 2, 1, -2, Foreground }, gadget = { "gadget", 2.2, 11, 0, Foreground },
gadget2 = { "gadget", 2.2, 10, 0, Foreground },
bridge = { "bridge", 4, 5, 0, Foreground },
gadget3 = { "gadget", 2.4, 9, 0, Foreground },
gadget4 = { "gadget", 2.6, 8, 0, Foreground },
gadget5 = { "gadget", 14, 4, 0, Foreground },
gadget6 = { "gadget", 14.2, 5, 0, Foreground },
gadget7 = { "gadget", 14.3, 6, 0, Foreground },
gadget8 = { "gadget", 13.4, 5, 0, Foreground },
gadget9 = { "gadget", 13, 7, 0, Foreground },
gadget10 = { "gadget", 13, 7, 0, Foreground },
gadget11 = { "gadget", 14.5, 5.5, 0, Foreground },
gadget12 = { "gadget", 14.5, 5.5, 0, Foreground },
gadget13 = { "gadget", 12.5, 4.5, 0, Foreground },
gadget14 = { "gadget", 13.5, 4.5, 0, Foreground },
platform2 = { "platform", 14, 1, 5, Foreground },
platform3 = { "platform", 24, 1, 85, Foreground },
platform4 = { "platform", 14, 6, 0, Foreground },
platform5 = { "platform", 2, 6, 0, Background }
} --Load the objects, and their resources

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
