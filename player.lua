local math = require("utils.math")

function newPlayer()
    local instance = {
	position = math.vector(20, 40),
	velocity = math.vector(),
	speed = 3000,
    }

    return instance
end

function accelerate(dt, player)
    local change = player.speed * dt
    player.velocity.x = player.velocity.x + change
end

function decelerate(dt, player)
    local change = player.speed * dt
    player.velocity.x = player.velocity.x - change
end

function move(dt, player)
    player.position.x = player.position.x + (player.velocity.x*dt)
end

function updatePlayer(dt, player)
    if (love.keyboard.isDown("space")) then
	accelerate(dt, player)
    else
	decelerate(dt, player)
    end
    move(dt, player)
end


function drawPlayer(player)
    love.graphics.circle("fill", player.position.x, player.position.y, 20)
end

return {
    new = newPlayer,
    update = updatePlayer,
    draw = drawPlayer,
}
