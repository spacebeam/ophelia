#!/usr/bin/env luajit
--
-- Do not break the laws of physics.
--

local bw_thread -- Our threads
local http_thread
local netcode_thread

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

    http_thread = love.thread.newThread( "src/HTTPServer.lua" )
    http_thread:start()

    netcode_thread = love.thread.newThread( "src/NetCode.lua" )
    netcode_thread:start()

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
