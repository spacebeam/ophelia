local name = "Zerg_Extractor"
-- Our color               
local color = "red"
-- Our BWAPI unit type
local type = 149
-- Our label           
local label = "zerg_structure"
-- Our category
local category = "basic_building"
-- Size of a clock tick msec
local tick
-- It's me, the unit structure 
local me = unit.self()
-- The standard local variables
local armor = 1
local hitpoints,shield = 750,0
local ground_damage,air_damage = 0,0
local ground_cooldown,air_cooldown = 0,0
local ground_range,air_range = 0,0
local sight = 8
local speed = 0
local supply = 0
local cooldown = 25
local mineral = 50
local gas = 0
local holdkey = "e"
