return function(x, y)
    local rock =
        Entity():give(COMPONENTS.sprite, "ROCK", 0, 4, 4):give(
        COMPONENTS.position,
        x * CONSTANTS.CELL_WIDTH,
        y * CONSTANTS.CELL_HEIGHT
    ):give(COMPONENTS.gridlocked, 1, x, y):apply()

    return rock
end
