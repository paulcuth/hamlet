
do
	local function parseAndExecute (pipe, chunkName)
		local lua = pipe:read('*a')
		local f = loadstring(lua, chunkName)
		
		if f == nil then
			print 'Nothing to run.'
		else
			execute(f)
		end
	end


	local filename = arg[1]

	if filename == nil then
		print 'No file specified.'
	
	elseif filename == '-e' then
		local js = arg[2]
		local pipe = io.popen('parser/parser.js -e "'..string.gsub(js, '"', '\\"')..'"')
		parseAndExecute(pipe, 'cmdline')

	else
		if string.sub(filename, -3) == '.js' then
			local pipe = io.popen('parser/parser.js ' + filename)
			parseAndExecute(pipe, filename)

		else
			local f, err = loadfile(filename, filename)

			if f == nil then
				print('Error loading file '..filename..': '..err)
			else
				execute(f)
			end
		end
	end
end