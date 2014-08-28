
do
	local String = Function:new('String', {}, function (this, val)
		if val == nil then
			return ''
		end

		return ToString(val)
	end)




	--[[ Internal properties ]] 


	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.5.2.1
	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.5.5
	function String:construct (val)
		val = val and ToString(val) or ''

		local len = #val
		local obj = Object:new()

		obj.prototype = String:get('prototype')
		obj.class = 'String'
		obj.primitiveValue = val

		obj._properties['length'] = len
		obj._propertyFlags['length'] = 0

		-- TODO? Should the following be defined by a custom [[GetOwnProperty]] method
		-- as described in http://www.ecma-international.org/ecma-262/5.1/#sec-15.5.5 ?
		for i = 1, len do
			local key = tostring(i - 1)
			obj._properties[key] = string.sub(val, i, i)
			obj._propertyFlags[key] = 4
		end

		return obj
	end




	--[[ External properties ]] 


	defineProperty(String, 'fromCharCode', Function:new('fromCharCode', {}, function (...)
		local args = {...}
		local len = #args

		-- todo
	end))




	--[[ Prototype ]] 


	local prototype = Object:new()

	defineProperty(String, 'prototype', 0, prototype)
	defineProperty(prototype, 'constructor', String)




	defineProperty(prototype, 'length', 1, {Function:new('', {}, function (this)
		if typeof(this) ~= 'string' then
			throw(new(TypeError))
		end

		return #this
	end)})




	local function toString (self)
		return self.primitiveValue
	end

	defineProperty(prototype, 'toString', Function:new('toString', {}, toString))
	defineProperty(prototype, 'valueOf', Function:new('valueOf', {}, toString))
	



	--

	defineProperty(global, 'String', String)


	local mt = getmetatable('')
	mt.__index = prototype

	mt.__add = function (a, b)
		return a..ToString(b)
	end

end