
do
	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.4.1
	local Array = Function:new('Array', {}, function (this, ...)
		return new(Array, ...)
	end)




	--[[ Internal properties ]] 


	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.4.2
	function Array:construct (...)
		local arr = {...}
		local len = table.maxn(arr)
		local obj = Object:new()

		obj.prototype = Array:get('prototype')
		obj.class = 'Array'

		if #arr == 1 then
			-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.4.2.2
			local len = arr[1]

			if typeof(len) == 'number' then
				if len ~= ToUint32(len) then
					throw(new(RangeError))
				end

				obj._properties.length = len
				obj._propertyFlags.length = 2
				return obj
			end
		end

		-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.4.2.1
		obj._properties.length = len
		obj._propertyFlags.length = 2

		for i = 1, len do
			v = arr[i]
			i = tostring(i - 1)
			obj._properties[i] = v
			obj._propertyFlags[i] = 14
		end

		return obj
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.4.5.1
	function Array:defineOwnProperty (propertyName, newValue, newFlags, newFlagMask, _throw)
		local band = bit.band

		-- 1, 2
		local oldLen, oldLenFlags = self:getOwnProperty('length')

		-- 3
		if propertyName == 'length' then
			-- a
			if newValue == nil then
				return Object.defineOwnProperty(self, propertyName, newValue, newFlags, newFlagMask, _throw)
			end

			-- b NOOP

			-- c
			local newLen = ToUint32(newValue)

			-- d
			if newLen ~= ToNumber(newValue) then
				throw(new(RangeError))
			end

			-- e
			newValue = newLen

			-- f
			if newLen >= oldLen then
				Object.defineOwnProperty(self, propertyName, newLen, newFlags, newFlagMask, _throw)
			end

			-- g
			if band(oldLenFlags, 2--[[WRITABLE]]) == 0 then
				if _throw then
					throw(new(TypeError))
				end

				return false
			end

			local newWritable
			local newFlagMaskWritable = band(newFlagMask, 2--[[WRITABLE]]) == 2

			-- h
			if not newFlagMaskWritable or band(newFlags, 2--[[WRITABLE]]) == 2 then
				newWritable = true
			else
				-- i
				newWritable = false

				if not newFlagMaskWritable then
					newFlagMask = newFlagMask + 2--[[WRITABLE]]
				end
			end

			-- j
			local succeeded = Object.defineOwnProperty(self, propertyName, newLen, newFlags, newFlagMask, _throw)

			-- k
			if not succeeded then
				return false
			end

			-- l
			while newLen < oldLen do
				-- i
				oldLen = oldLen - 1

				-- ii
				local deleteSucceeded = self:delete(ToString(oldLen), false)

				-- iii
				if not deleteSucceeded then
					-- 1
					newValue = oldLen + 1

					-- 2
					if not newWritable then
						newFlags = newFlags - band(newFlags, 2--[[WRITABLE]])
					end

					Object.defineOwnProperty(self, 'length', newValue, newFlags, newFlagMask, false)

					if _throw then
						throw(new(TypeError))
					else
						return false
					end
				end
			end

			-- m
			if not newWritable then
				Object.defineOwnProperty(self, 'length', nil, 2, 2, false)
			end

			-- n
			return true
		end

		
		--4
		if isArrayIndex(propertyName) then
			-- a
			local index = ToUint32(propertyName)

			-- b
			if index >= oldLen and band(oldLenFlags, 2--[[WRITABLE]]) == 0 then
				if _throw then
					throw(new(TypeError))
				else
					return false
				end
			end

			-- c
			local succeeded = Object.defineOwnProperty(self, propertyName, newValue, newFlags, newFlagMask, false)

			-- d
			if not succeeded then
				if _throw then
					throw(new(TypeError))
				else
					return false
				end
			end

			-- e
			if index >= oldLen then
				oldLen = index + 1
				Object.defineOwnProperty(self, length, oldLen, oldLenFlags, 14, false)
			end

			-- f
			return true
		end

		-- 5
		return Object.defineOwnProperty(self, propertyName, newValue, newFlags, newFlagMask, _throw)
	end




	--[[ External properties ]] 


	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.4.3.2
	defineProperty(Array, 'isArray', Function:new('isArray', { 'arg' }, function (this, arg)
		-- 1
		if typeof(arg) ~= 'object' then
			return false
		end

		-- 2
		if arg.class == 'Array' then
			return true
		end

		-- 3
		return false
	end))




	--[[ Prototype ]] 


	local prototype = Object:new()

	defineProperty(Array, 'prototype', 0, prototype)
	defineProperty(prototype, 'constructor', Array)




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.4.4.2
	defineProperty(prototype, 'toString', Function:new('toString', {}, function (this)
		-- 1
		local arr = ToObject(this)

		-- 2
		local func = this:get('join')

		-- 3
		if not IsCallable(func) then
			func = Object_prototype_toString
		end

		-- 4
		return func(this)
	end))




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.4.4.5
	defineProperty(prototype, 'join', Function:new('join', { 'separator' }, function (this, separator)
		-- 1
		local arr = ToObject(this)

		-- 2, 3
		local len = ToUint32(this:get('length'))

		-- 6
		if len == 0 then
			return ''
		end

		-- 4
		if separator == nil or separator == undefined then
			separator = ','
		else
			-- 5
			separator = ToString(separator)
		end

		-- 7, 8, 9, 10
		local r = {}

		for i = 1, len do
			local item = this:get(tostring(i - 1))

			if item == undefined or item == null or item == nil then
				item = ''
			else
				item = ToString(item)
			end

			table.insert(r, item)
		end

		-- 11
		return table.concat(r, separator)
	end))




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.4.4.7
	defineProperty(prototype, 'push', Function:new('push', {}, function (this, ...)
		-- 1
		local arr = ToObject(this)

		-- 2, 3
		local len = ToUint32(this:get('length'))

		-- 4
		local items = {...}

		-- 5
		for i, v in ipairs(items) do
			arr:put(tostring(len + i - 1), v, true)
		end

		-- 6
		local newLength = len + #items
		arr:put('length', newLength, true)

		-- 7
		return newLength
	end))




	--

	_G.Array = Array
	defineProperty(global, 'Array', Array)

end