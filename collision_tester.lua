function _init()
    cls()

    -- enable mouse
    poke(0x5f2d, 1)

    init()
    pad.x = 125-pad.w
    pad.y = 70

    ball_dir = 1
    ball_paused = true
    btn_4_pressed = false
    btn_5_pressed = false
end

function _update()
    mx = stat(32)
    my = stat(33)
    mb = stat(34)

    if ball.dragged then
        if mb > 0 then
            ball.x = mx + ball.offset_x
            ball.y = my + ball.offset_y
        else
            ball.dragged = false
        end
    else
        -- Check for a new click on the object
        if mb > 0 then 
            if mx >= (ball.x - ball.r) and mx <= (ball.x + 2 * ball.r) 
                      and my >= (ball.y - ball.r) and my <= (ball.y + 2 * ball.r) then
                -- Calculate offset to drag from the clicked point, not the top-left corner
                ball.offset_x = ball.x - mx
                ball.offset_y = ball.y - my
            else
                ball.x = mx
                ball.y = my
                ball.offset_x = 0
                ball.offset_y = 0
            end

            ball.dragged = true
        end
    end

    -- Manually orient the ball
    if btn(5) and not btn_5_pressed then
        btn_5_pressed = true

        ball_dir = (ball_dir + 1)%2
        if ball_dir == 0 then
            ball.dx = ball.dx * -1
        else
            ball.dy = ball.dy * -1
        end
    end

    -- Pause/Unpause ball movement
    if btn(4) and not btn_4_pressed then
        btn_4_pressed = true
        if ball_paused then
            ball_paused = false
        else
            ball_paused = true
        end 
    end    

    -- Button debounce reset
    if btn() == 0 then
        btn_4_pressed = false
        btn_5_pressed = false
    end

    if not ball_paused then
        move_pad()
        move_ball()
    end
end

function _draw()
    rectfill(0,0,127,127, 1)
    rectfill(pad.x, pad.y, pad.x+pad.w, pad.y+pad.h, 7)
    circfill(ball.x, ball.y, ball.r, 14)

    for collidable in all(walls) do
        collidable:draw()
    end

    if ball_paused then
        print("paused", 8, 8, 7)
    else
        print("running", 8, 8, 7)
    end

	spr(0,mx-2,my-2)
    line(ball.x, ball.y, ball.x + ball.dx * 5, ball.y + ball.dy * 5, 10)
end