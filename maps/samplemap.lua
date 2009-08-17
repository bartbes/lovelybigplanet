MAP.Name = "Sample map"
MAP.Creator = "Bart Bes" --Hey, I want to be recognized too! You are (of course) free to use it as a template
MAP.Version = 0.1
MAP.Resources = { background = "bartbes/samplebackground" } --I need only this resource for this map itself, resources of the object will be loaded by the object.
MAP.Objects = { sobject = { "sampleobject", 0, 0, 0, {Foreground} } } --Load the objects, and their resources
--name, x, y, angle, layer(s)
MAP.Finish = { x = 0, y = 0, position = Foreground } --finish location, at (0, 0) on the foreground
MAP.ShowScore = false --we don't need score
MAP.BackgroundScale = { x = 1 } --if no y, the x value is used as y value
MAP.Mission = "Yo!" --displays "Yo!" at startup

function MAP.init() --if you want to initialize something, like set values in objects
--this is called after they are loaded
end

function MAP.update(dt) --yes, an update callback
end

function MAP.finished() --the finish location is reached
	return false --you can do some checks and return if it is really finished
	--or, just display a message..
end

