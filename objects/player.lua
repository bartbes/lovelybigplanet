OBJECT.Name = "Player"
OBJECT.Creator = "Bart Bes"
OBJECT.Version = 0.1
OBJECT.Resources = { texture = "player" }
OBJECT.TextureScale = { x = 1 }

OBJECT.Weight = 80 --Let's do kg
OBJECT.Polygon = { {-.5, -.5, -.5, .5, .5, .5, .5, -.5} } --a 10x10 square from the center

function OBJECT:collision(a)
	--we don't do anything on collision, note this probably will be called from the map, instead of from the engine itself
end
