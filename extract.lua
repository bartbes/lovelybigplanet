extract = {}

function extract.extract(pkgfile, dircb, filecb, donecb)
	dircb = dircb or extract.dir
	filecb = filecb or extract.file
	local i = love.filesystem.newFile(pkgfile)
	i:open("r")
	local contents = i:read()
	for dir in contents:match("^(.-)=%-=%-=%-=%-"):gmatch("(.-)\n") do
		dircb(dir)
	end
	for name, contents in contents:gmatch("=%-=%-=%-=%-(.-)%-=%-=%-=%-=\n(.-)\n=%-=%-=%-=%-%-%-=%-=%-=%-=") do
		if name == "=" then break end
		filecb(name, contents)
	end
	i:close()
	if donecb then donecb() end
end

function extract.dir(dir)
	love.filesystem.mkdir(dir)
end

function extract.file(name, contents)
	local f = love.filesystem.newFile(name)
	f:open("w")
	f:write(contents)
	f:close()
end
