player = require("player")

state = {
    player = {}
}

function love.load()
    state.player = player.new()
end

function love.draw()
    player.draw(state.player)
end
