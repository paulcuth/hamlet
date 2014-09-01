
do
	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.10.3.1
	local RegExp = Function:new('RegExp', {}, function (this, pattern, flags)
		if flags == nil and typeof(pattern) == 'object' and pattern.class == 'RegExp' then
			return pattern
		end

		return new(RegExp, pattern, flags)
	end)




	--[[ Internal properties ]] 


	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.10.4.1
	function RegExp:construct (pattern, flags)
		local obj = Object:new()

		obj.prototype = RegExp:get('prototype')
		obj.class = 'RegExp'
		obj.primitiveValue = '' -- TODO

		-- TODO

		return obj
	end




	--[[ Prototype ]] 


	local prototype = Object:new()

	defineProperty(RegExp, 'prototype', 0, prototype)
	defineProperty(prototype, 'constructor', RegExp)




	-- defineProperty(prototype, 'toString', Function:new('toString', {}, function (this)

	-- 	-- TODO

	-- end))




	--

	defineProperty(global, 'RegExp', RegExp)

end