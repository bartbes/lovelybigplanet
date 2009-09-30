OBJECT.Name = "Finish"
OBJECT.Creator = "Bart Bes"
OBJECT.Version = 0.1
OBJECT.Resources = { texture = "qubodup/darts_target" }
OBJECT.TextureScale = { x = 1 }

OBJECT.Static = true
OBJECT.Circle = { { 1/3 } }

function OBJECT.autofinish(player)
	local px, py = LBP.getX(player), LBP.getY(py)
	local fx, fy = LBP.getX(OBJECT), LBP.getY(OBJECT)
	if math.abs(px-fx) < 0.5 and math.abs(py-fy) < 0.5 then
		LBP.finish()
	end
end
