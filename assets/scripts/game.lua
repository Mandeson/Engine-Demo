function Engine.init()
    Engine.World.loadMap("Exterior")
    player = Engine.TilesetSprite.new("exterior.tsj", 69, 645, 20, 26)
end

local pointers = {}

function Engine.timeStep(time)
    local up_pressed = false
    local down_pressed = false
    local left_pressed = false
    local right_pressed = false

    if Engine.Keyboard.isKeyPressed("w") or Engine.Keyboard.isKeyPressed("up") then
        up_pressed = true
    end
    if Engine.Keyboard.isKeyPressed("s") or Engine.Keyboard.isKeyPressed("down") then
        down_pressed = true
    end
    if Engine.Keyboard.isKeyPressed("a") or Engine.Keyboard.isKeyPressed("left") then
        left_pressed = true
    end
    if Engine.Keyboard.isKeyPressed("d") or Engine.Keyboard.isKeyPressed("right") then
        right_pressed = true
    end

    for _,pos in pairs(pointers) do
        local controlButtonSize = Engine.World.getScreenTileSize() * 3
        local windowSizeX, windowSizeY = Engine.Window.getSize()
        if pos.y <= controlButtonSize then
            up_pressed = true
        end
        if pos.y >= windowSizeY - controlButtonSize then
            down_pressed = true
        end
        if pos.x <= controlButtonSize then
            left_pressed = true
        end
        if pos.x >= windowSizeX - controlButtonSize then
            right_pressed = true
        end
    end

    local move = time * 3.0
    local moveX, moveY = false, false
    if up_pressed and down_pressed then
        up_pressed = false
        down_pressed = false
    end
    if left_pressed and right_pressed then
        left_pressed = false
        right_pressed = false
    end
    if up_pressed and left_pressed then
        local root2 = math.sqrt(2)
        player:move(-move / root2, -move / root2)
        moveX, moveY = true, true
    elseif up_pressed and right_pressed then
        local root2 = math.sqrt(2)
        player:move(move / root2, -move / root2)
        moveX, moveY = true, true
    elseif down_pressed and right_pressed then
        local root2 = math.sqrt(2)
        player:move(move / root2, move / root2)
        moveX, moveY = true, true
    elseif down_pressed and left_pressed then
        local root2 = math.sqrt(2)
        player:move(-move / root2, move / root2)
        moveX, moveY = true, true
    elseif up_pressed then
        player:move(0, -move)
        moveX, moveY = false, true
    elseif down_pressed then
        player:move(0, move)
        moveX, moveY = false, true
    elseif left_pressed then
        player:move(-move, 0)
        moveX, moveY = true, false
    elseif right_pressed then
        player:move(move, 0)
        moveX, moveY = true, false
    end
    
    if not moveX or not moveY then
        local posX, posY = player:getPos()
        local screenTileSize = Engine.World.getScreenTileSize()
        posX, posY = posX * screenTileSize, posY * screenTileSize
        if not moveX then
            posX = math.floor(posX + 0.5)
        end
        if not moveY then
            posY = math.floor(posY + 0.5)
        end
        player:setPos(posX / screenTileSize, posY / screenTileSize)
    end

    local playerPosX, playerPosY = player:getPos()
    local cameraPosX, cameraPosY = Engine.World.getCameraPos()
    local larp_factor = 6 * time
    local newCameraPosX = playerPosX * larp_factor + cameraPosX * (1 - larp_factor)
    local newCameraPosY = playerPosY * larp_factor + cameraPosY * (1 - larp_factor)
    Engine.World.setCameraPos(newCameraPosX, newCameraPosY)
end

function Engine.Touchscreen.pointerDown(x, y, id)
    pointers[id] = {x = x, y = y}
end

function Engine.Touchscreen.pointerUp(x, y, id)
    if pointers[id] == nil then error("pointer") end
    pointers[id] = nil
end

function Engine.Touchscreen.pointerMove(x, y, id)
    if pointers[id] == nil then error("pointer") end
    pointers[id] = {x = x, y = y}
end

function Engine.Touchscreen.pointerCancel()
    pointers = {}
end
