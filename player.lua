local math = require("utils.math")

function newPlayer()
    local instance = {
	position = math.vector(20, 40),
	velocity = 0,
	maxVelocity = 20,
	direction = 0,
	speed = 30,
    }

    return instance
end

function accelerate(dt, player)
    local change = player.speed
    player.velocity = player.velocity + change * dt
end

function decelerate(dt, player)
    local change = player.speed * 2
    player.velocity = player.velocity - change * dt
end

function move(dt, player)
    player.position:add(
	degreeToVector(
	    player.direction,
	    player.velocity*player.speed*dt))
    print(player.position.x, player.position.y)
end

function updatePlayer(dt, player)
    if (love.keyboard.isDown("space")) then
	accelerate(dt, player)
    else
	decelerate(dt, player)
    end
    player.velocity = clamp(player.velocity, 0, player.maxVelocity)
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
