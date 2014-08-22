
do
	local Date = Function:new('Date', {--[[todo]]}, function (this)
		--todo
	end)




	--[[ External properties ]] 


	defineProperty(Date, 'now', Function:new('now', {}, function (this)
		return os.clock() * 1000
	end))




	--[[ Prototype ]] 
	-- todo 




	--

	defineProperty(global, 'Date', Date)	

end
