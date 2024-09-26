local sti = require 'libraries.sti'
local Groups = require "game.groups"
local Player = require "game.level.entity.entities.player"
local Slime = require "game.level.entity.entities.slime"
local ItemEntity = require "game.level.entity.entities.item_entity"
local Item = require "game.level.item.item"
local Items = require "game.level.item.items"

local Level = {}
Level.__index = Level

function Level:new()
    local instance = {
        gameMap = sti('maps/world_1.lua'),
        groups = {},
        _entities = {},
    }
    -- groups
    instance.groups.spritesRender = Groups.newGroup(Groups.SPRITES_RENDER)
    instance.groups.entitiesGroup = Groups.newGroup(Groups.ENTITY)

    return setmetatable(instance, self)
end

function Level:load()
    Player:new(self, {self.groups.spritesRender, self.groups.entitiesGroup}, {}, {self.groups.entitiesGroup}):spawn(100, 100)
    -- spawn random slimes
    for i = 1, 10, 1 do
        Slime.Slime:new(self, {self.groups.spritesRender, self.groups.entitiesGroup}, {}, Slime.SlimeData.NORMAL):spawn(math.random(0, 600), math.random(0, 600))
    end
    for i = 1, 10, 1 do
        ItemEntity:new(Item:new(Items.APPLE, 2), self, {self.groups.spritesRender, self.groups.entitiesGroup}, {}, self.groups.entitiesGroup):spawn(math.random(0, 600), math.random(0, 600))
    end
end

-- spawn entity
function Level:_spawnEntity(entity)
    table.insert(self._entities, entity)
end

-- remove entity
function Level:_removeEntity(entity)
    for i, e in pairs(self._entities) do
        if e == entity then
            table.remove(self._entities, i)
            return
        end
    end
end

-- update
function Level:update(dt)
    local sprites
    -- entity update
    sprites = self.groups.entitiesGroup:sprites()
    for _, entity in pairs(sprites) do
        entity:update(dt)
    end
end

function Level:draw()
    -- TODO: look better
    self.gameMap:draw(0, 0, 2, 2)
    -- draw sprites render group
    self.groups.spritesRender:draw()
end

return Level