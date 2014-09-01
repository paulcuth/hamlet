
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


	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.5.3.2
	defineProperty(String, 'fromCharCode', Function:new('fromCharCode', {}, function (this, ...)
		local args = {...}
		local result = {}

		for i = 1, #args do
			local code = ToUint32(args[i])

			if code > 255 then 
				code = 0
			end

			table.insert(result, code % 256)
		end

		return string.char(unpack(result))
	end))




	--[[ Prototype ]] 


	local prototype = Object:new()

	defineProperty(String, 'prototype', 0, prototype)
	defineProperty(prototype, 'constructor', String)




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.5.5.1
	defineProperty(prototype, 'length', 1, {Function:new('', {}, function (this)
		if typeof(this) ~= 'string' then
			throw(new(TypeError))
		end

		return #this
	end)})




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.5.4.2
	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.5.4.3
	local function toString (self)
		return self.primitiveValue
	end

	defineProperty(prototype, 'toString', Function:new('toString', {}, toString))
	defineProperty(prototype, 'valueOf', Function:new('valueOf', {}, toString))



	
	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.5.4.4
	defineProperty(prototype, 'charAt', Function:new('charAt', { 'pos' }, function (this, pos)
		-- 1
		CheckObjectCoercible(this)

		-- 2
		local s = ToString(this)

		-- 3
		local position = ToInteger(pos)

		-- 4-6
		return string.sub(s, position + 1, 1)
	end))




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.5.4.5
	defineProperty(prototype, 'charCodeAt', Function:new('charCodeAt', { 'pos' }, function (this, pos)
		-- 1
		CheckObjectCoercible(this)

		-- 2
		local s = ToString(this)

		-- 3
		local position = ToInteger(pos)

		-- 4-6
		return string.byte(s, position + 1, 1)
	end))




	--

	_G.String = String
	defineProperty(global, 'String', String)


	local mt = getmetatable('')
	mt.__index = prototype

	mt.__add = function (a, b)
		return a..ToString(b)
	end


end