OBJECT.Name = "Lava"
OBJECT.Creator = "Bart van Strien"
OBJECT.Version = 1.0
OBJECT.Resources = { texture = "bartbes/lava" }
OBJECT.TextureScale = { x = 1 }
OBJECT.Polygon = { { -1.5, -1.5, -1.5, -0.5, -0.5, -0.5, -0.5, -1.5 } }
OBJECT.Static = true

function OBJECT:collision(a)
	if a == 'player' then
		--kill the player
		LBP.killplayer()
	end
end
