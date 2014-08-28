


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




-- http://www.ecma-international.org/ecma-262/5.1/#sec-11.9.3
function equal (x, y) 
	local typeX, typeY = typeof(x), typeof(y)

	-- 1
	if typeX == typeY then
		if x == undefined then
			-- a
			return true

		elseif x == null and y == null then
			-- b
			return true

		elseif typeX == 'number' then
			-- c
			if x ~= x or y ~= y then
				-- i, ii
				return false
			end

			-- iii, iv, v, vi
			return x == y
		end

		-- d, e, f
		return x == y
	end

	-- 2, 3
	if (x == null and y == undefined) or (x == undefined and y == null) then
		return true
	end

	-- 4
	if typeX == 'number' and typeY == 'string' then
		return equal(x, ToNumber(y))
	end

	-- 5
	if typeX == 'string' and typeY == 'number' then
		return equal(ToNumber(x), y)
	end

	-- 6
	if typeX == 'boolean' then
		return equal(ToNumber(x), y)
	end

	-- 7
	if typeY == 'boolean' then
		return equal(x, ToNumber(y))
	end

	-- 8
	if (typeX == 'string' or typeX == 'number') and typeY == 'object' and y ~= null then
		return equal(x, ToPrimitive(y))
	end

	-- 9
	if typeX == 'object' and typeX ~= null and (typeY == 'string' or y == 'number') then
		return equal(ToPrimitive(x), y)
	end

	-- 10
	return false
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
	if obj then
		return ToObject(obj):delete(propertyName)
	end

	-- If the subject of the delete operator is an identifier
	-- and the identifier does not refer a var in the scope
	-- chain, operate on global scope, otherwise return false.

	-- TODO: Review the following for a faster solution.

	local index = 1
	repeat
		local varName = debug.getlocal(2, index)

		if varName == propertyName then
			-- Identifier refers to local
			debug.setlocal(2, index, nil)
			return true
		end

		index = index + 1
	until varName == nil

	local func = callStack[1]
	if func ~= nil then
		repeat
			local varName = debug.getupvalue(func, index)

			if varName == propertyName then
				-- Identifier refers to upvalue
				debug.setupvalue(func, index, nil)
				return true
			end

			index = index + 1
		until varName == nil
	end

	return global:delete(propertyName)
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