local math = require("math")
local uMath = require("utils.math")
local Player = require("player")

local World = {}

local countdown = 5 
local playingGame = false

function World.load()
    map.load()
    setupRound()
    setMapLimits(PLAYER_SIZE)
end

function World.update(dt)
    handleRoundTransitions(dt)
end

function World.draw(offsetX, offsetY)
    map.draw(offsetX, offsetY)
   
    if not playingGame and countdown < 3 then
        local gameWidth, gameHeight = love.graphics.getDimensions()
        love.graphics.print(math.ceil(countdown), gameWidth / 2, gameHeight / 2)
    end
end

function handleRoundTransitions(dt)
    local playersAlive = countPlayersAlive()

    if not playingGame then
        countdown = countdown - dt

        if countdown < 0 then
            startRound()
        end    

        return
    end

    if playingGame and playersAlive <= 1 then
        countdown = countdown - dt

        if countdown < 0 then
            setupRound()

        elseif countdown < 3 then
            for _, player in pairs(players) do
                if player.state == Player.State.Waiting or player.state == Player.State.Running then
                    player.state = Player.State.Frozen
                end
            end
        end
    end
end

function startRound()
    print("START ROUND")
    
    for i, player in pairs(players) do
        player.state = Player.State.Waiting
    end
    
    playingGame = true
    countdown = 5
end

function setupRound()
    print("RESET ROUND")
   
    for i, player in pairs(players) do
        local spot = getSpawnPoint(i)

        player.state = Player.State.Frozen
        player.position.x = spot.x
        player.position.y = spot.y
        player.direction = spot.dir
	    player.velocity = uMath.vector()
    end
    
    playingGame = false
    countdown = 5
end

function countPlayersAlive()
    local total = 0
    
    for _, player in pairs(players) do
        if not isOnFloor(player.position.x, player.position.y) and player.state ~= Player.State.Dead then
            player.state = Player.State.Dead
            print("player ded")
        end

        if player.state ~= Player.State.Dead then
            total = total + 1
        end
    end

    return total
end

function isOnFloor(x, y)
    if x <= map.limits.min then return false end
    if x >= map.limits.max then return false end
    if y <= map.limits.min then return false end
    if y >= map.limits.max then return false end

    return true
end

function setMapLimits(playerSize)
    map.limits.min = map.limits.min - playerSize
    map.limits.max = map.limits.max + playerSize
end

function getSpawnPoint(index, alt)
    alt = alt or false

    if not alt then
        return map.spawnPoint[index]
    else
        return map.spawnPointAlt[index]
    end
end

return World