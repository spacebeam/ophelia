-- bw simulator of all things 

local inspect = require("inspect")

local sti = require("lib.sti.sti")

local Sim = class("Sim")

function Sim:init(path)
	self.path = path
end

function Sim:load()
	local map = sti(self.path)
    local w, h = map.tilewidth * map.width, map.tileheight * map.height

	-- now wut?
	local actions = {} 
	
	self.time = 0
	self.world = tiny.world(

		require ("src.systems.Update")()

		--require ("src.systems.Opening")(),
		--require ("src.systems.Scouting")(),
		--require ("src.systems.Economy")(),
		
	)
	
	-- tile map object layer entities
	for index, layer in ipairs(map.layers) do
		if layer.type == "objects" then
			for _, object in ipairs(layer.objects) do
				local actor = require("src.entities." .. object.type)
				local e = actor(object)
				self.world:add(e)
			end
			map:removeLayer(index)
		end
	end
	
	-- Muda Muda Muda!
	_G.world = self.world
end

function Sim:update(dt)
	self.time = self.time + dt
	local resources = love.thread.getChannel('resources'):pop()
	--if resources then
	--	print(inspect.inspect(resources))
	--end

	local enemy = love.thread.getChannel('enemy'):pop()
	--if enemy then
	--	print(inspect.inspect(enemy))
	--end

end

return Sim
