MAP.Name = "Test map"
MAP.Creator = "Bart Bes"
MAP.Version = 0.1
MAP.Resources = { background = "bartbes/samplebackground" } --I need only this resource for this map itself, resources of the object will be loaded by the object.
MAP.BackgroundScale = { x = 10 }
MAP.Objects = { player = { "player", 2, 5, 0, {Foreground} }, platform = { "platform", 2, 1, -2, {Foreground} }, gadget1 = { "gadget", 2.2, 11, 0, {Foreground} },
enemy = { "enemy", 2, 8, 0, {Background} },
fgadget = { "floatinggadget", 2.6, 5, 0, {Foreground} },
gadget2 = { "gadgetb", 2.2, 10, 0, {Foreground} },
bridge = { "bridge", 4, 5, 0, {Foreground, Background} },
gadget3 = { "gadget", 2.4, 9, 0, {Foreground} },
gadget4 = { "gadget", 2.6, 8, 0, {Foreground} },
gadget5 = { "gadgetb", 14, 4, 0, {Foreground} },
gadget6 = { "gadget", 14.2, 5, 0, {Foreground} },
gadget7 = { "gadget", 14.3, 6, 0, {Foreground} },
gadget8 = { "gadgetb", 13.4, 5, 0, {Foreground} },
gadget9 = { "gadget", 13, 7, 0, {Foreground} },
gadget10 = { "gadget", 13, 7, 0, {Foreground} },
gadget11 = { "gadget", 14.5, 5.5, 0, {Foreground} },
gadget12 = { "gadget", 14.5, 5.5, 0, {Foreground} },
gadget13 = { "gadget", 12.5, 4.5, 0, {Foreground} },
gadget14 = { "gadget", 13.5, 4.5, 0, {Foreground} },
platform2 = { "platform", 14, 1, 5, {Foreground} },
platform3 = { "platform", 24, 1, 85, {Foreground} },
platform4 = { "platform", 14, 6, 0, {Foreground} },
platform5 = { "platform", 2, 6, 0, {Background} },
lava = { "lava", 2, 8, 0, {Foreground, Background} },
helpsign = { "helpsign_left", 4, 6.80, 0, {Background} },
finish = { "finish", 2, 7, 0, {} }
} --Load the objects, and their resources
MAP.Finish = { x = 2, y = 7, position = Background } --set finish coordinates, these are rounded
MAP.Mission = "Welcome to LovelyBigPlanet!\n\nGo to the center of the top-left platform"
MAP.ShowScore = true

function conversation1(pos)
	conversation1_run = true
	pos = pos and pos+1 or 1
	if pos == 1 then
		LBP.speechBox("rude", "OBEY!", conversation1, pos)
	elseif pos == 2 then
		LBP.speechBox("robin-gvx", "No!", conversation1, pos)
	elseif pos == 3 then
		LBP.speechBox("bartbes", "Resistance is futile", conversation1, pos)
	end
end

function MAP.init()
	MAP.Objects.helpsign.helptext = "You gain extra points\nfor pushing off the enemy"
end

function MAP.update(dt)
	if not conversation1_run then conversation1() end
	MAP.Objects.helpsign:checkposition(MAP.Objects.player._body)
	if MAP.Objects.enemy._body:getY() < 2 and not MAP.shownmessage then
		MAP.shownmessage = true
		LBP.addScore(5000)
		LBP.messageBox("You threw the enemy off the platform!")
	end
	local S = true
	for i=1,14 do
		if MAP.Objects['gadget'..i]._body:getY() > 0 then
			S = false
			break
		end
	end
	if S and MAP.Objects.bridge._body:getY() < 0 and not MAP.shownmessage2 then
		MAP.shownmessage2 = true
		LBP.addScore(10000)
		LBP.messageBox("You threw all gadgets and the brige off the platforms!")
	end
end

function MAP.finished()
	LBP.messageBox("Great, you did it!")
	return true
end
