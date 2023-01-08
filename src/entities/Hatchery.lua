-- Zerg's most important building.

local Hatchery = class("Hatchery")

function Hatchery:init(x, y)
    self.pos = {x = x, y = y}
    
    self.isAlive = true
    self.isEnemy = true

    self.ai = {}

    self.health = 1250
    self.maxHealth = 1250
    self.armor = 1
    self.spawntime = 75

    self.fg = true
end

return Hatchery
