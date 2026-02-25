local math = require("utils.math")
local luaMath = require("math")

local State = {
    Frozen = 0,
    Waiting = 1,
    Running = 2,
    Dead = 3,
}

function newPlayer(key, x, y)
    local instance = {
	speed = 2000,
	key = key,
	size = 20,
    
    score = 0,
	state = State.Waiting,
    scale = math.vector(1, 1),
	position = math.vector(x, y),
	velocity = math.vector(),
	maxVelocity = 20,
	direction = 0,

	hasCollided = false,
    }

    return instance
end

function init(players)
    table.insert(players, newPlayer("space", 20, 40))
    table.insert(players, newPlayer("a", 100, 250))
end

function decelerate(dt, player)
    local decreaseScale = 4
    local change = decreaseScale * dt
    player.velocity.x = player.velocity.x - player.velocity.x * change
    player.velocity.y = player.velocity.y - player.velocity.y * change
end

function accelerate(dt, player)
    local change = player.speed * dt
    local directionVector = degreeToVector(player.direction)

    player.velocity.x = player.velocity.x + directionVector.x * change
    player.velocity.y = player.velocity.y + directionVector.y * change
end

function move(dt, player)
    player.position.x = player.position.x + player.velocity.x * dt
    player.position.y = player.position.y + player.velocity.y * dt
end

function spin(dt, player)
    local change = 180
    player.direction = (player.direction + change*dt) % 360
end

function updatePlayer(dt, player)
    if (player.state == State.Dead) then
        decelerate(dt, player)

    elseif (player.state == State.Frozen) then
	decelerate(dt, player)
    elseif (love.keyboard.isDown(player.key)) then
	accelerate(dt, player)
	player.state = State.Running
    else
	decelerate(dt, player)
	player.state = State.Waiting
    end

    if (player.state == State.Waiting) then
	spin(dt, player)
    end

    move(dt, player)
end

function areColliding(a, b)
    return distance(a.position, b.position) < (a.size + b.size)
end

function newVelocity(a, b)
    local vecDiff = {
	    x = b.position.x - a.position.x,
	    y = b.position.y - a.position.y,
    }

    local collisionAngle = math.vectorToDegree(vecDiff)
    local hitVelocity = {
	x = b.velocity.x - (a.velocity.x / 2),
	y = b.velocity.y - (a.velocity.y / 2),
    }
    local hitVelocityDirection = vectorToDegree(hitVelocity)
    local hitStrength = math.hypotenusa(hitVelocity)
    local hitAngleDiff = math.angleDiff(collisionAngle, hitVelocityDirection)
    local hitStrength = luaMath.cos(luaMath.rad(hitAngleDiff)) * hitStrength
    local hitVector = degreeToVector(collisionAngle)

    -- print("New things", "vel dir", bVelocityDirection, "strength", bStrength, "hit angle diff", bHitAngleDiff, "hitStrength", bHitStrength, "p2 hit angle", bHitAngle, "p2 hit vector", bHitVector.x, bHitVector.y)

    return {
     	x = a.velocity.x / 2 + hitVector.x * hitStrength,
     	y = a.velocity.y / 2 + hitVector.y * hitStrength,
    }
end

function collide(p, p2)
    local vecDiff = {
	x = p2.position.x - p.position.x,
	y = p2.position.y - p.position.y,
    }
    local collisionAngle = ( math.vectorToDegree(vecDiff) + 180 ) % 360
    local dirVec = degreeToVector(collisionAngle)

    pNew = newVelocity(p, p2)
    p2New = newVelocity(p2, p)

    local margin = 1
    p.position.x = p2.position.x + dirVec.x * (p.size + p2.size + margin)
    p.position.y = p2.position.y + dirVec.y * (p.size + p2.size + margin)

    p.velocity = pNew
    p2.velocity = p2New

    camera.screenShake(1, 15, 20)
end

function update(dt, players)
    for _,p in pairs(players) do
	updatePlayer(dt, p)
    end

    for _,p in pairs(players) do
	if p.hasCollided then
	    goto continue
	end

	for _,p2 in pairs(players) do
	    if p == p2 then
		goto continue
	    end
	    if areColliding(p, p2) then
		collide(p, p2)
		p2.hasCollided = true
	    end
	end
	::continue::
    end
end

function drawWheel(player, offsetX, offsetY)
    local vecDir = degreeToVector(player.direction)
    local distance = player.size * 1.7
    local trianglePosition = {
	x = player.position.x + offsetX + vecDir.x * distance,
	y = player.position.y + offsetY + vecDir.y * distance
    }

    local vecB = degreeToVector(player.direction+120)
    local vecC = degreeToVector(player.direction+240)
    local wheelDiameter = player.size / 2

    love.graphics.setColor(1, 0.8, 0.4, 1)
    love.graphics.polygon(
	"fill",
	trianglePosition.x + vecDir.x*wheelDiameter/2,
	trianglePosition.y + vecDir.y*wheelDiameter/2,
	trianglePosition.x + vecB.x*wheelDiameter,
	trianglePosition.y + vecB.y*wheelDiameter,
	trianglePosition.x + vecC.x*wheelDiameter,
	trianglePosition.y + vecC.y*wheelDiameter)
    love.graphics.setColor(1, 1, 1, 1)
end

function drawPlayer(player)
    local offsetX, offsetY = camera.positionToScreen(0, 0)
    local playerSpeed = luaMath.abs(player.velocity.x) + luaMath.abs(player.velocity.y)
    local interval = math.normalize(playerSpeed, 1000)
    
    if player.hasCollided then
        player.scale.y = 0.2
        player.scale.x = 1.8

    elseif player.state == State.Running then
        player.scale.y = math.lerp(player.scale.y, math.clamp(1 + interval, 1, 1.5), 0.1)
        player.scale.x = math.lerp(player.scale.x, math.clamp(1 - interval, 0.5, 1), 0.1)

    else
        player.scale.x = math.lerp(player.scale.x, 1, 0.05)
        player.scale.y = math.lerp(player.scale.y, 1, 0.05)

    end                 

    love.graphics.push()

    love.graphics.translate(player.position.x + offsetX,
                            player.position.y + offsetY)

    love.graphics.rotate(-luaMath.rad(player.direction))
    love.graphics.scale(player.scale.x, player.scale.y)

    love.graphics.circle("fill", 0, 0, player.size)

    love.graphics.pop()
    
    if player.state == State.Waiting then
	drawWheel(player, offsetX, offsetY)
    end
end

function draw(players)
    for _,p in pairs(players) do
	drawPlayer(p)
	p.hasCollided = false
    end
end

return {
    init = init,
    update = update,
    State = State,
    draw = draw,
}
