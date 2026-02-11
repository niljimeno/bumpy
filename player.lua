local math = require("utils.math")

local State = {
    Frozen = 0,
    Waiting = 1,
    Running = 2,
}
    

function newPlayer()
    local instance = {
	position = math.vector(20, 40),
	velocity = math.vector(),
	maxVelocity = 20,
	direction = 0,
	speed = 2400,
	state = State.Waiting,
    }

    return instance
end

function accelerate(dt, player)
    local change = player.speed
    player.velocity = player.velocity:add(
	degreeToVector(
	    player.direction
	):scale(change * dt))
end

function decelerate(dt, player)
    local change = player.speed * 2
    player.velocity = player.velocity:sub(
	player.velocity:scale(dt*5))
end

function move(dt, player)
    player.position = player.position:add(
	player.velocity:scale(dt))
end

function spin(dt, player)
    change = 180
    player.direction = (player.direction + change*dt) % 360
end 

function clampSpeed(player)
end

function updatePlayer(dt, player)
    if (player.state == state.Frozen) then
	decelerate(dt, player)
    elseif (love.keyboard.isDown("space")) then
	accelerate(dt, player)
	player.state = State.Running
    else
	decelerate(dt, player)
	player.state = State.Waiting
    end

    if (player.state == State.Waiting) then
	spin(dt, player)
    end

    clampSpeed(player)
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
