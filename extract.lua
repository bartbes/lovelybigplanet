function installpackage(pkgfile)
	local i = io.open(pkgfile)
	local contents = i:read("*a")
	print("Dirs:")
	for dir in contents:match("^(.-)=%-=%-=%-=%-"):gmatch("(.-)\n") do
		print("\t" .. dir)
	end
	print("Files:")
	for name, contents in contents:gmatch("=%-=%-=%-=%-(.-)%-=%-=%-=%-=") do
		if name == "=" then break end
		print("\t" .. name)
	end
	i:close()
end

installpackage(arg[1])
