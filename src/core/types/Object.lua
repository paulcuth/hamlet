-----------------------------------------------------------------
-- An ECMAScript Object
--
-- Note that this is not the Object namespace that appears in the
-- global environment. This is the base class of all other objects 
-- the system.
--
-- This file contains the internal properties of the Object class
-- only. This is due to the fact that public methods are ECMAScript
-- Functions, a class which is not yet declared and depends on
-- this here class.
--
-- The public representation of Object can be found in env/Object.lua
--

do
	-- http://www.ecma-international.org/ecma-262/5.1/#sec-8.6
	local Object = {}
	Object.__index = Object




	--[[ Internal properties ]] 


	-- http://www.ecma-international.org/ecma-262/5.1/#sec-8.6.2
	function Object:new (properties)

		local o = {
			prototype = Object_prototype, -- Set in env/Obejct.lua
			class = 'Object',
			extensible = true,
			_properties = {},
			_propertyFlags = {}
		}

		setmetatable(o, self)
		o.__index = o

		if properties ~= nil then
			for k, v in pairs(properties) do
				k = ToString(k)
				o._properties[k] = v
				o._propertyFlags[k] = 14--[[WRITABLE + ENUMBERABLE + CONFIGURABLE]]
			end
		end

		return o
	end



	
	-- http://www.ecma-international.org/ecma-262/5.1/#sec-8.12.1
	function Object:getOwnProperty (propertyName) 
		local band = bit.band
		local flags = self._propertyFlags[propertyName]

		-- 1
		if flags == nil then
			return
		end

		-- 2
		local newFlags = 0

		-- 3
		local value = self._properties[propertyName]

		-- 4
		if band(flags, 1--[[TYPE]]) == 0--[[DATA]] then
			newFlags = 2--[[WRITABLE]]
		end

		-- 5 NOOP

		-- 6, 7
		newFlags = bit.bor(newFlags, band(flags, 12--[[ENUMERABLE + CONFIGURABLE]]))

		-- 8
		return value, flags
	end




	--http://www.ecma-international.org/ecma-262/5.1/#sec-8.12.2
	function Object:getProperty (propertyName)
		-- 1
		local value, flags = self:getOwnProperty(propertyName)	

		-- 2
		if flags ~= nil then
			return value, flags
		end

		-- 3
		local proto = self.prototype

		-- 4
		if proto == nil or proto == undefined or proto == null then
			return
		end

		-- 5
		return proto:getProperty(propertyName)
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-8.12.3
	function Object:get (propertyName) 
		propertyName = ToString(propertyName)
		
		-- 1
		local value, flags = self:getProperty(propertyName)

		-- 2
		if flags == nil then
			return undefined
		end

		-- 3
		if bit.band(flags, 1--[[TYPE]]) == 0--[[DATA]] then
			return value
		end

		-- 4
		local getter = value[1--[[GETTER]]]

		-- 5
		if getter == nil then
			return undefined
		end 

		-- 6
		return getter(self)
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-8.12.4
	function Object:canPut (propertyName) 
		local band = bit.band

		-- 1
		local value, flags = self:getOwnProperty(propertyName)

		-- 2
		if flags ~= nil then
			-- a
			if band(flags, 1--[[TYPE]]) == 1--[[ACCESSOR]] then
				return value[2--[[SETTER]]] ~= nil
			end
			
			-- b
			return band(flags, 2--[[WRITABLE]]) == 2
		end

		-- 3
		local proto = self.prototype

		-- 4
		if proto == nil then
			return self.extensible
		end

		-- 5
		local inheritedValue, inheritedFlags = proto:getProperty(propertyName)

		-- 6
		if inheritedFlags == nil then
			return self.extensible
		end

		-- 7
		if band(inheritedFlags, 1--[[TYPE]]) == 1--[[ACCESSOR]] then
			return inherited[2--[[SETTER]]] ~= nil
		end

		-- 8a
		if not self.extensible then
			return false
		end

		-- 8b
		return band(inheritedFlags, 2--[[WRITABLE]]) == 2
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-8.12.5
	function Object:put (propertyName, newValue, throw)
		propertyName = ToString(propertyName)

		-- 1
		if not self:canPut(propertyName) then
			-- a
			if throw then
				throw(new(TypeError))
			end

			-- b
			return
		end

		local band = bit.band

		-- 2
		local currentValue, currentFlags = self:getOwnProperty(propertyName)

		-- 3
		if currentFlags ~= nil and band(currentFlags, 1--[[TYPE]]) == 0--[[DATA]] then
			-- a, b
			self:defineOwnProperty(propertyName, newValue, 0, 0, throw)

			-- c
			return
		end

		-- No need to lookup property a second time if it was found the first.
		if currentFlags == nil then
			-- 4
			currentValue, currentFlags = self:getProperty(propertyName)
		end

		-- 5
		if currentFlags ~= nil and band(currentFlags, 1--[[TYPE]]) == 1--[[ACCESSOR]] then
			-- a, b
			value[2--[[SETTER]]](self, newValue)

			-- 7
			return
		end

		-- 6
		self:defineOwnProperty(propertyName, newValue, 14, 14, throw)	-- 2--[[WRITABLE]] + 4--[[ENUMERABLE]] + 8--[[CONFIGURABLE]]

		-- 7
		return
	end



		
	-- http://www.ecma-international.org/ecma-262/5.1/#sec-8.12.6
	function Object:hasProperty (propertyName)
		-- 1
		local _, flags = self:getProperty(propertyName)

		-- 2, 3
		return flags ~= nil
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-8.12.7
	function Object:delete (propertyName, throw)
		-- 1
		local _, flags = self:getOwnProperty(propertyName)

		-- 2
		if flags == nil then
			return true
		end

		-- 3
		if bit.band(flags, 8--[[CONFIGURABLE]]) == 8 then
			-- a
			self._properties[propertyName] = nil
			self._propertyFlags[propertyName] = nil

			-- b
			return true
		end

		-- 4
		if throw then
			throw(new(TypeError))
		end

		-- 5
		return false

	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-8.12.8
	function Object:defaultValue (hint)
		if hint == 'string' then
			return self:_defaultValueString()

		elseif hint == 'number' then
			return self:_defaultValueNumber()

		elseif self.class == 'Date' then
			return self:_defaultValueString()
		end	

		return self:_defaultValueNumber()
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-8.12.8
	function Object:_defaultValueString ()
		-- Deal with Object type not being a Function in out implementation
		if self == Object then
			return '[object Object]'
		end

		-- 1
		local toString = self:get 'toString'

		-- 2
		-- if typeof(toString) == 'function' then
		if typeof(toString) == 'function' then
			-- a
			local str = toString(self)

			-- b
			if isPrimitive(str) then
				return str
			end
		end

		-- 3
		local valueOf = self:get 'valueOf'

		-- 4
		if typeof(valueOf) == 'function' then
			-- a
			local val = valueOf(self)

			-- b
			if isPrimitive(val) then
				return val
			end
		end

		-- 5
		throw(new(TypeError, 'Cannot convert object to primitive value'))
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-8.12.8
	function Object:_defaultValueNumber ()
		-- 1
		local valueOf = self:get 'valueOf'

		-- 2
		if typeof(valueOf) == 'function' then
			-- a
			local val = valueOf(self)

			-- b
			if isPrimitive(val) then
				return val
			end
		end

		-- 3
		local toString = self:get 'toString'

		-- 4
		if typeof(toString) == 'function' then
			-- a
			local str = toString(self)

			-- b
			if isPrimitive(str) then
				return str
			end
		end

		-- 5
		throw(new(TypeError, 'Cannot convert object to primitive value'))
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-8.12.9
	function Object:defineOwnProperty (propertyName, newValue, newFlags, newFlagMask, throw)
		local band = bit.band

		-- 1
		local currentValue, currentFlags = self:getOwnProperty(propertyName)

		-- 2 NOOP

		-- 3
		if currentFlags == nil then
			if not self.extensible then
				if throw then
					throw(new(TypeError))
				else
					return false
				end

			elseif band(newFlags, 1--[[TYPE]]) == 0--[[DATA]] or band(newFlagMask, 1--[[TYPE]]) == 0--[[NOT_SET]] then
				-- 4a
				self._properties[propertyName] = newValue
				self._propertyFlags[propertyName] = band(newFlags, 15--[[TYPE + WRITABLE + ENUMBERABLE + CONFIGURABLE]])

			else
				-- 4b
				self._properties[propertyName] = newValue
				self._propertyFlags[propertyName] = band(newFlags, 13--[[TYPE + ENUMBERABLE + CONFIGURABLE]])
			end

			-- 4c
			return true
		end

		-- 5
		if newValue == nil and newFlagMask == 0 then
			return true
		end

		-- 6
		-- mask may need to be used in the first condition
		if currentFlags == newFlags and IsSameValue(currentValue, newValue) then
			return true
		end


		local currentConfigurable = band(currentFlags, 8--[[CONFIGURABLE]])

		-- 7
		if currentConfigurable == 0 then
			-- a, b
			if band(newFlags, 8--[[CONFIGURABLE]]) == 8 or band(currentFlags, 4--[[ENUMERABLE]]) ~= band(newFlags, 4--[[ENUMERABLE]]) then
				if throw then
					throw(new(TypeError))
				else
					return false
				end
			end
		end

		-- 8
		if band(newFlagMask, 1--[[TYPE]]) == 0--[[NOT_SET]] then
			-- NOOP

		else
			local currentType = band(currentFlags, 1--[[TYPE]])

			-- 9
			if currentType ~= band(newFlags, 1--[[TYPE]]) then
				local currentWritable = band(currentFlags, 2--[[WRITABLE]])

				-- a
				if currentConfigurable == 0 then
					if throw then
						throw(new(TypeError))
					else
						return false
					end
				end

				if currentType == 0--[[DATA]] then
					-- b
					self._propertyFlags[propertyName] = band(newFlags, 12) + 1 -- current(8--[[CONFIGURABLE]] + 4--[[ENUMERABLE]]) + 1--[[ACCESSOR]]
				else
					-- c
					self._propertyFlags[propertyName] = band(newFlags, 12)	-- current(8--[[CONFIGURABLE]] + 4--[[ENUMERABLE]]) + 0--[[DATA]]
				end

			elseif currentType == 0--[[DATA]] and band(newFlags, 1--[[TYPE]]) == 0--[[DATA]] then
				-- 10

				-- a
				if currentConfigurable == 0 then
					-- i
					if currentWritable == 0 then
						if band(newFlags, 2--[[WRITABLE]]) == 2 then
							if throw then
								throw(new(TypeError))
							else
								return false
							end
						end

						-- ii
						if newValue ~= nil and not IsSameValue(newValue, currentValue) then
							if throw then
								throw(new(TypeError))
							else
								return false
							end
						end
					end
				end

				-- b NOOP

			elseif currentType == 1--[[ACCESSOR]] and band(newFlags, 1--[[TYPE]]) == 1--[[ACCESSOR]] then
				-- 11

				-- a
				if currentConfigurable == 0 then
					local newSetter = newValue[2--[[SETTER]]]
					local newGetter = newValue[1--[[GETTER]]]

					if (
						-- i
						newSetter ~= nil and not IsSameValue(newSetter, currentValue[2--[[SETTER]]])
					) or (
						-- ii
						newGetter ~= nil and not IsSameValue(newGetter, currentValue[1--[[GETTER]]])
					) then
						if throw then
							throw(new(TypeError))
						else
							return false
						end
					end
				end
			end			
		end

		-- 12
		self._properties[propertyName] = newValue

		-- 13
		return true

	end



	--

	_G.Object = Object

end