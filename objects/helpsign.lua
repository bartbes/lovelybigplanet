OBJECT.Name = "Help Sign"
OBJECT.Creator = "Bart Bes"
OBJECT.Version = 0.1
OBJECT.Resources = { texture = "qubodup/sign_yellow-80x100" } --took the yellow one, not definitive
OBJECT.TextureScale = { x = 1 }

OBJECT.Static = true
OBJECT.Polygon = { { -1/15, -1/3, -1/15, 1/3, 1/15, -1/3, 1/15, 1/3 }, { -1/3.75, 1/3.75, 1/7.5, 1/3.75, 1/3.75, 1/3.75, 1/7.5, 0,-1/3.75, 0 } }

hashelped = false
OBJECT.helptext = "<Help message empty>"

function OBJECT:checkposition(body)
	if hashelped then return end
	if ((body:getX() - self._body:getX()) ^ 2 + (body:getY() - self._body:getY()) ^ 2)^.5 < .75 then
		LBP.messageBox(OBJECT.helptext)
		hashelped = true
	end
end
