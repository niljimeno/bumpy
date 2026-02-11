local math = require "math"

function vector(x, y)
    x = x or 0
    y = y or 0
    add = function(self, vec)
	self.x = self.x + vec.x
	self.y = self.y + vec.y
    end
    
    return {
	x=x,
	y=y,
	add=add
    }
end

function degreeToVector(deg, scale)
    scale = scale or 1
    return vector(
	math.sin(deg) * scale,
	math.cos(deg) * scale
    )
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
