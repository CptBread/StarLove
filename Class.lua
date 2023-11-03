Class = Class or {}
Class.__index = Class

-- Applies default values in the object if they are missing. Copies tables
function default_copy(obj, def, ...)
	obj = obj or {}
	if not def then return end

	for k, v in pairs(def) do
		if type(v) == "table" then
			if not obj[k] then
				obj[k] = v
			else
				default_copy(obj[k], v)
			end
		elseif not obj[k] then
			obj[k] = v
		end
	end
	
	default_copy(obj, ...)
end

-- Applies default values in the object if they are missing. References tables
function default(obj, def, ...)
	obj = obj or {}
	if not def then return obj end

	for k, v in pairs(def) do
		if not obj[k] then
			obj[k] = v
		end
	end
	
	return default(obj, ...)
end


function Class:instanceOf(class)
	local myClass = getmetatable(self);
	if myClass == class then
		return true;
	end
	if myClass == nil then
		return false;
	end
	return myClass:instanceOf(class);
end

-- Inherits from a class
function Class:newClass(name, fromTable)
	-- Defualt constructor
	if self.init == nil then
		init = function() end
	else
		init = self.init
	end

	local old = _G[name] 
	local res = old or fromTable or {}
	if fromTable and res then
		default(res, fromTable)
	end
	_G[name] = res

	res.init = init
	res.__index = res
	res.super = self
	res._className = name

	-- res.applyClass = function(self, obj, ...)
	-- 	setmetatable(obj, self)
	-- 	self.init(obj, ...)
	-- 	return obj
	-- end

	local mt = {}
	mt.__call = function(self, ...)
		local new = {}
		setmetatable(new, self)
		self.init(new, ...)
		return new
	end
	mt.__gc = function()
		print("DELETE STUFF!!!!")
	end
	mt.__index = self
	setmetatable(mt, self)
	setmetatable(res, mt)
	return res
end