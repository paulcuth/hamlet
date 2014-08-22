
do
	local Math = Object:new()




	--[[ External properties ]] 

	-- Properties

	defineProperty(Math, 'E', 0, math.exp(1))




	-- Methods
	
	defineProperty(Math, 'floor', Function:new('floor', { 'num' }, function (this, num)
		return math.floor(num)
	end))




	--

	defineProperty(global, 'Math', Math)

end
