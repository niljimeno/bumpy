local uMath = require("utils.math")
local camera = require("camera")
local World = {}

local tilemap
local tileset
local quads = {}
local width, height

local spawnPoint = {
    {x = 128, y = 128, dir = 45 },
    {x = 512, y = 512, dir = 225},
    {x = 512, y = 128, dir = 135},
    {x = 128, y = 512, dir = 315},
}

local spawnPointAlt = { -- FOR 3 PLAYERS
    {x = 320, y = 128, dir = 90 },
    {x = 512, y = 512, dir = 225},
    {x = 128, y = 512, dir = 315},
}

local mapLimits = {
    min = 0,
    max = 640
}

function World.load()
    tilemap = love.graphics.newImage("assets/map.png")

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

    
end

function World.draw()
    local offsetX, offsetY = camera.positionToScreen(0, 0)
    for i, row in ipairs(tileset) do
        for j, tile in ipairs(row) do
            love.graphics.draw(
                tilemap,
                quads[tile],
                offsetX + (j - 1) * width,
                offsetY + (i - 1) * height
            )
        end
    end
end

function World.isOnFloor(x, y)
    if x <= mapLimits.min then return false end
    if x >= mapLimits.max then return false end
    if y <= mapLimits.min then return false end
    if y >= mapLimits.max then return false end

    return true
end

function World.setMapLimits(playerSize)
    mapLimits.min = mapLimits.min - playerSize
    mapLimits.max = mapLimits.max + playerSize
end

function World.getMapDimentions()
    return #tileset[1] * width, #tileset[1] * height
end

function World.getSpawnPoint(index, alt)
    alt = alt or false

    if not alt then
        return spawnPoint[index]
    else
        return spawnPointAlt[index]
    end
end

return World