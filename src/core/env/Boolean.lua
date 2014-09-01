
do
	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.6.1
	local Boolean = Function:new('Boolean', { 'value' }, function (this, value)
		return ToBoolean(value)
	end)




	--[[ Internal properties ]] 


	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.6.2
	function Boolean:construct (value)
		local obj = Object:new()

		obj.prototype = Boolean:get('prototype')
		obj.class = 'Boolean'
		obj.primitiveValue = ToBoolean(value)

		return obj
	end




	--[[ Prototype ]] 


	local prototype = Object:new()

	defineProperty(Boolean, 'prototype', 0, prototype)
	defineProperty(prototype, 'constructor', Boolean)




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.6.4.2
	defineProperty(prototype, 'toString', Function:new('toString', {}, function (this)
		-- 1 NOOP

		-- 2
		local t = typeof(this)
		local b

		if t == 'boolean' then
			b = this

		elseif t == 'object' and this.class == 'Boolean' then
			-- 3
			b = this.primitiveValue

		else
			-- 4
			throw(new(TypeError, 'Boolean.prototype.toString is not generic'))
		end

		-- 5
		return b and 'true' or 'false'
	end))




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.6.4.3
	defineProperty(prototype, 'valueOf', Function:new('valueOf', {}, function (this)
		-- 1 NOOP

		-- 2
		local t = typeof(this)
		local b

		if t == 'boolean' then
			b = this

		elseif t == 'object' and this.class == 'Boolean' then
			-- 3
			b = this.primitiveValue

		else
			-- 4
			throw(new(TypeError, 'Boolean.prototype.valueOf is not generic'))
		end

		-- 5
		return b
	end))




	--

	_G.Boolean = Boolean
	defineProperty(global, 'Boolean', Boolean)

end

