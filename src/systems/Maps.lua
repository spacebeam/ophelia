local beholder = require 'lib.beholder.beholder'

-- replace beholder with signal maybe?

local MapsSystem = tiny.system(class("MapsSystem"))
MapsSystem.isDrawSystem = false 

local lgw, lgh, stale

local quadrant = nil
-- Map is not territory, but...
-- since handling 512x512 for all things.
-- TODO: return all hardcoded location data from tools.check_supported_maps
local quadrants = {}
quadrants["A"] = {
    ["scout"] = {["x"]=450,["y"]=50},
    ["main"] = {["x"]=476,["y"]=34},
    ["natural"] = {["x"]=352,["y"]=54},
    ["third"] = {["x"]=490,["y"]=220},
    ["center"] = nil,
}
quadrants["B"] = {
    ["scout"] = {["x"]=50,["y"]=50},
    ["main"] = {["x"]=35,["y"]=35},
    ["natural"] = {["x"]=56,["y"]=152},
    ["third"] = {["x"]=216,["y"]=20},
    ["center"] = {["x"]=256,["y"]=256},
}
quadrants["C"] = {
    ["scout"] = {["x"]=50,["y"]=450},
    ["main"] = {["x"]=36,["y"]=470},
    ["natural"] = {["x"]=145,["y"]=450},
    ["third"] = {["x"]=30,["y"]=290},
    ["center"] = nil,
}
quadrants["D"] = {
    ["scout"] = {["x"]=450,["y"]=450},
    ["main"] = {["x"]=476,["y"]=474},
    ["natural"] = {["x"]=440,["y"]=354},
    ["third"] = {["x"]=315,["y"]=490},
    ["center"] = nil,
}
quadrants["A"][1] = 0
quadrants["A"][2] = 0
quadrants["A"][3] = 0
quadrants["A"][4] = 0
quadrants["B"][5] = 0
quadrants["B"][6] = 0
quadrants["B"][7] = 0
quadrants["B"][8] = 0
quadrants["C"][9] = 0
quadrants["C"][10] = 0
quadrants["C"][11] = 0
quadrants["C"][12] = 0
quadrants["D"][13] = 0
quadrants["D"][14] = 0
quadrants["D"][15] = 0
quadrants["D"][16] = 0

beholder.observe('resize', function(w, h)
    stale = true
    lgw = w
    lgh = h
end)

function MapsSystem:init(camera, tileMap)
	self.camera = camera
	self.tileMap = tileMap
end

function MapsSystem:update(dt)
    local c = self.camera
    local tm = self.tileMap
    local s = c:getScale()
    local tx, ty = c:getVisibleCorners()
    if stale then
        stale = nil
        tm:resize(lgw, lgh)
    end
    tm:update(dt)
    tm:draw(-tx + 16, -ty + 16, s)
end

return MapsSystem