
local Background = {}
local game_width, game_height
local image_width, image_height
local background_image 
local grid_pos = 0

function Background.load()
    background_image = love.graphics.newImage("assets/background.png")
    game_width, game_height = love.graphics.getDimensions()
    image_height = background_image:getHeight()
    image_width = background_image:getWidth()
end

function Background.update(dt)
    grid_pos = grid_pos + dt * 0.15
    if grid_pos >= image_width then
        grid_pos = 0
    end
end

function Background.draw()
    for i = -128, game_height do
        for j = -128, game_width do
            love.graphics.draw(
                background_image,
                (j + grid_pos) * image_width, (i + grid_pos) * image_height
            )
        end
    end
end

return Background
