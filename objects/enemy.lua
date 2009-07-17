OBJECT.Name = "Enemy"
OBJECT.Creator = "Robin Wellner"
OBJECT.Version = 0.0
OBJECT.Resources = { texture = "enemy" }
OBJECT.TextureScale = { x = 1 }

OBJECT.Static = false
OBJECT.Circle = { {0, .27, 1/6}, {0, -1/6, 1/6}, {.5/3, -.41, .25/3}, {-.5/3, -.41, .25/3}, {-.35, -1/8, .2/3}, {.35, -1/8, .2/3}, }
--OBJECT.Polygon = { {-0.39, -0.5, -0.39, 0.39, 0.39, 0.39, 0.39, -0.5} } --a 10x10 square from the center

function OBJECT:collision(a)
	--we don't do anything on collision, note this probably will be called from the map, instead of from the engine itself
end
