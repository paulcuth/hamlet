
do
	local Function = Function:new('Function', {}, function (this --[[todo]])
		-- todo
	end)




	--[[ External properties ]] 


	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.3.3.2
	defineProperty(Function, 'length', 0, 1)




	--[[ Prototype ]] 


	local prototype = Function:new('Empty', {}, function () end)

	defineProperty(Function, 'prototype', 0, prototype)
	defineProperty(prototype, 'constructor', Function)




	--

	defineProperty(global, 'Function', Function)

end
