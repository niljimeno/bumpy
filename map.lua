local camera = require("camera")

local Map = {}

local quads = {}
local width, height
local tileset, tilemap

Map.limits = {
    min = 0,
    max = 640
}

Map.spawnPoint = {
    {x = 128, y = 128, dir = 45 },
    {x = 512, y = 512, dir = 225},
    {x = 512, y = 128, dir = 135},
    {x = 128, y = 512, dir = 315},
}

Map.spawnPointAlt = { -- FOR 3 PLAYERS
    {x = 320, y = 128, dir = 90 },
    {x = 512, y = 512, dir = 225},
    {x = 128, y = 512, dir = 315},
}

function Map.load()
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

function Map.draw()
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

function Map.getDimensions()
    return #tileset[1] * width, #tileset[1] * height
end

return Map