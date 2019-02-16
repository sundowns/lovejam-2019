local PATH = (...):gsub("%.init$", "")

return {
    position = require(PATH .. ".position"),
    direction = require(PATH .. ".direction"),
    keyInput = require(PATH .. ".keyInput"),
    sprite = require(PATH .. ".sprite"),
    gridlocked = require(PATH .. ".gridlocked"),
    playerControlled = require(PATH .. ".playerControlled")
}
