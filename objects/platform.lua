OBJECT.Name = "Platform"
OBJECT.Creator = "Bart Bes"
OBJECT.Version = 0.1
OBJECT.Resources = { texture = "snakeface/platform" }
OBJECT.TextureScale = { x = 1, y = 1 }

OBJECT.Static = true
OBJECT.Polygon = { { -5, -0.5, -5, 0.5, 5, 0.5, 5, -0.5 } }

function OBJECT:collision(a)
end
