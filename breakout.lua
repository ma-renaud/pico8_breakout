function init()
    ball = {
        x = 5,
        y = 35,
        r = 2,
        dx = 2,
        dy = 2,
    }

    pad = {
        x = 75,
        y = 120,
        w = 24,
        h = 3,
        dx = 0,
        max_dx = 3,
        min_dx = -3,
        ddx = 0.4,
    }

    prev_btn = nil

    walls = {}
    add(walls, collidable:new({x = 0, y = 0, w = 1, h = 128}))
    add(walls, collidable:new({x = 0, y = 0, w = 128, h = 1}))
    add(walls, collidable:new({x = 126, y = 0, w = 1, h = 128}))
    add(walls, collidable:new({x = 0, y = 126, w = 128, h = 1}))
end

-- bounce the ball when it reach
-- the edge of the screen
function wall_bounce()
    if hits(ball.x, 127-ball.r-1, 1+ball.r+1) then
        sfx(0) -- Rebound sound
        ball.dx = ball.dx * -1
    end
    if hits(ball.y, 127-ball.r-1, 1+ball.r+1) then
        sfx(0) -- Rebound sound
        ball.dy = ball.dy * -1
    end
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

function move_ball()
    -- Next ball position
    next_x = ball.x + ball.dx
    next_y = ball.y + ball.dy

    -- Check for walls collisions
    wall_collide = false
    wall_index = nil
    for i = 1, #walls do
        ball_collide = rect_collision(next_x - ball.r, next_x + ball.r, 
                                      next_y - ball.r, next_y + ball.r,
                                      walls[i].x, walls[i].x + walls[i].w, 
                                      walls[i].y, walls[i].y + walls[i].h)

        if ball_collide then
            wall_index = i    
            printh("Wall: " .. wall_index, "log.txt") 
            printh("ballx: " .. ball.x .. " bally: " .. ball.y, "log.txt")
            printh("next_x: " .. next_x .. " next_y: " .. next_y, "log.txt")  
            break
        end
    end

    if ball_collide then
        move_x = ball.dx
        move_y = ball.dy

        ux = sgn(ball.dx)
        uy = sgn(ball.dy)
        while move_x ~= 0 and move_y ~= 0 do
            next_x = ball.x + ux
            next_y = ball.y + uy

            move_x += ux
            move_y += uy

            ball_collide = rect_collision(next_x - ball.r, next_x + ball.r, 
                                          next_y - ball.r, next_y + ball.r,
                                          walls[wall_index].x, walls[wall_index].x + walls[wall_index].w, 
                                          walls[wall_index].y, walls[wall_index].y + walls[wall_index].h)
            
            printh("ballx: " .. ball.x .. " bally: " .. ball.y, "log.txt")
            
            if ball_collide then
                ball_paused = true  
                break
            else
                ball.x += ux
                ball.y += uy
            end
        end
    else
        ball.x += ball.dx
        ball.y += ball.dy
    end

    -- if not ball_collide then        
    --     if (ball.dy > 0 and ball.y > pad.y-4*ball.r) then
    --         dist = flr(circ_to_rect_distance(ball.x, ball.y, ball.y, pad.x, pad.x+pad.w, pad.y, pad.y))-ball.r
    --         ball.x += ball.dx

    --         if dist < ball.r and dist > 0 then
    --             ball.y += dist - 1
    --             ball_paused = true
    --             printh("ballx: " .. ball.x .. " bally: " .. ball.y, "log.txt")
    --             ball.dy = ball.dy * -1
    --         else
    --             ball.y += ball.dy
    --         end
    --     else
    --         ball.x += ball.dx
    --         ball.y += ball.dy
    --     end
    -- end

    -- wall_bounce()
end

function get_collided(collidable_index)
    if not collidable_index then
        for i = 1, #walls do
            ball_collide = rect_collision(next_x - ball.r, next_x + ball.r, 
                                        next_y - ball.r, next_y + ball.r,
                                        walls[i].x, walls[i].x + walls[i].w, 
                                        walls[i].y, walls[i].y + walls[i].h)

            if ball_collide then
                return i
            end
        end
    else
        if(rect_collision(next_x - ball.r, next_x + ball.r, 
                                          next_y - ball.r, next_y + ball.r,
                                          walls[wall_index].x, walls[wall_index].x + walls[wall_index].w, 
                                          walls[wall_index].y, walls[wall_index].y + walls[wall_index].h)) then
     
    end   
end

function check_ball_collision()

end
