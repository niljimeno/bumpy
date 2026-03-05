local Map = {}

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

function Map.drawField(offsetX, offsetY)
    love.graphics.push("all")
    love.graphics.setColor(0.1, 0.3, 0.65, 1)
    love.graphics.rectangle("fill", offsetX, offsetY, Map.limits.max, Map.limits.max)
    love.graphics.pop()
end

function Map.drawCliff(offsetX, offsetY)
    love.graphics.push("all")
    love.graphics.setColor(0.1, 0.2, 0.3, 1)
    love.graphics.rectangle("fill", offsetX, offsetY + 200, Map.limits.max, Map.limits.max)
    love.graphics.pop()
end

return Map