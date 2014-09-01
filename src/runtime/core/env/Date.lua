
do
	local Date = Function:new('Date', {--[[todo]]}, function (this)
		return new(Date).toString()
	end)




	--[[ Helper functions ]] 


	-- do
	-- 	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.9.1.10
	-- 	local hoursPerDay = 24
	-- 	local minutesPerHour = 60
	-- 	local secondsPerMinute = 60
	-- 	local msPerSecond = 1000
	-- 	local msPerMinute = 60000
	-- 	local msPerHour = 3600000
	-- 	local msPerDay = 86400000



	-- 	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.9.1.11
	-- 	function MakeTime (hour, min, sec, ms)
	-- 		-- 1
	-- 		if 
	-- 			hour == Infinity or hour == -Infinity
	-- 			or min == Infinity or min == -Infinity
	-- 			or sec == Infinity or sec == -Infinity
	-- 			or ms == Infinity or ms == -Infinity
	-- 		then
	-- 			return NaN
	-- 		end

	-- 		-- 2-5
	-- 		local h, m, s, milli = ToInteger(hour), ToInteger(min), ToInteger(sec), ToInteger(ms)

	-- 		-- 6
	-- 		local t = h * msPerHour + m * msPerMinute + s * msPerSecond + milli

	-- 		-- 7
	-- 		return t
	-- 	end




	-- 	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.9.1.12
	-- 	function MakeDay (year, month, date)
	-- 		-- 1
	-- 		if 
	-- 			year == Infinity or year == -Infinity
	-- 			or month == Infinity or month == -Infinity
	-- 			or date == Infinity or date == -Infinity
	-- 		then
	-- 			return NaN
	-- 		end

	-- 		-- 2-4
	-- 		local y, m, dt = ToInteger(year), ToInteger(month), ToInteger(date)

	-- 		-- 5
	-- 		local ym = y + math.floor(m / 12)

	-- 		-- 6
	-- 		local mn = m % 12

			



	--[[ Internal properties ]] 


	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.9.3.2
	local function constructWithValue (value)
		-- 1
		local v = ToPrimitive(value)

		-- 2
		if typeof(v) == 'string' then
			-- 2a, 4
			return Date_parse(Date, v)
		end

		if v ~= v--[[NaN]] or v == Infinity or v == -Infinity then
			return NaN
		end

		-- 3, 4
		return ToInteger(v)
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.9.3.1
	local function constructWithFullDate (year, month, date, hours, minutes, seconds, ms)
		-- 1
		local y = ToNumber(year)

		-- 2
		local m = ToNumber(month)

		-- 3
		local dt = date ~= nil and ToNumber(date) or 1

		-- 4
		local h = hours ~= nil and ToNumber(hours) or 0

		-- 5
		local min = minutes ~= nil and ToNumber(minutes) or 0

		-- 6
		local s = seconds ~= nil and ToNumber(seconds) or 0

		-- 7
		local milli = ms ~= nil and ToNumber(ms) or 0

		-- 8
		local intY = ToInteger(y)
		local yr

		if y == y--[[not NaN]] and intY >= 0 and intY <= 99 then
			yr = 1900 + intY
		else
			yr = y
		end

		-- 9
		local t = {
			year = y,
			month = m,
			day = dt,
			hour = h,
			min = min,
			sec = s
		}

		local finalDate = os.time(t)

		-- 10
		return finalDate ~= nil and finalDate + milli or NaN --TimeClip(UTC(finalDate))
	end




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.9.3
	function Date:construct (...)
		local obj = Object:new()

		obj.prototype = Date:get('prototype')
		obj.class = 'Date'

		local argCount = #{...}

		if argCount == 0 then
			-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.9.3.3
			obj.primitiveValue = os.time() * 1000

		elseif argCount == 1 then
			obj.primitiveValue = constructWithValue((...))
		else
			obj.primitiveValue = constructWithFullDate(...)
		end

		return obj
	end




	--[[ External properties ]] 


	defineProperty(Date, 'now', Function:new('now', {}, function (this)
		return os.clock() * 1000
	end))




	--[[ Prototype ]] 


	local prototype = Object:new()

	defineProperty(Date, 'prototype', 0, prototype)
	defineProperty(prototype, 'constructor', Date)




	-- -- http://www.ecma-international.org/ecma-262/5.1/#sec-15.6.4.2
	-- defineProperty(prototype, 'toString', Function:new('toString', {}, function (this)
	-- 	-- 1 NOOP

	-- 	-- 2
	-- 	local t = typeof(this)
	-- 	local b

	-- 	if t == 'boolean' then
	-- 		b = this

	-- 	elseif t == 'object' and this.class == 'Boolean' then
	-- 		-- 3
	-- 		b = this.primitiveValue

	-- 	else
	-- 		-- 4
	-- 		throw(new(TypeError, 'Boolean.prototype.toString is not generic'))
	-- 	end

	-- 	-- 5
	-- 	return b and 'true' or 'false'
	-- end))




	-- http://www.ecma-international.org/ecma-262/5.1/#sec-15.6.4.3
	local function getTime (this)
		return this.primitiveValue
	end

	defineProperty(prototype, 'valueOf', Function:new('valueOf', {}, getTime))
	defineProperty(prototype, 'getTime', Function:new('getTime', {}, getTime))




	--

	defineProperty(global, 'Date', Date)	

end
