-- Zerg's most important building.

local Hatchery = class("Hatchery")

-- The Hatchery allows the harvesting of resources 
-- and automatically creates Larvae over time.

local name = "Zerg_Hatchery"
-- Our BWAPI unit type
local type = 131
-- Our label           
local label = "zerg_structure"
-- Our category
local category = "basic_building"
-- The standard local variables
local armor = 1
local hitpoints,shield = 1250,0
local ground_damage,air_damage = 0,0
local ground_cooldown,air_cooldown = 0,0
local ground_range,air_range = 0,0
local sight = 8
local speed = 0
local supply = 0 
local cooldown = 75
local mineral = 300
local gas = 0
local holdkey = "h"
local hash = "37cd9f9a02fd1e538b867b582023dcf4"

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
