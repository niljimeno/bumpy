local uMath = require("utils.math")
local World = {}

local tilemap
local tileset
local quads = {}
local width, height
local gameWidth, gameHeight
local mapWidthOffset, mapHeightOffset

function World.load()
    gameWidth, gameHeight = love.graphics.getDimensions()
    tilemap = love.graphics.newImage("assets/map.png")
    World.mapLimits = {
        min = 0,
        max = 1280
    }

    local mapHeight = tilemap:getHeight()
    local mapWidth = tilemap:getWidth()
    height = mapHeight / 4
    width = mapWidth / 3

    for i = 1, 4 do
        for j = 1, 3 do
            table.insert(quads,
                love.graphics.newQuad(
                    (j - 1) * width, (i - 1) * height,
                    width, height,
                    mapWidth, mapHeight
                ))
        end
    end

    tileset = {
        {1 , 2 , 2 , 2 , 2 , 2 , 2 , 2 , 2 , 3 },
        {4 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 6 },
        {4 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 6 },
        {4 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 6 },
        {4 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 6 },
        {4 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 6 },
        {4 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 6 },
        {4 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 6 },
        {4 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 5 , 6 },
        {7 , 8 , 8 , 8 , 8 , 8 , 8 , 8 , 8 , 9 },
        {10, 10, 10, 10, 10, 10, 10, 10, 10, 10},
        {10, 10, 10, 10, 10, 10, 10, 10, 10, 10},
        {10, 10, 10, 10, 10, 10, 10, 10, 10, 10},
        {10, 10, 10, 10, 10, 10, 10, 10, 10, 10},
        {10, 10, 10, 10, 10, 10, 10, 10, 10, 10},
    }

    mapHeightOffset = (gameHeight - #tileset[1] * height) / 2
    mapWidthOffset = (gameWidth - #tileset[1] * width) / 2
end

function World.draw()
    for i, row in ipairs(tileset) do
        for j, tile in ipairs(row) do
            love.graphics.draw(
                tilemap,
                quads[tile],
                mapWidthOffset + (j - 1) * width,
                mapHeightOffset + (i - 1) * height
            )
        end
    end
end

function World.isOnFloor(x, y)
    if x <= World.mapLimits.min then return false end
    if x >= World.mapLimits.max then return false end
    if y <= World.mapLimits.min then return false end
    if y >= World.mapLimits.max then return false end

    return true
end

return World