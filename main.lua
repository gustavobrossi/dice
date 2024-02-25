-- Define tables for computer and human players
local players = {
    computer = {},
    human = {}
}

-- Define window dimensions
local window = {
    width = 777,
    height = 472
}

-- Variable to track game start
local start = false

-- Load font
local font

function love.load()
    -- Set window title and mode
    love.window.setTitle('Dice')
    love.window.setMode(window.width, window.height, {resizable = false, vsync = false})
    
    -- Set background color
    love.graphics.setBackgroundColor(0, 0, 0)
    
    -- Seed random number generator (moved to love.load)
    math.randomseed(os.time())
    
    -- Load images for human and computer
    players.human.img = love.graphics.newImage('img/d1.png')
    players.computer.img = love.graphics.newImage('img/d1_inverted.png')
    
    -- Set player names
    players.human.name = "Human"
    players.computer.name = "Computer"
    
    -- Set players dice position
    players.human.position = 0

    -- Load font
    font = love.graphics.setNewFont("font/Sniglet-webfont.ttf", 72)
end

function love.draw()
    -- Check if game has started
    if start == false then
        -- Display game result
        local winnerText = players.human.win and "Human wins!" or "Computer wins!"
        love.graphics.printf(winnerText, 0, window.height - 76, window.width, 'center')
    else
        -- Display instructions to start game
        love.graphics.printf("Click to roll", 0, window.height - 76, window.width, 'center')
    end
    -- Draw human and computer dice images
    local humanX, computerX = 33, window.width * 0.5
    if players.human.position == 1 then
        humanX, computerX = computerX, humanX
    end
    love.graphics.draw(players.human.img, humanX, 30, 0, 0.2, 0.2)
    love.graphics.draw(players.computer.img, computerX, 30, 0, 0.2, 0.2)
end

function love.mousepressed(x, y, button)
    if start then return end  -- Do nothing if the game has already started
    players.human.position = x < window.width/2 and 0 or 1
    startGame(button)
end

function startGame(button)
    -- Reset game state
    start = false

    -- Roll dice and handle cheats
    rollDices()

    if button == 2 then
        while players.human.roll > players.computer.roll do
            rollDices()
        end
    elseif button == 3 then
        while players.human.roll < players.computer.roll do
            rollDices()
        end
    end

    -- Load dice images based on roll results
    players.human.img = love.graphics.newImage('img/d' .. players.human.roll .. '.png')
    players.computer.img = love.graphics.newImage('img/d' .. players.computer.roll .. '_inverted.png')
    
    -- Determine winner
    players.human.win = players.human.roll > players.computer.roll
end

function rollDices()
    -- Roll dice for computer and human
    local computerRoll, humanRoll
    
    -- Ensure the rolls are different
    repeat
        computerRoll = math.random(1, 6)
        humanRoll = math.random(1, 6)
    until computerRoll ~= humanRoll
    
    -- Assign rolls to players
    players.computer.roll = computerRoll
    players.human.roll = humanRoll
end

