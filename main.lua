world = require("world")
player = require("player")
camera = require("camera")
background = require("background")

players = {}

function love.load()
    local screenWidth, screenHeight = love.window.getDesktopDimensions(1)

    love.window.setMode(screenWidth, screenHeight, {
        fullscreen = true, 
        vsync = true
    })

    world.load()
    player.init(players)
    camera.centerOnWorld(world)
end

function love.update(dt)
    background.update(dt)
    camera.update(dt)
    player.update(dt, players)
end

function love.draw()
    background.draw()
    world.draw()
    player.draw(players)
end
