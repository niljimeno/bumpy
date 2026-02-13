local Background = {}
local game_width, game_height
local image_width, image_height
local background_image 
local gridPos = 0
local squareSize = 60

function Background.update(dt)
    gridPos = gridPos + dt * 10
    if gridPos >= squareSize then
        gridPos = gridPos - squareSize
    end
end

function Background.draw()
    love.graphics.clear( 0.1, 0.1, 0.1, 1, true, true )
    love.graphics.setColor( 0.4, 0.4, 0.4, 1 )

    local gameWidth, gameHeight = love.graphics.getDimensions()
    local h = gameHeight / (squareSize * 2)
    local w = gameWidth / (squareSize * 2)
    
    for i = -2, h do
        for j = -2, w do
	    love.graphics.rectangle("fill",
				    j*squareSize*2+gridPos,
				    i*squareSize*2+gridPos,
				    squareSize,
				    squareSize)
	    love.graphics.rectangle("fill",
				    j*squareSize*2 + squareSize + gridPos,
				    i*squareSize*2 + squareSize + gridPos,
				    squareSize,
				    squareSize)
        end
    end

    love.graphics.setColor( 1, 1, 1, 1 )
end

return Background
