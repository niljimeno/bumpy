local math = require "math"

function vector(x, y)
    x = x or 0
    y = y or 0

    return {
	x=x,
	y=y,
    }
end

function degreeToVector(deg)
    return vector(
	math.cos(math.rad(deg)),
	math.sin(math.rad(deg))
    )
end

function vectorToDegree(vec)
    return math.deg(math.atan2(vec.x, vec.y))
end

function distance(vec1, vec2)
    diff = {
	x = vec1.x - vec2.x,
	y = vec1.y - vec2.y,
    }

    return math.sqrt(diff.x^2 + diff.y^2)
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

function normalize(value, max, min)
    min = min or 0

    return (value - min) / (max - min)
end

return {
    vector = vector,
    lerp = lerp,
    clamp = clamp,
    normalize = normalize
}
