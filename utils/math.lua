function vector(x, y)
    x = x or 0
    y = y or 0
    
    return {
	x=x,
	y=y,
    }
end

return {
    vector = vector,
}

