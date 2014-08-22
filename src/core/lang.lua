
-- Operators

getmetatable('').__add = function (a, b)
	return a..ToString(b)
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-11.2.2
function new (constructor, ...)
	-- 1, 2, NOOP

	-- 3, 4
	local t = typeof(constructor)
	if (t ~= 'object' and t ~= 'function') or constructor.construct == nil then
		throw(new(TypeError))
	end

	-- 5
	return constructor:construct(...)
end




function equal (a, b) 
	return a == b		--todo!!!!
end




function binaryIn (propertyName, object)
	if typeof(object) ~= 'object' then
		return false
	end

	propertyName = ToString(propertyName)
	local _, flags = object:getProperty(propertyName)

	return flags ~= nil
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-11.3.1
function updateOp (object, property, opFunc, isPrefix)
	-- 1, 2 NOOP Hmmm

	-- 3
	local oldValue

	if object then
		oldValue = ToNumber(object:get(property))
		newValue = opFunc(oldValue, 1)
		object:put(property, newValue)
	else
		oldValue = ToNumber(property)
		newValue = opFunc(oldValue, 1)
	end

	return isPrefix and newValue or oldValue, newValue
end





function forIn (obj)
	local keys = {}

	for k, v in pairs(ToObject(obj)._propertyFlags) do
		if bit.band(v, 4--[[ENUMERABLE]]) == 4 then
			table.insert(keys, k)
		end
	end

	return function () 
		return table.remove(keys, 1)
	end
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-11.4.3
function typeof (val)
	-- 1, 2 NOOP

	-- 3
	if val == nil or val == undefined then
		return 'undefined'

	elseif val == null then
		return 'object'

	else
		local t = type(val)

		if t == 'boolean' or t == 'number' or t == 'string' then
			return t

		elseif getmetatable(val) == Function then
			return 'function'

		else
			return 'object' --?
		end
	end
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-11.4.2
function void (val)
	-- 1, 2 NOOP, Handled by Lua

	-- 3
	return undefined
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-11.4.1
function delete (obj, propertyName)
	-- 1, 2, 3, 5 NOOP

	-- 4
	return ToObject(obj):delete(propertyName)
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-11.6.1
function add (left, right)
	left = ToPrimitive(left)
	right = ToPrimitive(right)

	if type(left) == 'string' then
		return left..ToString(right)

	elseif type(right) == 'string' then
		return ToString(left)..right
	end

	return ToNumber(left) + ToNumber(right)
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-11.6.2
function subtract (left, right)
	local left, right = ToPrimitive(l), ToPrimitive(r)
	return ToNumber(left) - ToNumber(right)
end




-- http://www.ecma-international.org/ecma-262/5.1/#sec-11.8.6
function instanceof (left, right)
	-- 1, 2, 3, 4 NOOP

	-- 5
	local t = typeof(right)
	if t ~= 'object' and t ~= 'function' then
		throw(new(TypeError))
	end

	-- 6
	local hasInstance = right.hasInstance
	if hasInstance == nil then
		throw(new(TypeError, 'Expecting a function in instanceof check, but got #<' + right.class + '>'))
	end

	-- 7
	return hasInstance(right, left)	
end




do
	local errors = setmetatable({}, { __mode = 'v' })

	function throw (err) 
		collectgarbage()

		local id = err:get('name')..':'..err:get('message')..':'..tostring(os.clock() * 1000000)
		errors[id] = err

		error(id, 2)
	end

	function getError (id)
		local _, _, debug, match = string.find(id, '(.*): (%a+:.*:%d+)$')
		local err = errors[match]

		err:put('message', err:get('message')..'\n\ton line '..debug)
		return err
	end
end