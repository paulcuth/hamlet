
do
	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.11.1.1
	local Error = Function:new('Error', { 'message' }, function (this, message)
		return self:construct(message)
	end)




	--[[ Internal properties ]] 


	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.11.2.1
	function Error:construct (message)
		local obj = Object:new()

		obj.prototype = self:get('prototype')
		obj.class = 'Error'

		if message ~= nil then
			obj._properties['message'] = ToString(message)
			obj._propertyFlags['message'] = 10
		end

		return obj
	end




	--[[ External properties ]] 


	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.11.3
	defineProperty(Error, 'length', 0, 1)





	--[[ Prototype ]] 


	local prototype = Object:new()	

	defineProperty(Error, 'prototype', 0, prototype)
	defineProperty(prototype, 'constructor', Error)




	defineProperty(prototype, 'name', 'Error')
	defineProperty(prototype, 'message', '')




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.11.4.4
	defineProperty(prototype, 'toString', Function:new('toString', {}, function (this)
		-- 1, 2
		local t = typeof(this)
		if t ~= 'object' and t ~= 'function' then
			throw(new(TypeError, 'Error.prototype.toString called on non-object'))
		end

		-- 3
		local name = this:get('name')

		-- 4
		if name == undefined then
			name = 'Error'
		else
			name = ToString(name)
		end

		-- 5
		local message = this:get('message')

		-- 6 (7)
		if message == undefined then
			message = ''
		else
			message = ToString(message)
		end

		-- 8
		if name == '' then
			return message
		end

		-- 9
		if message == '' then
			return name
		end

		-- 10
		return name..': '..message
	end))




	-- 

	_G.Error = Error
	defineProperty(global, 'Error', Error)

end