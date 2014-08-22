-----------------------------------------------------------------
-- An ECMAScript Function
--
--
--

do
	-- http://www.ecma-international.org/ecma-262/5.1/#sec-13
	local Function = Object:new()




	-- Make Function objects invokable
	Function.__call = function (t, ...)
		return t:call(...)
	end




	--[[ Internal properties ]] 


	-- http://www.ecma-international.org/ecma-262/5.1/#sec-13.2
	function Function:new (name, params, strict, def)

		if type(strict) == 'function' then
			def = strict
			strict = false
		end

		-- TODO Improve this:
		local functionNamespace
		local functionPrototype

		if global ~= nil and global.get then
			functionNamespace = global:get('Function')

			if functionNamespace ~= nil and functionNamespace.get then
				functionPrototype = functionNamespace:get('prototype')
			end
		end
		---

		local f = {
			class = 'Function',						-- 3
			prototype = functionPrototype or null,	-- 4
			formalParameters = params, 				-- 10, 11
			code = def,								-- 12
			extensible = true,						-- 13
			_name = name,
			_properties = {},
			_propertyFlags = {}
		}


		-- 1, 2, 5, 6, 7, 8
		setmetatable(f, self)
		f.__index = f

		-- 9 NOOP

		-- 14, 15
		f:defineOwnProperty('length', #params, 0, 14, false)
		f:defineOwnProperty('name', name, 0, 14, false)

		-- 16
		local proto = Object:new()

		-- 17
		proto:defineOwnProperty('constructor', f, 10, 14, false)

		-- 18
		f:defineOwnProperty('prototype', proto, 2, 14, false)

		-- 19
		if strict then
			-- a
			local thrower = ThrowTypeError
			local value = { thrower, thrower }

			-- b
			f:defineOwnProperty('caller', value, 0, 12, false)

			-- c
			f:defineOwnProperty('arguments', value, 0, 12, false)
		end

		-- 20
		return f
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.3.5.4
	function Function:get (propertyName)
		if propertyName == 'caller' then
			-- 1
			local v = Object.get(self, propertyName)

			-- 2
			if v.strict then
				throw(new(TypeError))
			end

			-- 3
			return v

		else
			-- 3 (tail call)
			return Object.get(self, propertyName)
		end
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-13.2.1
	function Function:call (...)
		-- 1, 3, 4 NOOP Handled by Lua

		-- 2
		local def = self.code
		if type(def) ~= 'function' then
			return
		end

		-- 5, 6
		return def(...)
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-13.2.2
	function Function:construct (...)
		-- 1, 2, 3, 4
		local obj = Object:new()

		-- 5
		local proto = self:get('prototype')

		if typeof(proto) == 'object' then
			-- 6
			obj.prototype = proto
		else
			-- 7
			obj.prototype = Object.prototype
		end

		-- 8
		local result = self:call(obj, ...)

		-- 9
		if typeof(result) == 'object' then
			return result
		end

		-- 10
		return obj
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.3.5.3
	function Function:hasInstance (val)
		
		-- 1
		local t = typeof(val)
		if t ~= 'object' and t ~= 'function' then
			return false
		end

		-- 2
		local o = self:get('prototype')

		-- 3
		local t = typeof(o)
		if t ~= 'object' and t ~= 'function' then
			throw(new(TypeError))
		end

		-- 4
		repeat
			val = val.prototype

			if val == nil or val == undefined or val == null then
				return false
			end

			if o == val then
				return true
			end
		until false		-- TODO: Possible endless loop if two objects refer to each other as prototypes
	end




	-- 

	_G.Function = Function

end
