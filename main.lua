world = require("world")
player = require("player")

state = {
    player = {}
}

function love.load()
    world.load()
    state.player = player.new()
end

function love.update(dt)
    player.update(dt, state.player)
end

function love.draw()
    world.draw()
    player.draw(state.player)
end
