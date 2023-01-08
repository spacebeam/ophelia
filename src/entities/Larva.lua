local assets
local anim8
local Explosion
local Larva

local name = "Zerg_Larva"
-- Our BWAPI unit type
local type = 35
-- Our label
local label = "zerg_unit"
-- Our category
local category = "small_ground"
-- The standard local variables
local armor = 10
local hitpoints,shield = 25,0
local ground_damage,air_damage = 0,0
local ground_cooldown,air_cooldown = 0,0
local ground_range,air_range = 0,0
local sight = 4
local speed = 0.3
local supply = 0
local cooldown = 14
local mineral = 0
local gas = 0
local holdkey = nil
local hash = "2675712dfbab5ec154eb6a1c3da3f51b"

-- Larva.sprite = assets.img_larva

function Larva:init(x, y, target)
    self.pos
    self.vel

    self.isAlive
    self.isEnermy

    self.ai

    self.health
    self.maxHealth
    self.fg = true
end

return Larva
