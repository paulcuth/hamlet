
'use strict';


var gulp = require('gulp'),
	concat = require('gulp-concat'),
	through = require('through'),
	Buffer = require('buffer').Buffer,
	hamletParser = require('./parser/parser');




var translate = function () {

	function bufferContents (file) {
		var lua = hamletParser.parse(file.contents.toString()),
			luaFile = file.clone();

		if (luaFile.path.substr(-3) == '.js') luaFile.path = luaFile.path.substr(0, luaFile.path.length - 3);
		luaFile.path += '.lua';
		luaFile.contents = new Buffer(lua);

		this.emit('data', luaFile);
	}

	function endStream () {
		this.emit('end');
	}

	return through(bufferContents, endStream);
};




gulp.task('build', function () {
	var files = [
		'./src/core/init.lua',
		'./src/core/types/Object.lua',
		'./src/core/types/Function.lua',
		'./src/core/abstracts.lua',
		'./src/core/lang.lua',
		'./src/core/env/global.lua',
		'./src/core/env/Object.lua',
		'./src/core/env/Function.lua',
		'./src/core/env/Array.lua',
		'./src/core/env/Number.lua',
		'./src/core/env/String.lua',
		'./src/core/env/Boolean.lua',
		'./src/core/env/Error.lua',
		'./src/core/env/TypeError.lua',
		'./src/core/env/Math.lua',
		'./src/core/env/Date.lua',
		'./src/node/console.lua',
		'./src/core/cli.lua'
	];

	return gulp.src(files)
		.pipe(concat('hamlet.lua'))
		.pipe(gulp.dest('./out'));
});




gulp.task('build-run-sputnik', function () {
	gulp.src(['./test/sputnik-bootstrap-header.js', './test/sputnik/**/*.js', './test/sputnik-bootstrap-footer.js'])
		.pipe(concat('sputnik.js'))
		.pipe(gulp.dest('./out'))
		.pipe(translate())
		.pipe(gulp.dest('./out'))
	 	.on('end', function () {

 			var exec = require('child_process').exec,
				command = "out/hamlet.lua out/sputnik.lua",
 				start = Date.now();

			exec(command, function (err, out, stderr) {
				var end = Date.now();
				console.log ('---------------------\nLua:\n' + out  + stderr + '[VM+script: ' + (end - start) + 'ms]');

				command = "luajit -O-fwd,-cse out/hamlet.lua out/sputnik.lua";
				start = Date.now();

				exec(command, function (err, out, stderr) {
					end = Date.now();
					console.log ('---------------------\nLuaJIT:\n' + out  + stderr + '[VM+script: ' + (end - start) + 'ms]');

					// command = "node out/sputnik.js";													// Runs as module; this != global => errors
					command = "node -e \"eval(''+require('fs').readFileSync('./out/sputnik.js'));\"";	// Doesn't run as module (no difference in benchmark speed)
					start = Date.now();

					exec(command, function (err, out, stderr) {
						end = Date.now();
						console.log ('---------------------\nNode:\n' + out  + stderr + '[VM+script: ' + (end - start) + 'ms]');

					});
				});

			});

	 	});
});




gulp.task('default', ['build', 'build-run-sputnik']);

