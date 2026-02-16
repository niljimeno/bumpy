local Camera = {}
local gameWidth, gameHeight
local screenOffsetX, screenOffsetY

function Camera.centerOnWorld(world)
    gameWidth, gameHeight = love.graphics.getDimensions()
    
    screenOffsetY = (gameHeight - world.getPositionHeight()) / 2
    screenOffsetX = (gameWidth - world.getPositionWidth()) / 2
end

function Camera.positionToScreen(x, y)
    return x + screenOffsetX, y + screenOffsetY
end

return Camera