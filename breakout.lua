function init()
    prev_btn = nil

    -- Init collidables
    walls = {}
    add(walls, collidable:new({x = -2, y = 0, w = 1, h = 128}))
    add(walls, collidable:new({x = 0, y = 0, w = 128, h = 6}))
    add(walls, collidable:new({x = 128, y = 0, w = 1, h = 128}))

    collidables = {}
    for _, value in ipairs(walls) do
        add(collidables, value)
    end

    add(collidables, collidable:new({x = 52, y = 120, w = 24, h = 3, dx = 0, max_dx = 3, min_dx = -3, ddx = 0.4}))
    pad = collidables[4]
    bottom = collidable:new({x = 0, y = 128, w = 128, h = 1})
    top = collidables[2]

    -- Init game info
    credits = 3
    score = 0

    -- Init level
    level_setup()
end

function level_setup()
    ball = {
        x = 5,
        y = 35,
        r = 2,
        dx = 2,
        dy = 2,
    }

    pad.x = 52
end

function move_pad() 
    if btn() ~= prev_btn or btn() == 0 then
        -- decelerate when no button are pressed or if 
        -- direction changes
        pad.dx /= 1.3
    end

    left_space = pad.x
    right_space = 127 - (pad.x + pad.w)

    if btn(0) then
        -- Capped speed at min_dx   
        pad.dx = pad.dx <= pad.min_dx and pad.min_dx or pad.dx - pad.ddx         
    elseif btn(1) then      
        -- Capped speed at max_dx    
        pad.dx = pad.dx >= pad.max_dx and pad.max_dx or pad.dx + pad.ddx 
    end

    if pad.dx <= 0 then
        -- Prevent speed being greater than the space to the edge
        pad.dx = left_space > abs(pad.dx) and pad.dx or left_space*-1
    else
        -- Prevent speed being greater than the space to the edge
        pad.dx = right_space > pad.dx and pad.dx or right_space
    end

    pad.x += pad.dx
    prev_btn = btn()

    -- Bump the ball if collide
    if (check_collision(ball, pad)) then
        left_dist = abs(ball.x - pad.x)
        right_dist = abs(ball.x - (pad.x+pad.w))

        if (left_dist < right_dist) then
            next_x = pad.x - ball.r
            -- Prevent the ball to be pushed out of the screen
            next_x = next_x < (0 + ball.r) and (0 + ball.r) or next_x
        else
            next_x = pad.x + pad.w + ball.r
            -- Prevent the ball to be pushed out of the screen
            next_x = next_x > (127 - ball.r) and (127 - ball.r) or next_x
        end

        ball.x = next_x

        -- Check if ball is squeezed between the pad and a wall
        if ((ball.x == (0 + ball.r) or ball.x == (127 - ball.r)) and check_collision(ball, pad)) then
            -- Move pad to the ball
            if (left_space < right_space) then
                pad.x = ball.x + ball.r + 1
            else
               pad.x = ball.x - ball.r - pad.w - 1
            end

            -- Stop pad movement
            pad.dx = 0

            -- Drop the ball
            ball.dx = 0
            ball.dy = 2
        end
    end
end

function move_ball(x, y)
    -- Next ball position
    next_x = ball.x + ball.dx
    next_y = ball.y + ball.dy

    -- Check for collidables collisions on ball+1
    collidable_index = check_all_collisions({x = next_x, y = next_y, r = ball.r, dx = ball.dx, dy = ball.dy})
 
    -- Collision detected if collidable_index is not nil
    if collidable_index then
        -- Approach ball position + 1
        approach = ball_approach({x = ball.x, y = ball.y, r = ball.r, dx = ball.dx, dy = ball.dy}, collidables[collidable_index])
        ball.x = approach.next_x
        ball.y = approach.next_y
        change_ball_direction(ball, collidables[collidable_index])
    else
        next_x2 = next_x + ball.dx
        next_y2 = next_y + ball.dy
        -- Check for collidables collisions on ball+2
        collidable_index = check_all_collisions({x = next_x2, y = next_y2, r = ball.r, dx = ball.dx, dy = ball.dy})

        ball.x += ball.dx
        ball.y += ball.dy

        if collidable_index then
            -- Approach ball position + 2
            approach = ball_approach({x = next_x, y = next_y, r = ball.r, dx = ball.dx, dy = ball.dy}, collidables[collidable_index])
            -- Change direction if the ball is just touching the collidable on ball+1
            if approach.steps == 1 then 
                change_ball_direction(ball, collidables[collidable_index])     
            end
        end
    end
end

function ball_approach(ball, collidable)
    ux = sgn(ball.dx)
    uy = sgn(ball.dy)

    local res = {
        steps = 0,
        next_x = ball.x,
        next_y = ball.y
    }

    ball_collide = false
    while not ball_collide do
        res.next_x += ux
        res.next_y += uy
        res.steps += 1

        ball_collide = rect_collision(res.next_x - ball.r, res.next_x + ball.r, 
                                        res.next_y - ball.r, res.next_y + ball.r,
                                        collidable.x, collidable.x + collidable.w, 
                                        collidable.y, collidable.y + collidable.h)

        if ball_collide then
            res.next_x -= ux
            res.next_y -= uy
        end
    end

    return res
end

function check_game_over()
    if check_collision(ball, bottom) then
        credits = credits - 1
        if credits == 0 then
            state = states.gameover
        else
            level_setup()
        end
    end
end

function change_ball_direction(ball, collidable)
    -- Check if ball is on the side of the collidable
    if (ball.y - ball.r) > (collidable.y + collidable.h) or (ball.y + ball.r) < collidable.y then
        ball.dy = ball.dy * -1
    else
        ball.dx = ball.dx * -1
    end
end


function check_collision(ball, collidable)
    return rect_collision(ball.x - ball.r, ball.x + ball.r, 
                          ball.y - ball.r, ball.y + ball.r,
                          collidable.x, collidable.x + collidable.w, 
                          collidable.y, collidable.y + collidable.h)
end

function check_all_collisions(ball)
    collidable_index = nil
    for i = 1, #collidables do
        if check_collision(ball, collidables[i]) then
            collidable_index = i    
            break
        end
    end

    return collidable_index
end

function rect_collision(rect1_x1, rect1_x2, rect1_y1, rect1_y2, 
                        rect2_x1, rect2_x2, rect2_y1, rect2_y2)
    out_x = rect1_x1 > rect2_x2 or rect1_x2 < rect2_x1
    out_y = rect1_y1 > rect2_y2 or rect1_y2 < rect2_y1

    return not (out_x or out_y)
end

-- Utility to create a table enum
function table_enum(names)
  local t = {}
  for i, name in ipairs(names) do
    t[name] = i
  end
  return t
end
