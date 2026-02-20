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
	math.sin(math.rad(deg)),
	math.cos(math.rad(deg))
    )
end

-- this only works in one direction
function vectorToDegree(vec)
    return math.deg(math.atan2(vec.x, vec.y))
end

function hypotenusa(vec)
    return math.abs(math.sqrt(vec.x^2 + vec.y^2))
end

function distance(vec1, vec2)
    diff = {
	x = vec1.x - vec2.x,
	y = vec1.y - vec2.y,
    }

    return hypotenusa(diff)
end

function angleDiff(a, b)
    return (a - b) % 360
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
    vectorToDegree = vectorToDegree,
    hypotenusa = hypotenusa,
    angleDiff = angleDiff,
    normalize = normalize
}
