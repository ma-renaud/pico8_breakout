function hits(value, high_limit, low_limit)
    low_limit = low_limit or 0
    return value > high_limit or value < low_limit
end

function rect_collision(rect1_x1, rect1_x2, rect1_y1, rect1_y2, 
                        rect2_x1, rect2_x2, rect2_y1, rect2_y2)
    out_x = rect1_x1 > rect2_x2 or rect1_x2 < rect2_x1
    out_y = rect1_y1 > rect2_y2 or rect1_y2 < rect2_y1

    return not (out_x or out_y)
end

function distance_points(x1, y1, x2, y2)
    dx = x1-x2
    dy = y1-y2
    return sqrt(dx * dx + dy * dy)
end

function circ_to_rect_distance(circ_x, circ_y, circ_r, 
                               rect_x1, rect_x2, 
                               rect_y1, rect_y2)
    vec1x = circ_x - rect_x1
    vec1y = circ_y - rect_y1
    vec2x = rect_x2 - rect_x1
    vec2y = rect_y2 - rect_y1

    coef = scalar_projection_coef(vec1x, vec1y, vec2x, vec2y)

    if coef < 0 then
        nearest_x = rect_x1
        nearest_y = rect_y1
    elseif coef > 1 then
        nearest_x = rect_x2
        nearest_y = rect_y2
    else
        nearest_x = rect_x1 + coef * vec2x
        nearest_y = rect_y1 + coef + vec2y
    end

    return distance_points(circ_x, circ_y, nearest_x, nearest_y)
end