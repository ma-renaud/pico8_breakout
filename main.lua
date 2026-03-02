function _init()
    cls()
    ball_x = 5
    ball_y = 35
    ball_r = 2
    ball_dx = 2
    ball_dy = 2

    pad_x = 52
    pad_y = 120
    pad_w = 24
    pad_h = 3
    pad_dx = 0
    max_dx = 3
    min_dx = max_dx*-1
    pad_ddx = 0.4

    prev_btn = nil
end

function _update()
    bounce()
    move_pad()
    move_ball()
end

function _draw()
    rectfill(0,0,127,127, 1)
    circfill(ball_x, ball_y, ball_r, 14)
    rectfill(pad_x, pad_y, pad_x+pad_w, pad_y+pad_h, 7)
end
