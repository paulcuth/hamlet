-- Abstract functions


-- http://www.ecma-international.org/ecma-262/5.1/#sec-9.12
function IsSameValue(a, b)
	-- todo
	return a == b
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-9.11
function IsCallable(val)
	local t = type(val)
	return t == 'function' or (t == 'table' and getmetatable(val) == Function) 
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-9.2
function ToBoolean (val)
	if val == nil or val == undefined or val == null then
		return false
	end

	local t = type(val)

	if t == 'boolean' then
		return val

	elseif t == 'number' then
		return val ~= 0 and val == val--[[not NaN]]

	elseif t == 'string' then
		return val ~= ''
	end

	return true
end





-- http://www.ecma-international.org/ecma-262/5.1/#sec-9.8
function ToString (val)
	if val == nil or val == undefined then
		return 'undefined'

	elseif val == null then
		return 'null'

	elseif val == Object then
		return ToString(ToPrimitive(val, 'string'))
	end

	local t = typeof(val)

	if t == 'string' then
		return val

	elseif t == 'boolean' then
		return val and 'true' or 'false'

	elseif t == 'number' then
		-- http://www.ecma-international.org/ecma-262/5.1/#sec-9.8.1
		if val ~= val then
			return 'NaN'
		elseif val == Infinity then
			return 'Infinity'
		elseif val == -Infinity then
			return '-Infinity'
		else
			return tostring(val)
			-- todo 1.23e4
		end

	elseif t == 'object' or t == 'function' then
		return ToString(ToPrimitive(val, 'string'))
	end

	throw(new(TypeError))
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-9.3
function ToNumber (val)
	if val == nil or val == undefined then
		return NaN

	elseif val == null then
		return 0
	end

	local t = type(val)

	if t == 'number' then
		return val
		
	elseif t == 'boolean' then
		return val and 1 or 0

	elseif t == 'string' then
		-- MASSIVE TODO
		if string.match(val, '^%s?$') then 
			return 0 
		end

		if val == '-0' then
			return -0
		end

		return tonumber(val) or NaN
	end

	return ToNumber(ToPrimitive(val, 'number'))
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-9.9
function ToObject (val)
	if val == nil or val == undefined then
		throw(new(TypeError, 'undefined is not an object'))
	elseif val == null then
		throw(new(TypeError, 'null is not an object'))
	end

	local t = typeof(val)

	if t == 'boolean' then
		return new(Boolean, val)

	elseif t == 'number' then
		return new(Number, val)

	elseif t == 'string' then
		return new(String, val)

	elseif t == 'object' or t == 'function' then
		return val
	end

	throw(new(TypeError))
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-9.1
function ToPrimitive (val, hint)
	if val == nil or val == undefined or val == null then
		return val
	end

	local t = type(val)

	if t == 'boolean' or t == 'number' or t == 'string' then
		return val
	else
		local defaultValue = val.defaultValue

		if defaultValue then 
			return defaultValue(val, hint)
		end
	end

	throw(new(TypeError))
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-8.10.5
function ToPropertyDescriptor (attributes)

	-- 1
	if typeof(attributes) ~= 'object' then
		throw(new(TypeError, 'Property description must be an object: '..ToString(attributes)))
	end

	-- 2
	local value, flags, mask = nil, 0, 0

	-- 3
	local enumberable = attributes:get('enumberable')
	if enumberable ~= undefined then
		mask = mask + 4--[[ENUMERABLE]]

		if ToBoolean(enumberable) then
			flags = flags + 4--[[ENUMERABLE]]
		end
	end

	-- 4
	local configurable = attributes:get('configurable')
	if configurable ~= undefined then
		mask = mask + 8--[[CONFIGURABLE]]

		if ToBoolean(configurable) then
			flags = flags + 8--[[CONFIGURABLE]]
		end
	end

	-- 5
	value = attributes:get('value')

	-- 6
	local writable = attributes:get('writable')
	if writable ~= undefined then
		mask = mask + 2--[[WRITABLE]]

		if ToBoolean(writable) then
			flags = flags + 2--[[WRITABLE]]
		end
	end

	-- 7
	local getter = attributes:get('get')
	if getter ~= undefined and not IsCallable(getter) then
		throw(new(TypeError))
	end

	-- 8
	local setter = attributes:get('set')
	if setter ~= undefined and not IsCallable(setter) then
		throw(new(TypeError))
	end

	-- 9
	if getter ~= undefined or setter ~= undefined then
		if value ~= undefined or writable ~= undefined then
			throw(new(TypeError))
		end

		value = { getter, setter }
	end

	return value, flags, mask
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-9.4
function ToInteger (val)
	-- 1
	val = ToNumber(val)

	-- 2
	if val ~= val--[[NaN]] then
		return 0
	end

	-- 3
	if val == 0 or val == -0 or val == Infinity or val == -Infinity then
		return val
	end

	-- 4
	local abs = math.abs(val)
	return (val / abs) * math.floor(abs)
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-9.5
function ToInt32 (val)
	-- 1
	local number = ToNumber(val)

	-- 2
	if number ~= number--[[NaN]] or number == 0 or number == Infinity or number == -Infinity then
		return 0
	end

	-- 3
	local abs = math.abs(number)
	local posInt = (number / abs) * math.floor(abs)

	-- 4
	local limit = math.pow(2, 32)
	local int32bit = posInt % limit 

	-- 5
	return int32bit >= math.pow(2, 31) and int32bit - limit or int32bit
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-9.6
function ToUint32 (val) 
	-- 1
	val = ToNumber(val)

	-- 2
	if val ~= val--[[NaN]] or val == 0 or val == Infinity or val == -Infinity then
		return 0
	end

	-- 3, 4, 5	
	local abs = math.abs(val)
	return ((val / abs) * math.floor(abs)) % math.pow(2, 32)
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-11.8.5
function RelationalComparison (x, y, leftFirst)
	local px, py

	-- 1
	if leftFirst or leftFirst == nil then
		px = ToPrimitive(x, 'number')
		py = ToPrimitive(y, 'number')
	else
		-- 2
		py = ToPrimitive(y, 'number')
		px = ToPrimitive(x, 'number')
	end

	-- 3
	if typeof(px) ~= 'string' or typeof(py) ~= 'string' then
		-- a, b
		local nx = ToNumber(px)
		local ny = ToNumber(py)

		-- c, d
		if nx ~= nx--[[NaN]] or ny ~= ny--[[NaN]] then
			return undefined
		end

		-- e-l
		return nx < ny
	end

	-- 4a-f
	return px < py
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-9.10
function CheckObjectCoercible (obj)
	if obj == undefined or obj == null or obj == nil then
		throw(new(TypeError))
	end
end





-- Custom


function isPrimitive(val)
	local t = type(val)
	return t ~= 'table' or t == null or t == undefined
end




do
	local limit = math.pow(2, 32) - 1

	function isArrayIndex (index)
		local uint = ToUint32(index)
		return ToString(uint) == index and uint ~= limit
	end
end




-- [[ Internal objects ]]


do
	local ThrowTypeError = Function:new('ThrowTypeError', {}, function ()
		throw(new(TypeError))
	end)

	defineProperty(ThrowTypeError, 'length', 0, 0)
	_G.ThrowTypeError = ThrowTypeError
end








