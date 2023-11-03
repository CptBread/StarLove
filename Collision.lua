require "Vector"

rect = rect or {}
function rect.inside(r, v, y)
	local x
	if type(v) == "table" then
		x = v.x
		y = v.y
	else
		x = v
	end

	return r.x < x and r.x + r.w > x
		and r.y < y and r.y + r.h > y
end

circle = circle or {}
function circle.inside(c, v, y)
	local x
	if type(v) == "table" then
		x = v.x
		y = v.y
	else
		x = v
	end

	return Vector.distSq(c, x, y) < c.radius * c.radius
end

function circle.inside2(x0, y0, r, x1, y1)
	return Vector.distSq({x=x0, y=y0}, x, y) < r * r
end

