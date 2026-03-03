function _init()
    cls()

    poke(0x5f2d, 1)

    ball_x = 45
    ball_y = 50
    ball_r = 2
    ball_dx = 2
    ball_dy = 2

    pad_x = 52
    pad_y = 60
    pad_w = 24
    pad_h = 3
    pad_dx = 0
    max_dx = 3
    min_dx = max_dx*-1
    pad_ddx = 0.4
end

function _update()
    mx = stat(32)
    my = stat(33)

end

function _draw()
    rectfill(0,0,127,127, 1)
    rectfill(pad_x, pad_y, pad_x+pad_w, pad_y+pad_h, 7)
    circfill(ball_x, ball_y, ball_r, 14)

    print("mouse (" .. mx .. ", " .. my .. ")", 8, 8, 7)

	spr(0,mx-1,my-1)
end