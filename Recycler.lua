local Recycler = {}
Recycler.__index = Recycler

function Recycler.new(instance)
	local self = setmetatable({}, Recycler)
	
	self._instance = instance:Clone()
	self._storage = {}
	self._total = 0
	
	return self
end

function Recycler:Fetch(parent)
	self._total = self._total + 1
	
	if self._total <= #self._storage then
		return self._storage[self._total]
	else
		local instance = self._instance:Clone()
		instance.Parent = parent
		
		self._storage[self._total] = instance
		
		return instance
	end
end

function Recycler:Update()
	for index = self._total + 1, #self._storage do
		self._storage[index]:Destroy()
		self._storage[index] = nil
	end
	
	self._total = 0
end

function Recycler:Destroy()
	self._instance:Destroy()
	self._instance = nil
	
	for index = 1, #self._storage do
		self._storage[index]:Destroy()
		self._storage[index] = nil
	end
	
	self._total = nil
	
	setmetatable(self, nil)
end

return Recycler