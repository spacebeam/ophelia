-- bw simulator of all things 

local inspect = require("inspect")
local sti = require("lib.sti.sti")
local TimerEvent = require("src.entities.TimerEvent")

-- oop? kek
local Sim = class("Sim")

function Sim:init(mappath)
	self.mappath = mappath
end

function Sim:load()
	-- tile map setup
	local tileMap = sti(self.mappath)
    local w, h = tileMap.tilewidth * tileMap.width, tileMap.tileheight * tileMap.height

	-- multi-threaded channel magics!
	local resources = love.thread.getChannel('resources'):pop()
	
	-- as in we got resources now wut?
	local actions = {} 

	local map = nil

	self.aiSystem = require("src.systems.AI")() 

	self.time = 0

	self.world = tiny.world(
		require ("src.systems.Update")(),
		self.aiSystem, -- it appears that this is why we are here.
		require("src.systems.Atlas")(map, tileMap),
		require("src.systems.Time")(),
		require("src.systems.Spawn")(self)
	)
	-- tile map entities
	for index, layer in ipairs(tileMap.layers) do
		if layer.type == "objects" then
			for _, object in ipairs(layer.objects) do
				local actor = require("src.entities." .. object.type)
				local e = actor(object)
				self.world:add(e)
			end
			tileMap:removeLayer(index)
		end
	end
	-- globals
	_G.world = self.world
end

function Sim:update(dt)
	self.time = self.time + dt
	local resources = love.thread.getChannel( 'resources' ):pop()
	if resources then
		print( inspect.inspect(resources) )
	end
end

return Sim
