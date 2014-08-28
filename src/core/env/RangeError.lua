
do

	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.11.6.5
	local RangeError = Error:new('RangeError', { 'message' }, function (this, message) 
	end)




	--[[ Prototype ]]

	local prototype = new(Error)
	
	defineProperty(RangeError, 'prototype', 0, prototype)
	defineProperty(prototype, 'constructor', RangeError)




	defineProperty(prototype, 'name', 'RangeError')



	--

	_G.RangeError = RangeError
	defineProperty(global, 'RangeError', RangeError)

end
