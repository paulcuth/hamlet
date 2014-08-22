
do
	local Array = Function:new('Array', {}, function (this --[[todo]])	
		-- todo
	end)




	--

	_G.Array = Array
	defineProperty(global, 'Array', Array)

end