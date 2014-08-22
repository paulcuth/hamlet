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
		-- local mt = getmetatable(val)
		-- if mt == Object or mt == Function then
			return ToString(ToPrimitive(val, 'string'))
		-- end
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
		return tonumber(val)
	end

	return ToNumber(ToPrimitive(val, 'number'))
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-9.9
function ToObject (val)
	if val == nil or val == undefined or val == null then
		throw(new(TypeError))
	end

	local t = typeof(val)

	if t == 'boolean' then
		return Boolean:new(val)

	elseif t == 'number' then
		return Number:new(val)

	elseif t == 'string' then
		return String:new(val)

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




function ToPropertyDescriptor (attributes)

	-- 1
	-- TODO needs Type(O)

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






-- Custom
function isPrimitive(val)
	local t = type(val)
	return t ~= 'table' or t == null or t == undefined
end






