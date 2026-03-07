collidable = {
    x = 5,
    y = 5,
    w = 5,
    h = 5,
    visible = true,
    destroyed = false,

    new = function (self, tbl)
        tbl = tbl or {}
        setmetatable(tbl, {
            __index = self
        }) 
        return tbl
    end,

    draw = function (self)
        rectfill(self.x, self.y, 
                 self.x + self.w, 
                 self.y + self.h, 7)
    end,
}

