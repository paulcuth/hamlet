
do

	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.11.6.5
	local TypeError = Error:new('TypeError', { 'message' }, function (this, message) 
	end)




	--[[ Prototype ]]

	local prototype = new(Error)
	
	defineProperty(TypeError, 'prototype', 0, prototype)
	defineProperty(prototype, 'constructor', TypeError)




	defineProperty(prototype, 'name', 'TypeError')



	--

	_G.TypeError = TypeError
	defineProperty(global, 'TypeError', TypeError)

end
