function _init()
    cls()
    init()
    cnt = 0

    -- Init states    
    states = table_enum({"start", "game", "gameover"})
    state = states.start
end

function _update()
    if state == states.start then
        if btn(5) then
            state = states.game
        end
    elseif state == states.game then        
        move_pad()
        move_ball()
        check_game_over()
    elseif state == states.gameover then
        if btn(5) then
            init()
            state = states.game
        end
    end
end

function _draw()
    if state == states.start then
        draw_start()
    elseif state == states.game then
        draw_game()
    elseif state == states.gameover then
        draw_game_over()
    end
end

function get_text_width(s)
    -- print off-screen (e.g., y = -100) and capture the returned x value
    local x, y = print(s, 0, -100)
    return x -- the final x-coordinate is the width in pixels
end

function draw_start()
    rectfill(0,0,127,127, 1)
    local str1 = "pico breakout"
    local str2 = "press ❎ to start"
    print(str1, 64 - get_text_width(str1) / 2, 40, 7)
    print(str2, 64 - get_text_width(str2) / 2, 80, 7)
    
end

function draw_game()
    rectfill(0,0,127,127, 1)
    circfill(ball.x, ball.y, ball.r, 14)
    rectfill(pad.x, pad.y, pad.x+pad.w, pad.y+pad.h, 7)

    draw_top_infos()
end

function draw_game_over()
    draw_top_infos()
    
    rectfill(0, 55, 127, 72, 0)
    local str1 = "game over"
    local str2 = "press ❎ to restart"
    print(str1, 64 - get_text_width(str1) / 2, 64-6, 7)
    print(str2, 64 - get_text_width(str2) / 2, 65, 7)
end

function draw_top_infos()    
    top:draw()
    print("credits:" .. credits, 0, 0, 7)
    print("score:" .. score, 50, 0, 7)
end
