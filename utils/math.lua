function vector(x, y)
    x = x or 0
    y = y or 0
    
    return {
	x=x,
	y=y,
    }
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