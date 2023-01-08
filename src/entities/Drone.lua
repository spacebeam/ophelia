--local assets = require("src.assets")
--local anim8 = require("lib.anim8.anim8")
local Explosion = require("src.entities.Explosion")
local gamestate = require("lib.hump.gamestate")

local Drone = class("Drone")

--Drone.sprite = assets.img_drone

function Drone:init(x, y, target)
    self.pos = {}
    self.vel = {}

    self.isAlive = true
    self.isEnemy = true

    self.ai = {}
    self.health = 50
    self.maxHealth = 50

    --local g = anim8.newGrid(30, 21, assets.img_drone:getWidth(), assets.img_drone:getHeight())
    -- self.animation_stand = anim8.newAnimation(g('1-1', 1), 0.1)
    -- self.animation_walk = anim8.newAnimation(g('2-5', 1), 0.1)
    -- self.animation = self.animation_stand
    self.fg = true
end

return Drone
