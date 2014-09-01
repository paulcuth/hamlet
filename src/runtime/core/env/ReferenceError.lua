
do

	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.11.6.3
	local ReferenceError = Error:new('ReferenceError', { 'message' }, function (this, message) 
	end)




	--[[ Prototype ]]

	local prototype = new(Error)
	
	defineProperty(ReferenceError, 'prototype', 0, prototype)
	defineProperty(prototype, 'constructor', ReferenceError)




	defineProperty(prototype, 'name', 'ReferenceError')



	--

	_G.ReferenceError = ReferenceError
	defineProperty(global, 'ReferenceError', ReferenceError)

end
