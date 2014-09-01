
do
	local Number = Function:new('Number', {}, function (this, val)
		if val == nil then
			return 0
		end

		return ToNumber(val)
	end)




	--[[ Internal properties ]] 


	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.7.2
	function Number:construct (value)
		local obj = Object:new()

		obj.prototype = Number:get('prototype')
		obj.class = 'Number'
		obj.primitiveValue = (value == nil and 0) or ToNumber(value)

		return obj
	end




	--[[ External properties ]] 


	defineProperty(Number, 'MAX_VALUE', 0, 1.7976931348623157e308)
	defineProperty(Number, 'MIN_VALUE', 0, 5e-324)
	defineProperty(Number, 'NaN', 0, NaN)
	defineProperty(Number, 'NEGATIVE_INFINITY', 0, -1/0)
	defineProperty(Number, 'POSITIVE_INFINITY', 0, 1/0)




	--[[ Prototype ]] 


	local prototype = Object:new()

	defineProperty(Number, 'prototype', 0, prototype)
	defineProperty(prototype, 'constructor', Number)




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.7.4.2
	defineProperty(prototype, 'toString', Function:new('toString', { 'radix' }, function (this, radix)
		if radix == nil then
			radix = 10
		else 
			radix = ToInteger(radix)

			if radix < 2 or radix > 36 then
				throw(new(RangeError, 'toString() radix argument must be between 2 and 36'))
			end
		end

		if radix == 10 then
			return ToString(this.primitiveValue)
		end

		return tonumber(ToNumber(this), radix)
	end))




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.6.4.2
	defineProperty(prototype, 'valueOf', Function:new('valueOf', {}, function (this)
		if this.class ~= 'Number' then
			throw(new(TypeError, 'Number.prototype.valueOf is not generic'))
		end

		return this.primitiveValue
	end))




	-- todo



	--
	_G.Number = Number
	defineProperty(global, 'Number', Number)

end
