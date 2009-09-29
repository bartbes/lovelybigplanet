MAP.Name = "Tutorial"
MAP.Creator = "Bart Bes"
MAP.Version = "0.01"
MAP.Resources = {
	background = "bartbes/samplebackground", 
}
MAP.BackgroundScale = { x = 10.000000, y = 10.000000 }
MAP.Objects = {
	helpsign_right2 = { "helpsign_right", -2.421942, -2.362828, 0.000000, { 1, } }, 
	platform6 = { "platform", 11.412185, -3.192461, 0.000000, { 1, } }, 
	platform5 = { "platform", 1.439962, -3.192461, 0.000000, { 1, 2, } }, 
	platform1 = { "platform", -13.577778, -3.394166, 0.000000, { 1, } }, 
	helpsign_right3 = { "helpsign_right", 7.960273, -2.364106, 0.000000, { 1, } }, 
	platform3 = { "platform", -11.077778, 1.108612, 0.000000, { 1, } }, 
	player = { "player", -12.670336, -2.397780, -0.020211, { 2, } }, 
	helpsign_right1 = { "helpsign_right", -9.596493, 1.945870, 0.000000, { 1, } }, 
	platform8 = { "platform", -0.298865, 2.313651, -89.702869, { 2, } }, 
	platform4 = { "platform", -4.072222, 1.291945, 89.907180, { 1, } }, 
	platform9 = { "platform", 4.678913, 2.258095, -89.575595, { 2, } }, 
	platform7 = { "platform", 2.223357, 2.313651, -89.964540, { 1, } }, 
	platform2 = { "platform", -12.200000, -0.916388, 0.000000, { 1, } }, 
}
MAP.Finish = { x = 0.000000, y = 7.000000, position = 2 }
MAP.Mission = "Welcome to LovelyBigPlanet!\
The movement controls are the arrow keys,\
once you've familiarized with them go to the yellow sign\
at the top"

function MAP.init()
	MAP.Objects.helpsign_right1.helptext = "Climbing is one of the skills you need,\nwalk up to the wall and press the up key\nwhile continuing to hold the right key"
	MAP.Objects.helpsign_right2.helptext = "Some objects are in different layers, you can get past them\nwhile in a different layer, use the a/z keys\nto switch layers"
	MAP.Objects.helpsign_right3.helptext = "Good, now reach the finish"
end

function MAP.update(dt)
	MAP.Objects.helpsign_right1:checkposition(MAP.Objects.player._body)
	MAP.Objects.helpsign_right2:checkposition(MAP.Objects.player._body)
	MAP.Objects.helpsign_right3:checkposition(MAP.Objects.player._body)
end
