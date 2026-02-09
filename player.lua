local math = require("utils.math")

function newPlayer()
    local instance = {
	position = math.vector(20, 40),

	speed = math.vector(),
    }

    return instance
end

function drawPlayer(player)
    love.graphics.circle("fill", player.position.x, player.position.y, 20)
end

return {
    new = newPlayer,
    draw = drawPlayer,
}
