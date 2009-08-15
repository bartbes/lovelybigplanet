MAP.Name = "Sample map"
MAP.Creator = "Bart Bes"
MAP.Version = 0.1
MAP.Resources = { bg = "bartbes/samplebackground.png" } --I need only this resource for this map itself, resources of the object will be loaded by the object.
MAP.Objects = { sobject = "sampleobject" } --Load the objects, and their resources
MAP.Background = MAP.Resources.bg --The string will be replaced by the resources (by the engine)

--All this leaves is something to add objects on locations.
