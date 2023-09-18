-- Do not break the laws of physics!

local inspect = require("inspect")
local sti = require("lib.sti.sti")
local Game = class("Game")

function Game:init(path)
	self.path = path
end

function Game:load()
	local map = sti(self.path)
    local w, h = map.tilewidth * map.width, map.tileheight * map.height	
	-- the enchiridion!
	local actions = {} 
	self.time = 0
	self.world = tiny.world(
		require("src.systems.Maps"),
		require("src.systems.Mining")(),
		require("src.systems.Opening")(),
		require("src.systems.Scouting")(),
		require("src.systems.Economy")(),
		require("src.systems.Update")()
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
	_G.world = self.world
end

function Game:update(dt)
	self.time = self.time + dt
	
	local resources = love.thread.getChannel('resources'):pop()
	--if resources then
	--	print(inspect.inspect(resources))
	--end

	local enemy = love.thread.getChannel('enemy'):pop()
	--if enemy then
	--	print(inspect.inspect(enemy))
	--end

	--print(seconds)
end

return Game
