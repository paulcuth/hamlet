
do
	local Number = Function:new('Number', {}, function (this, val)
		if val == nil then
			return ''
		end

		return ToNumber(val)
	end)



	--[[ External properties ]] 


	defineProperty(Number, 'NaN', 0, NaN)
	defineProperty(Number, 'POSITIVE_INFINITY', 0, 1/0)
	defineProperty(Number, 'NEGATIVE_INFINITY', 0, -1/0)




	--[[ Prototype ]] 


	local prototype = Object:new()

	-- todo



	--

	defineProperty(global, 'Number', Number)

end
