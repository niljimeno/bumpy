local math = require("utils.math")
local luaMath = require("math")

players = {}

local State = {
    Frozen = 0,
    Waiting = 1,
    Running = 2,
}

function newPlayer(key, x, y)
    local instance = {
	speed = 2000,
	key = key,
	size = 20,
	
	state = State.Waiting,
	position = math.vector(x, y),
	velocity = math.vector(),
	maxVelocity = 20,
	direction = 0,

	-- temporaries
	hasCollided = false,
    }
    
    return instance
end

function init()
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
    local degDiff = luaMath.abs(
	(vectorToDegree(player.velocity) % 360) -
	(player.direction % 360))

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
    if (player.state == State.Frozen) then
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
	x = b.velocity.x - a.velocity.x,
	y = b.velocity.y - a.velocity.y,
    }
    local hitVelocityDirection = vectorToDegree(hitVelocity)
    local hitStrength = math.hypotenusa(hitVelocity)
    local hitAngleDiff = math.angleDiff(collisionAngle, hitVelocityDirection)
    local hitStrength = luaMath.cos(luaMath.rad(hitAngleDiff)) * hitStrength
    local hitVector = degreeToVector(collisionAngle)

    -- print("New things", "vel dir", bVelocityDirection, "strength", bStrength, "hit angle diff", bHitAngleDiff, "hitStrength", bHitStrength, "p2 hit angle", bHitAngle, "p2 hit vector", bHitVector.x, bHitVector.y)

    return {
     	x = a.velocity.x + hitVector.x * hitStrength,
     	y = a.velocity.y + hitVector.y * hitStrength,
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
end

function update(dt)
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

function drawWheel(player)
    local vecDir = degreeToVector(player.direction)
    local distance = 35
    local trianglePosition = {
	x = player.position.x + vecDir.x * distance,
	y = player.position.y + vecDir.y * distance
    }

    local vecB = degreeToVector(player.direction+120)
    local vecC = degreeToVector(player.direction+240)
    local wheelDiameter = 10

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
    love.graphics.circle("fill", player.position.x, player.position.y, player.size)

    if player.state == State.Waiting then
	drawWheel(player)
    end
end

function draw()
    for _,p in pairs(players) do
	drawPlayer(p)
	p.hasCollided = false
    end
end

return {
    init = init,
    update = update,
    draw = draw,
}
