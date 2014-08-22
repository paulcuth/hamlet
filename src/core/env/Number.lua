
do
	local Number = Function:new('Number', {}, function (this, val)
		if val == nil then
			return ''
		end

		return ToNumber(val)
	end)



	--[[ External properties ]] 


	defineProperty(Number, 'NaN', 0, NaN)




	--[[ Prototype ]] 


	local prototype = Object:new()

	-- todo



	--

	defineProperty(global, 'Number', Number)

end
