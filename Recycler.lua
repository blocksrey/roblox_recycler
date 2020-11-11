local Recycler = {}
Recycler.__index = Recycler

function Recycler.new(instance)
	local self = {}
	
	self.instance = instance:Clone()
	self.storage  = {}
	self.total    = 0
	
	return setmetatable(self, Recycler)
end

function Recycler:fetch(parent)
	self.total = self.total + 1
	
	if self.total <= #self.storage then
		return self.storage[self.total]
	else
		local instance = self.instance:Clone()
		instance.Parent = parent
		
		self.storage[self.total] = instance
		
		return instance
	end
end

function Recycler:update()
	for index = self.total + 1, #self.storage do
		self.storage[index]:Destroy()
	end
	
	self.total = 0
end

return Recycler