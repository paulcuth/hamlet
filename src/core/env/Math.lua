
do
	local Math = Object:new()




	--[[ External properties ]] 

	-- Properties

	defineProperty(Math, 'E', 0, math.exp(1))
	defineProperty(Math, 'MAX_VALUE', 0, 1.7976931348623157e308)
	defineProperty(Math, 'MIN_VALUE', 0, 5e-324)




	-- Methods

	defineProperty(Math, 'floor', Function:new('floor', { 'num' }, function (this, num)
		return math.floor(num)
	end))




	defineProperty(Math, 'pow', Function:new('pow', { 'x', 'y' }, function (this, x, y)		
		return math.pow(x, y)
	end))




	--

	defineProperty(global, 'Math', Math)

end
