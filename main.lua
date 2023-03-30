-- Do not break the laws of physics.

-- yo, welcome back global fren!

class = require("lib.30log.30log")
tiny = require("lib.tiny-ecs.tiny")
-- slightly modified to play nice with 30log
gamestate = require("lib.hump.gamestate")
local socket = require("socket")
local uuid = require("uuid")


-- Replace beholder with lib.hump.signal (!)
local observer = require("lib.beholder.beholder")


-- BW Simulator of all things!
local Sim = require("src.states.Sim")

-- Our bw thread
local bw_thread = love.thread.newThread("src/TorchCraft.lua")


-- filter update
local updateFilter = tiny.rejectAny('isDrawSystem')
-- Set random seed
uuid.randomseed(socket.gettime()*10000)
-- Spawn session id
local spawn_uuid = uuid()

print("Ophelia's LÖVE session " .. spawn_uuid)

function love.keypressed(k)
    observer.trigger("keypress", k)
end

function love.keyreleased(k)
    observer.trigger("keyrelease", k)
end

function love.load()
    bw_thread:start()
    gamestate.registerEvents()

    -- todo: dynamic map selection (?)
    
    gamestate.switch(Sim("maps/FightingSpirit.lua"))
end

function love.update(dt)
    if world then
        world:update(dt, updateFilter)
    end
end

-- quitting
observer.observe("keypress", "escape", love.event.quit)
