map = require("map")
world = require("world")
player = require("player")
camera = require("camera")
background = require("background")

PLAYER_SIZE = 20

players = {}

function love.load()
    local screenWidth, screenHeight = love.window.getDesktopDimensions(1)

    love.window.setMode(screenWidth, screenHeight, {
        fullscreen = true, 
        vsync = true
    })

    player.init(players)
    world.load()
    camera.centerOnWorld(map)
end

function love.update(dt)
    player.update(dt, players)
    background.update(dt)
    camera.update(dt)
    world.update(dt)
end

function love.draw()
    local offsetX, offsetY = camera.positionToScreen(0, 0)
    
    background.draw()
    world.draw(offsetX, offsetY)
    player.draw(players)
end
