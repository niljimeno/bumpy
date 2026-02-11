world = require("world")
player = require("player")
background = require("background")

state = {
    player = {}
}

function love.load()
    world.load()
    state.player = player.new()
    background.load()
end

function love.update(dt)
    background.update(dt)
    player.update(dt, state.player)
end

function love.draw()
    background.draw()
    world.draw()
    player.draw(state.player)
end
