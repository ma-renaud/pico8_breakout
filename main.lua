function _init()
    cls()
    init()
end

function _update()
    move_pad()
    move_ball()
end

function _draw()
    rectfill(0,0,127,127, 1)
    circfill(ball.x, ball.y, ball.r, 14)
    rectfill(pad.x, pad.y, pad.x+pad.w, pad.y+pad.h, 7)

    for collidable in all(walls) do
        collidable:draw()
    end
end
