
do
	local console = Object:new()
	



	--[[ External properties ]] 

	defineProperty(console, 'log', 14, Function:new('log', {}, function (this, ...)
		log(...)
	end))




	-- 

	defineProperty(global, 'console', 13, { Function:new('', {}, function ()
		return console;
	end) })

end

