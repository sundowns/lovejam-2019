return function(x, y)
    local boulderImg = love.graphics.newImage("asset/crate.png")
    local boulder =
        Entity():give(COMPONENTS.sprite, boulderImg):give(
        COMPONENTS.position,
        x * CONSTANTS.CELL_WIDTH,
        y * CONSTANTS.CELL_HEIGHT
    ):give(COMPONENTS.gridlocked, 0.25, x, y):give(COMPONENTS.direction):give(COMPONENTS.pushable):apply()

    return boulder
end
