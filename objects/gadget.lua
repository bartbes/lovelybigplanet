OBJECT.Name = "Gadget"
OBJECT.Creator = "Robin Wellner"
OBJECT.Version = 0.0
OBJECT.Resources = { texture = "snakeface/block" }
OBJECT.TextureScale = { x = 1 }

OBJECT.Static = false
OBJECT.Polygon = { {-.4, -.4, -.4, .4, .4, .4, .4, -.4} }

function OBJECT:collision(a)
end
function OBJECT:Init()
	OBJECT._body:setMass(0,0,0,0)
end