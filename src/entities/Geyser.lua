-- vespene geyser 

local Geyser = class("Geyser")

local name = "Vespene_Geyser"

local type = "geyser"

local label = "vespene_geyser"

function Geyser:init(x, y)
    self.pos = {}
    self.fg = true
end

return Geyser
