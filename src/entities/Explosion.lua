local Explosion = class "Explosion"

function Explosion:init(x, y)
	self.pos = {x = x, y = y}
	self.bg = true
	self.lifetime = 9 * 0.05
end

return Explosion
