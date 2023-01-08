-- The Sunken Colony requires Spawning Pool technology 
-- before it can be morphed from Creep Colony.

local name = "Zerg_Sunken_Colony"
-- Our BWAPI unit type
local type = 146
-- Our label           
local label = "zerg_structure"
-- Our category
local category = "basic_building"
-- The standard local variables
local armor = 2
local hitpoints,shield = 300,0
local ground_damage,air_damage = 40,0
local ground_cooldown, air_cooldown = 1.344,0
local ground_range, air_range = 7,0
local sight = 10
local speed = 0
local supply = 0
local cooldown = 12
local mineral = 50
local gas = 0
local holdkey = "u"
local hash = "3b0bbd8d99d92ed69a56fab6cffa91c7"
