function init()
    ball = {
        x = 5,
        y = 35,
        r = 2,
        dx = 2,
        dy = 2,
    }

    prev_btn = nil

    collidables = {}
    add(collidables, collidable:new({x = -2, y = 0, w = 1, h = 128}))
    add(collidables, collidable:new({x = 0, y = -2, w = 128, h = 1}))
    add(collidables, collidable:new({x = 128, y = 0, w = 1, h = 128}))
    add(collidables, collidable:new({x = 0, y = 128, w = 128, h = 1}))
    add(collidables, collidable:new({x = 52, y = 120, w = 24, h = 3, dx = 0, max_dx = 3, min_dx = -3, ddx = 0.4}))

    pad = collidables[5]
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
end

function check_collision(ball)
    collidable_index = nil
    for i = 1, #collidables do
        ball_collide = rect_collision(ball.x - ball.r, ball.x + ball.r, 
                                      ball.y - ball.r, ball.y + ball.r,
                                      collidables[i].x, collidables[i].x + collidables[i].w, 
                                      collidables[i].y, collidables[i].y + collidables[i].h)

        if ball_collide then
            collidable_index = i    
            break
        end
    end

    return collidable_index
end

function move_ball()
    -- Next ball position
    next_x = ball.x + ball.dx
    next_y = ball.y + ball.dy

    -- Check for collidables collisions on ball+1
    collidable_index = check_collision({x = next_x, y = next_y, r = ball.r, dx = ball.dx, dy = ball.dy})
 
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
        collidable_index = check_collision({x = next_x2, y = next_y2, r = ball.r, dx = ball.dx, dy = ball.dy})

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

function ball_approach_v2(ball, collidable)
    dist = flr(circ_to_rect_distance(ball.x, ball.y, ball.y, collidable.x, collidable.x+pad.w, collidable.y, collidable.y))-ball.r
    ball.x += ball.dx

    ball.y += dist - 1
    change_ball_direction(ball, collidable)
end

function change_ball_direction(ball, collidable)
    if (ball.y - ball.r) > (collidable.y + collidable.h) or (ball.y + ball.r) < collidable.y then
        ball.dy = ball.dy * -1
    else
        ball.dx = ball.dx * -1
    end
end
