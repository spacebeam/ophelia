--local assets = require("src.assets")
--local anim8 = require("lib.anim8.anim8")
local Explosion = require("src.entities.Explosion")
local gamestate = require("lib.hump.gamestate")

local Drone = class("Drone")

local name = "Zerg_Drone"
-- Our BWAPI unit type
local type = 41
-- Our label
local label = "zerg_unit"
-- Our category
local category = "small_ground"
-- The standard local variables
local armor = 0
local hitpoints,shield = 40,0
local ground_damage,air_damage = 5.411,0
local ground_cooldown,air_cooldown = 0.924,0
local ground_range,air_range = 1,0
local sight = 7
local speed = 3.720
local supply = 1
local cooldown = 13
local mineral = 50
local gas = 0
local holdkey = "d"
local hash = "3244f190e0b0fc28baa2ce60c615512a"

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
