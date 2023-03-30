local beholder = require 'lib.beholder.beholder'

-- replace beholder with signal maybe?

local AtlasSystem = tiny.system(class("AtlasSystem"))
AtlasSystem.isDrawSystem = false 

local lgw, lgh, stale

beholder.observe('resize', function(w, h)
    stale = true
    lgw = w
    lgh = h
end)

function AtlasSystem:init(camera, tileMap)
	self.camera = camera
	self.tileMap = tileMap
end

function AtlasSystem:update(dt)
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

return AtlasSystem
