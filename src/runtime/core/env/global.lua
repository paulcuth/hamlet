
do
	global = Object:new()




	--[[ External properties ]] 


	defineProperty(global, 'global', 14, global)
	defineProperty(global, 'undefined', 0, undefined)
	defineProperty(global, 'NaN', 0, NaN)
	defineProperty(global, 'Infinity', 0, Infinity)


	defineProperty(global, 'isNaN', Function:new('isNaN', { 'val' }, function (this, val)
		return val ~= val--[[NaN]]
	end))


end
