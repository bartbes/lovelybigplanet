LoveUI.Object=class:new();

function LoveUI.Object:copy()
	local cpy=self:new()
	cpy.__baseclass=self.__baseclass
	local str=""
	for k, v in pairs(self) do
		if type(v)=="table" then
			--if table contains reference to self then duplicate it and change refs.
			local needsdup=false
			for j, w in pairs(v) do
				if v[j]==self then
					needsdup=true
				end
			end
			if needsdup then
				cpy[k]={}
				for j, w in pairs(v) do
					if self[k][j]==self then
						cpy[k][j]=cpy; --restore self references
					else
						
						cpy[k][j]=w
					end
				end
				setmetatable(cpy[k], getmetatable(self[k]))
			else
				cpy[k]=v;
			end
			
		else
			cpy[k]=v;
		end
		str=str..k
	end
	--error(tostring(cpy.frame))
	return cpy;
end


function LoveUI.Object:init()
	return self;
end

function LoveUI.Object:isEqual(anObject)
	-- Returns boolean value that indicates whether the object and anObject are equal.
	return self==anObject;
end

function LoveUI.Object:isSubclassOfClass(aClass)
	--Only works for directly inherited classes.
	local c=self;
	while(c~=nil) do
		
		if c==aClass then
			return true;
		end
		
		c=c.__baseclass;
		
		if c==class and aClass~=class then
			return false;
		end
	end
end
