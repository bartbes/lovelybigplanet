OBJECT.Name = "Sample Object" --Yes, this is somewhat inspired by GMod
OBJECT.Creator = "Bart Bes"
OBJECT.Version = 0.1
OBJECT.Resources = { texture = "sampletexture.png" }
LoadResources()

OBJECT.Weight = 20 --Don't know, kg? lbs?
OBJECT.Polygon = { { 2, 8, 3, 9, 1, 3 } } --tables in a table because these things will be used in love.physics and love.graphics, this limits to 6 points.

--So how about this? Please add comments
--[[Comments:
]]
