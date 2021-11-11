
local inspect = require("inspect")
-- 
local sti = require("lib.sti.sti")

local TimerEvent = require("src.entities.TimerEvent")

local Sim = class("Sim")

function Sim:init(mappath)
	self.mappath = mappath
end

-- Data-Oriented Design Paradigm (?)
-- No hierarchy to remember
-- Systems have many of the advantages of microservices
-- Systems have many of the advantages of functional programming (?)

function Sim:load()

	-- tile map setup
	local tileMap = sti(self.mappath)
    local w, h = tileMap.tilewidth * tileMap.width, tileMap.tileheight * tileMap.height

	-- cool it aopears that we have bw integration but...

	-- still we are in the process of assimilation and acomodation (?)
	
	local resources = love.thread.getChannel('resources'):pop()

	local actions = {} 

	local map = nil

	self.aiSystem = require("src.systems.AISystem")()

	self.time = 0

	self.world = tiny.world(
		require ("src.systems.UpdateSystem")(),
		self.aiSystem, -- it appears that this is why we are here.
		require("src.systems.AtlasSystem")(map, tileMap),
		require("src.systems.TimingSystem")(),
		require("src.systems.SpawnSystem")(self)
	)

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
