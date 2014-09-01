-----------------------------------------------------------------
-- The Object namespace
--
-- Note that this is not the Object type, but the Object namespace 
-- that appears in the global environment.
--
-- The internal properties of Object can be found in type/Object.lua
--

do
	local ObjectType = Object 	-- Reference to the existing internal type



	local Object = Function:new('Object', {}, function (this, val)
		if val == nil or val == undefined or val == null then
			return ObjectType:new()
		end

		return ToObject(val)
	end)




	--[[ External properties ]]


	defineProperty(Object, 'length', 0, 1)




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.2.3.6
	defineProperty(Object, 'defineProperty', Function:new('defineProperty', { 'object', 'propertyName', 'attributes' }, function (this, object, propertyName, attributes) 
		-- 1
		if typeof(object) ~= 'object' then
			throw(new(TypeError))
		end

		-- 2
		local name = ToString(propertyName)

		-- 3
		local value, flags, mask = ToPropertyDescriptor(attributes)

		-- 4
		object:defineOwnProperty(name, value, flags, mask, true)

		-- 5
		return object
	end))


	-- TODO: lots of methods here!






	--[[ Prototype ]]


	local prototype = ObjectType:new()
	
	defineProperty(Object, 'prototype', 0, prototype)
	defineProperty(prototype, 'constructor', Object)




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.2.4.2
	local toString = Function:new('toString', {}, function (this) 

		-- 1
		if this == nil or this == undefined then
			return '[object Undefined]'

		-- 2
		elseif this == null then
			return '[object Null]'
		end

		-- 3, 4
		local class = ToObject(this).class

		-- 5
		return '[object ' + class + ']'
	end)

	defineProperty(prototype, 'toString', toString)




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.2.4.3
	defineProperty(prototype, 'toLocaleString', Function:new('toLocaleString', {}, function (this) 

		-- 1
		local o = ToObject(this)

		-- 2 
		local toString = o:get('toString')

		-- 3
		if not IsCallable(toString) then
			throw(new(TypeError))
		end

		-- 4
		return toString(this)
	end))




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.2.4.4
	defineProperty(prototype, 'valueOf', Function:new('valueOf', {}, function (this) 
		-- 2 NOOP

		-- 1, 3
		return ToObject(this)
	end))




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.2.4.4
	defineProperty(prototype, 'hasOwnProperty', Function:new('hasOwnProperty', { 'propertyName' }, function (this, propertyName) 
		-- 1
		local name = ToString(propertyName)

		-- 2
		local object = ToObject(this)

		-- 3
		local desc = object:getOwnProperty(name)

		-- 4, 5
		return desc ~= nil
	end))




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.2.4.4
	defineProperty(prototype, 'isPrototypeOf', Function:new('isPrototypeOf', { 'value' }, function (this, value) 
		-- 1
		if typeof(value) ~= 'object' then
			return false
		end

		-- 2
		local object = ToObject(this)

		-- 3
		repeat
			-- a
			value = value.prototype

			-- b
			if value == nil or value == undefined or value == null then 
				return false
			end

			-- c
			if value == object then
				return true
			end

		until false

	end))




	-- 

	global.Object = Object 						-- Internal
	defineProperty(global, 'Object', Object) 	-- External

	Object_prototype = prototype 				-- For ease of reference in ObjectType:new
	Object_prototype_toString = toString
end


