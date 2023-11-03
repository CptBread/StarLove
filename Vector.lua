require("Class")

 Class:newClass("Vector")

function Vector:init(x, y)
	defualt(self, {x = x or 0, y = y or 0})
end

function Vector:distSq(x, y)
	local dx = self.x - x
	local dy = self.y - y
	return dx*dx + dy*dy
end

function Vector:xy()
	return self.x, self.y
end

vector = {}
function vector.distSq(x0, y0, x1, y1)
	local dx = x0 - x1
	local dy = y0 - y1
	return dx*dx + dy*dy
end
