
-- mineral path 

local Mineral = class("Mineral")

local name = "Mineral"

local type = "mineral"

local label = "mineral"

function Mineral:init(x, y)
    self.pos = {}
    self.fg = true
end

return Mineral 
