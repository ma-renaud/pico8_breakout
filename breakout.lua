-- bounce the ball when it reach
-- the edge of the screen
function bounce()
    -- Pad bounce
    if rect_collision(ball_x-ball_r, ball_x+ball_r, 
                      ball_y-ball_r, ball_y+ball_r, 
                      pad_x, pad_x+pad_w, 
                      pad_y, pad_y+pad_h) then
        sfx(0) -- Rebound sound
        ball_dy = ball_dy * -1
    end

    -- Wall bounce
    if hits(ball_x, 127-ball_r-1, 1+ball_r+1) then
        sfx(0) -- Rebound sound
        ball_dx = ball_dx * -1
    end
    if hits(ball_y, 127-ball_r-1, 1+ball_r+1) then
        sfx(0) -- Rebound sound
        ball_dy = ball_dy * -1
    end
end

function move_pad() 
    if btn() ~= prev_btn or btn() == 0 then
        -- decelerate when no button are pressed or if 
        -- direction changes
        pad_dx /= 1.3
    end

    left_space = pad_x
    right_space = 127 - (pad_x + pad_w)

    if btn(0) then
        -- Capped speed at min_dx   
        pad_dx = pad_dx <= min_dx and min_dx or pad_dx - pad_ddx         
    elseif btn(1) then      
        -- Capped speed at max_dx    
        pad_dx = pad_dx >= max_dx and max_dx or pad_dx + pad_ddx 
    end

    if pad_dx <= 0 then
        -- Prevent speed being greater than the space to the edge
        pad_dx = left_space > abs(pad_dx) and pad_dx or left_space*-1
    else
        -- Prevent speed being greater than the space to the edge
        pad_dx = right_space > pad_dx and pad_dx or right_space
    end

    pad_x += pad_dx
    prev_btn = btn()
end

function move_ball()
    if (ball_dy > 0 and ball_y > pad_y-4*ball_r) then
        dist = circ_to_rect_distance(ball_x, ball_y, ball_y, pad_x, pad_x+pad_w, pad_y, pad_y)-ball_r
        printh("dist: " .. dist, "breakout/log.txt")
        ball_x += ball_dx

        if dist < ball_r and dist > 0 then
            ball_y += dist
        else
            ball_y += ball_dy
        end
    else
        ball_x += ball_dx
        ball_y += ball_dy
    end
end
