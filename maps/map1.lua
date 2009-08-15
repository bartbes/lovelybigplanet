MAP.Name = "Test map 1"
MAP.Creator = "Bart Bes"
MAP.Version = 0.1
MAP.Resources = { background = "samplebackground" }
MAP.BackgroundScale = { x = 10 }
MAP.Objects = {
	player = { "player", -8, 8.5, 0, {Foreground} },
	platform1 = { "platform", 2, 1, 90, {Background} },
	platform2 = { "platform", 4, 1, 90, {Background} },
	platform3 = { "platform", 3, -4.5, 0, {Background} },
	platform4 = { "platform", -5, 7.5, 0, {Foreground} },
	platform5 = { "platform", 7.5, 1, 0, {Foreground} },
	gadget1 = { "gadget", 2, 6, 0, {Foreground, Background} },
	gadget2 = { "gadget", 4, 6, 0, {Background} },
}
MAP.Finish = { x = 3, y = -3, position = Background }

MAP.Mission = "A riddle:\n\nThe one box stops, the other continues\nFind the best, it will guide you\nto the finish."


function MAP.finished()
	if MAP.Objects.gadget2._body:getY() < -3 then
		LBP.messageBox("Wow, you figured out the riddle!")
		return true
	end
	return false
end
