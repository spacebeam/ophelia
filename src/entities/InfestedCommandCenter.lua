local name = "Zerg_Infested_Command_Center"
-- Our BWAPI unit type
local type = 130
-- Our label 
local label = "zerg_structure"
-- Our category
local category = "advanced_building"
-- The standard local variables
local armor = 1
local hitpoints,shield = 1500,0
local ground_damage,air_damage = 0,0
local ground_cooldown,air_cooldown = 0,0
local ground_range,air_range = 0,0
local sight = 8
local supply = 0
local cooldown = 3
-- The infested command center does not cost mineral or gas
-- Its the result of one of the Queen's spells.
local mineral = nil
local gas = nil
local holdkey = nil
local hash = "614ad2f3fa28d442e373cab552428fbc"
