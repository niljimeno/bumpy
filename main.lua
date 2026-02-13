world = require("world")
player = require("player")
background = require("background")

function love.load()
    world.load()
    player.init()    
end

function love.update(dt)
    background.update(dt)
    player.update(dt)
end

function love.draw()
    background.draw()
    world.draw()
    player.draw()
end
