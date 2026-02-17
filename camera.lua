local uMath = require("utils.math")
local math = require("math")

local Camera = {}
local gameWidth, gameHeight
local BASE_OFFSET_X, BASE_OFFSET_Y
local screenOffsetX, screenOffsetY

local startDuration = 0
local duration = 0
local weight = 0
local speed = 0
local time = 0

function Camera.update(dt)
    if duration > 0 then
        local interval = uMath.clamp(uMath.normalize(duration, startDuration), 0, 1)
        local extraOffset = {
            x = math.sin(time) * weight * interval,
            y = math.cos(time) * weight * interval
        }

        screenOffsetY = BASE_OFFSET_Y + extraOffset.y
        screenOffsetX = BASE_OFFSET_X + extraOffset.x

        duration = duration - dt
        time = time + dt * speed
    else
        screenOffsetY = BASE_OFFSET_Y
        screenOffsetX = BASE_OFFSET_X
        time = 0
    end
end

function Camera.centerOnWorld(world)
    gameWidth, gameHeight = love.graphics.getDimensions()
    
    BASE_OFFSET_Y = (gameHeight - world.getPositionHeight()) / 2
    BASE_OFFSET_X = (gameWidth - world.getPositionWidth()) / 2

    screenOffsetY = BASE_OFFSET_Y
    screenOffsetX = BASE_OFFSET_X
end

function Camera.screenShake(d, w, s)
    print("SET SCREENSHAKE")
    time = love.math.random(0, 100)
    startDuration = d
    duration = d
    weight = w
    speed = s
end

function Camera.positionToScreen(x, y)
    return x + screenOffsetX, y + screenOffsetY
end

return Camera