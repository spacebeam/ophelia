-- We don't know where she is from, or even what strain she is.

class = require("lib.30log.30log")
tiny = require("lib.tiny-ecs.tiny")
gamestate = require("lib.hump.gamestate")
-- start testing with time
local cron = require("lib.cron.cron")
local socket = require("socket")
local uuid = require("uuid")
-- Replace beholder with lib.hump.signal (!) ?
local observer = require("lib.beholder.beholder")
local Game = require("src.states.Game")
local tc = love.thread.newThread("src/TorchCraft.lua")
local updateFilter = tiny.rejectAny('isDrawSystem')
uuid.randomseed(socket.gettime()*10000)
local spawn_uuid = uuid()

-- global time in seconds
seconds = 0

local clock

function tick()
    seconds = seconds + 1
end

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
    clock = cron.every(1, tick)
    -- todo: dynamic map selection (!)
    gamestate.switch(Game("maps/FightingSpirit.lua"))
end

function love.update(dt)
	local time = love.thread.getChannel('time'):pop()
    if time then
        seconds = time 
    end
    if world then
        world:update(dt, updateFilter)
    end
    clock:update(dt)
end

-- quit
observer.observe("keypress", "escape", love.event.quit)
