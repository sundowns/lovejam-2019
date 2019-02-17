local renderSprite = System({COMPONENTS.sprite, COMPONENTS.position})

function renderSprite:init()
    self.spriteBank = {}
end

function renderSprite:entityAdded(e)
    local sprite = e:get(COMPONENTS.sprite)
    local instance = self:createInstance(sprite.name)
    sprite:setAnimationData(instance)
end

function renderSprite:draw()
    local e
    for i = 1, self.pool.size do
        e = self.pool:get(i)
        local img = e:get(COMPONENTS.sprite)
        local pos = e:get(COMPONENTS.position).pos

        if img.visible then
            love.graphics.setColor(1, 1, 1, 1)
            self:drawSpriteInstance(
                img.animation,
                Vector(WORLD_OFFSET.x + pos.x, WORLD_OFFSET.y + pos.y),
                0,
                img.sx,
                img.sy
            )
        end
    end
end

function renderSprite:loadSpriteSheet(spriteName)
    local err, sprite_file
    sprite_file, err = love.filesystem.load("src/animation/" .. string.lower(spriteName) .. ".lua")
    if not sprite_file then
        print("[ERROR] The following error happend: " .. tostring(err))
        return nil
    end

    self.spriteBank[spriteName] = sprite_file()
    return self.spriteBank[spriteName]
end

function renderSprite:createInstance(spriteName, currentState)
    if spriteName == nil then
        return nil
    end

    if self.spriteBank[spriteName] == nil then
        if self:loadSpriteSheet(spriteName) == nil then
            return nil
        end
    end

    -- If the specified state does not exist, use the first one
    if self.spriteBank[spriteName].layers[1][currentState] == nil then
        currentState = self.spriteBank[spriteName].animation_names[1]
    end

    return {
        animations = self:retrieveLayerInstances(spriteName, currentState),
        sprite = self.spriteBank[spriteName],
        currentState = currentState,
        time_scale = 1 --slow-mo?
    }
end

function renderSprite:changeSpriteState(instance, newState)
    -- If the specified state does not exist, we cooked
    assert(instance.sprite.layers[1][newState], "Tried to change sprite to non-existing state " .. newState)

    instance.animations = self:retrieveLayerInstances(instance.sprite.id, newState)
end

function renderSprite:update(dt)
    local e
    for i = 1, self.pool.size do
        e = self.pool:get(i)
        local sprite = e:get(COMPONENTS.sprite)
        for i, layer in pairs(sprite.animation.animations) do
            layer.animation:update(dt)
        end
    end
end

function renderSprite:drawSpriteInstance(instance, position, orientation, sx, sy)
    for i, layer in pairs(instance.animations) do
        local w, h = layer.animation:getDimensions()
        layer.animation:draw(instance.sprite.image, position.x, position.y, orientation or 0, sx, sy)
    end
end

function renderSprite:retrieveLayerInstances(spriteName, currentState)
    local layers = {}

    for i, layer in pairs(self.spriteBank[spriteName].layers) do
        local anim_data = layer[currentState]
        table.insert(
            layers,
            {
                animation = anim8.newAnimation(
                    self.spriteBank[spriteName].grid(anim_data.x, anim_data.y),
                    anim_data.frame_duration
                ),
                origin = Vector(anim_data.offset_x, anim_data.offset_y),
                -- rotation = anim_data.rotation,
                scale = Vector(anim_data.scale_x or 1, anim_data.scale_y or 1)
            }
        )
    end

    return layers
end

return renderSprite
