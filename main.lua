#!/usr/bin/env luajit
--
-- Do not break the laws of physics.
--


-- A slightly improved classic way

-- + Slightly better parallelism
-- + Complete control over the system
-- - Problems with execution time
-- - Only limited parallelism

-- Need Messages to communicate and synchronise

-- MUST have QA, things like continuous integration and testing
-- we learned a lot of those lessons and they're very important
-- we will do them sooner rather than later...


-- Go fully parallel, everything in processes.

-- Communicate/synchronise with messages

-- Reduce all central state to a minimum

-- Processes can be implemented in different languages, interface through messages.


local bw_thread -- Our BW thread

-- Global variables
class = require("lib.30log.30log")
tiny = require("lib.tiny-ecs.tiny")

-- slightly modified to play nice with 30log
gamestate = require("lib.hump.gamestate")

local socket = require("socket")
local uuid = require("uuid")
local observer = require("lib.beholder.beholder")

local Sim = require("src.states.Sim")

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
    bw_thread = love.thread.newThread( "src/TorchCraft.lua" )
    bw_thread:start()

    turbo_thread = love.thread.newThread( "src/HTTPServer.lua" )
    turbo_thread:start()

	gamestate.registerEvents()
	gamestate.switch(Sim("maps/Polypoid.lua"))
end

function love.update(dt)
    if world then
        world:update(dt, updateFilter)
    end
end

-- quitting
observer.observe("keypress", "escape", love.event.quit)
