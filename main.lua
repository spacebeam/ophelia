-- We don't know where she is from, or even what strain she is.

class = require("lib.30log.30log")
tiny = require("lib.tiny-ecs.tiny")
gamestate = require("lib.hump.gamestate")

local socket = require("socket")
local uuid = require("uuid")

-- Replace beholder with lib.hump.signal (!)
local observer = require("lib.beholder.beholder")
local Sim = require("src.states.Sim")
local tc = love.thread.newThread("src/TorchCraft.lua")

local updateFilter = tiny.rejectAny('isDrawSystem')
uuid.randomseed(socket.gettime()*10000)
local spawn_uuid = uuid()

print("Ophelia's LÖVE session " .. spawn_uuid)

function love.keypressed(k)
    observer.trigger("keypress", k)
end

function love.keyreleased(k)
    observer.trigger("keyrelease", k)
end

function love.load()
    tc:start()
    gamestate.registerEvents()
    -- todo: dynamic map selection (!)
    gamestate.switch(Sim("maps/FightingSpirit.lua"))
end

function love.update(dt)
    if world then
        world:update(dt, updateFilter)
    end
end

-- quitting
observer.observe("keypress", "escape", love.event.quit)
