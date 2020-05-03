function love.load()
  -- Set screen size
  love.window.setMode(500,500)
  timer = 0
    
  --Snake object
  snake = {}
    
  --Current position of snake head
  snake["head_ypos"] = 2
  snake["head_xpos"] = 2
  
  --Length of snake 
  snake_seg = {{snake.head_ypos, snake.head_xpos, direction}}
  
  
  --Tile map to set up game world
  -- 1 is the snake head, 2 is a snake body tile, 3 is the apple 
  tilemap = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},

  }
  
  apple()
end


function love.draw()
  
  -- Loop that iterates through tilemap, 
    for i, row in ipairs(tilemap) do
      for j, tile in ipairs(row) do
        
        -- If tile is empty draw a blank rectangle 
        if tile == 0 then
          love.graphics.setColor(0,0,0)
          love.graphics.rectangle("fill",(j-1)*50,(i-1)*50,50,50)
          
        --If tile has snake head draw snake 
        elseif tile == 1 then 
          love.graphics.setColor(0,1,0)
          love.graphics.rectangle("fill", (j-1)*50, (i-1)*50, 50, 50)
          
        --If tile has snake body draw snake tile
        elseif tile == 2 then
          love.graphics.setColor(0,1,0)
          love.graphics.rectangle("fill", (j-1)*50, (i-1)*50, 50, 50)
          
        --If tile has apple draw red apple 
        elseif tile == 3 then 
          love.graphics.setColor(1,0,0)
          love.graphics.rectangle("fill", (j-1)*50, (i-1)*50, 50, 50)
          
        end
      end
    end
end




function love.update(dt)

  -- make timer count up in seconds
  timer = timer + dt
  
  --Game loop
  while timer >= 0.5 do
    timer = 0
    clear()
    movement()
    snake.head_ypos = snake_seg[1][1]
    snake.head_xpos = snake_seg[1][2]
  end
end


local direction = 0

function movement()
   -- Snake movement, updates head position based on last key player pressed. Also checks if player is out of bounds 
  
  -- Check if snake is out of bounds, if so end game 
  if (snake.head_xpos == 10) or (snake.head_xpos == 0) or (snake.head_ypos == 10) or (snake.head_ypos == 0) then 
    love.event.quit()
  end
  
  -- If Snake head has the same coordinates as any of the snake body tiles, end game
  for item = 2, #snake_seg do
    if (snake_seg[1][1] == snake_seg[item][1]) and (snake_seg[1][2] == snake_seg[item][2]) then
      love.event.quit()
    end
  end
    
  
    
    --Assign one to snake body cordinates
  for item = 1, #snake_seg do
    tilemap[snake_seg[item][1]][snake_seg[item][2]] = 1
  end
  
  --snake_seg = {{snake.head_ypos, snake.head_xpos, direction}}

  for item = 1, #snake_seg do
    --Right movement
    if snake_seg[item][3] == 1 then
      snake_seg[item][2] = snake_seg[item][2] + 1
    end
  
    --Left movement
    if snake_seg[item][3] == 2 then
      snake_seg[item][2] = snake_seg[item][2] - 1
    end
  
    --Up movement 
    if snake_seg[item][3] == 3 then
      snake_seg[item][1] = snake_seg[item][1] - 1
    end
  
    --Down movement
    if snake_seg[item][3] == 4 then 
      snake_seg[item][1] = snake_seg[item][1] + 1
    end
  end

  if #snake_seg > 1 then
      update_direction()
  end
  applegen()
  
  
end

function update_direction()
  for item = #snake_seg,2 ,-1  do
    snake_seg[item][3] = snake_seg[item-1][3]
  end
end


function clear()
  -- Clear function, sets all tilemap values to zero 
    for i, row in ipairs(tilemap) do
      for j, tile in ipairs(row) do
        if tilemap[i][j] ~= 3 then
          tilemap[i][j] = 0
        end
      end
    end
end



function love.keypressed(key)
  -- Assigns direction value based on key pressed 
  if key == "d" then 
    direction = 1
    snake_seg[1][3] = 1
  end
  
  if key == "a" then 
    direction = 2
    snake_seg[1][3] = 2
  end
  
  if key == "w" then
    direction = 3 
    snake_seg[1][3] = 3
  end
  
  if key == "s" then 
     direction = 4
     snake_seg[1][3] = 4
  end 
end

function apple()
  --Pick random coordinate
  local xpos = love.math.random(1,9)
  local ypos = love.math.random(1,9)
  
  --If that square is empty assign apple value
  if tilemap[ypos][xpos] == 0 then 
    tilemap[ypos][xpos] = 3
  end
  
  
end

function applegen()
  --Generate a new apple tile whenever there is no apple tile on the map
  local apple_exists = 0
  for i, row in ipairs(tilemap) do
      for j, tile in ipairs(row) do
        if tilemap[i][j] == 3 then 
          apple_exists = 1
        end
      end
  end
  if apple_exists == 0 then 
    apple()
    growth()
  end
  
end


function growth()
  --add cordinates and direction of snake head at the time of function call and store them in snake_seg
  if #snake_seg > 1 then
    
    --Left movement
    if snake_seg[#snake_seg][3] == 1 then
      table.insert(snake_seg, {snake_seg[#snake_seg][1], snake_seg[#snake_seg][2]-1, snake_seg[#snake_seg][3]})
    end
  
    --Right movement
    if snake_seg[#snake_seg][3] == 2 then
      table.insert(snake_seg, {snake_seg[#snake_seg][1], snake_seg[#snake_seg][2]+1, snake_seg[#snake_seg][3]})
    end
  
    --Up movement 
    if snake_seg[#snake_seg][3] == 3 then
      table.insert(snake_seg, {snake_seg[#snake_seg][1]+1, snake_seg[#snake_seg][2], snake_seg[#snake_seg][3]})
    end
  
    --Down movement
    if snake_seg[#snake_seg][3] == 4 then 
      table.insert(snake_seg, {snake_seg[#snake_seg][1]-1, snake_seg[#snake_seg][2], snake_seg[#snake_seg][3]})
    end
    
    
  else
    table.insert(snake_seg, {snake.head_ypos, snake.head_xpos, direction})
  end
end




--TODO


--3. Implement snake growth
 -- -snake body
  ---snake body movement 











--]]