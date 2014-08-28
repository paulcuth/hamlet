#!/usr/bin/env lua

do
	bit = require 'bit32'




	-- Primatives 

	undefined = setmetatable({}, {
		__index = function (t, key) 
			throw(new(ReferenceError, 'Variable is not defined. Can\'t reference property "'..key..'" of undefined.'))
		end,

		__newindex = function (t, key) 
			throw(new(ReferenceError, 'Variable is not defined. Can\'t set property "'..key..'" of undefined.'))
		end
	})

	null = setmetatable({}, {
		__index = function (t, key) 
			throw(new(TypeError, 'Variable is null. Can\'t reference property "'..key..'" of null.'))
		end,

		__index = function (t, key) 
			throw(new(TypeError, 'Variable is null. Can\'t set property "'..key..'" of null.'))
		end
	})

	NaN = 0/0
	Infinity = 1/0




	-- Globals

	callStack = {}




	-- Logger (Node)
	local function formatValue(val, indent, previous)
		if val == nil or val == undefined then
			return 'undefined'
		elseif val == null then
			return 'null'
		end

		local t = typeof(val)

		if t == 'number' or t == 'boolean' then
			return tostring(val)

		elseif t == 'string' then
			return indent == 1 and val or '"'..val..'"'

		elseif t == 'function' then
			local name = val._name ~= '' and ': '..val._name or ''
			return '[Function'..name..']'

		elseif instanceof(val, Array) then
			return '[ '..val:get('join')(val, ', ')..' ]'

		else
			if val._propertyFlags == nil then
				return '[native object]'
			end

			for _, v in pairs(previous) do
				if v == val then
					return '[Circular]'
				end
			end

			local result = {}
			local prev = {unpack(previous)}
			table.insert(prev, val)

			for key in forIn(val) do
				table.insert(result, string.rep(' ', indent)..key..': '..formatValue(val._properties[key], indent + 1, prev))
			end

			if #result == 0 then
				return '{}'
			end

			return '{\n'..table.concat(result, ',\n')..'\n'..string.rep(' ', indent - 1)..'}'
		end
	end




	function log (...)
		local result = {}

		for _, val in ipairs({...}) do
			table.insert(result, formatValue(val, 1, {}))
		end

		print(table.concat(result, ' '))
	end




	-- Runner
	function execute(func) 
		local env = {
			this = global,
			null = null,

			__hamlet_type_Object = Object,
			__hamlet_type_Function = Function,
			__hamlet_ToObject = ToObject,
			__hamlet_ToNumber = ToNumber,
			__hamlet_ToBoolean = ToBoolean,
			__hamlet_new = new,
			__hamlet_forIn = forIn,
			__hamlet_delete = delete,
			__hamlet_void = void,
			__hamlet_typeof = typeof,
			__hamlet_add = add,
			__hamlet_subtract = subtract,
			__hamlet_binaryIn = binaryIn,
			__hamlet_equal = equal,
			__hamlet_updateOp = updateOp,
			__hamlet_instanceof = instanceof,
			__hamlet_pcall = pcall,
			__hamlet_throw = throw,
			__hamlet_getError = getError,
			__hamlet_getArguments = getCurrentArguments
		}

		setmetatable(env, {
			__index = function (t, key)
				return global:get(key)
			end,

			__newindex = function (t, key, value)
				global:put(key, value)
			end
		})

		setfenv(func, env)

		-- func()
		local success, errId = pcall(func)
		if not success then
			local err = getError(errId)
			if err == nil then
				error(errId)
			end
			error(err:get('toString')(err))
		end
	end




	function defineProperty (object, propertyName, flags, value)
		local defineOwnProperty = Object.defineOwnProperty

		if value == nil then
			value, flags = flags, 10
		end

		-- defineOwnProperty(object, propertyName, value, flags, 14, false)
		object._properties[propertyName] = value
		object._propertyFlags[propertyName] = flags
	end


end