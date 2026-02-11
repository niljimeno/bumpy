local math = require "math"

function vector(x, y)
    x = x or 0
    y = y or 0
    add = function(self, vec)
	return vector(
	    self.x + vec.x,
	    self.y + vec.y)
    end

    sub = function(self, vec)
	return vector(
	    self.x - vec.x,
	    self.y - vec.y)
    end
	
    scale = function(self, val)
	return vector(
	    self.x * val,
	    self.y * val)
    end

    return {
	x=x,
	y=y,
	add=add,
	sub=sub,
	scale=scale
    }
end

function degreeToVector(deg)
    return vector(
	math.cos(math.rad(deg)),
	math.sin(math.rad(deg))
    )
end

function vectorToDegree(vec)
    math.atan2(vec.x, vec.y)
end

function lerp(a, b, t)
    return a - (a - b) * t
end

function clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end

return {
    vector = vector,
    lerp = lerp,
    clamp = clamp
}
