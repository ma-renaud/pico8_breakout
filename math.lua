vector = {
    x = 0,
    y = 0,
}

function scalar_projection_coef(v1x, v1y, v2x, v2y)
    dot = v1x*v2x + v1y*v2y
    return dot/(v2x*v2x)
end