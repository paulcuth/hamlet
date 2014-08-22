*** Note: This is work in progress. It's still early days and is not really usable yet. ***

# Hamlet
Hamlet is a JavaScript to Lua translator and runtime. It is still in development and is probably not capable of running your JavaScripts. Yet.


## Aims
This project aims to:
- create an ES5.1-compliant JavaScript runtime written in Lua.
- create an embeddable JavaScript runtime.
- create a minimal JavaScript runtime, with ability to pick 'n' mix features.
- make packages in the NPM registry available to use in Lua runtimes.


## Installing

### Prerequisites
Currently you will need [Node](http://nodejs.org) and [Gulp](http://gulpjs.com) installed to build Hamlet. In theory, once Hamlet is complete, the parser and acorn.js dependency can be translated to Lua and Node will no longer be required.

You'll need [Lua](http://www.lua.org), [LuaJIT](http://luajit.org) and Node to run the tests, as the same script is benchmarked and compared in all three runtimes.


### Building
```shell
git clone git@github.com:paulcuth/hamlet.git
cd hamlet
npm install
gulp 
```

This will build `out/hamlet.lua`, compile the Sputnik conformance tests and run the latter in the former. 

If you only wish to build Hamlet, use `gulp build` instead.


## Running
You can use any of the following commands to run your JavaScript code:
```shell
lua out/hamlet.lua myscript.js
luajit out/hamlet.lua myscript.js
lua out/hamlet.lua -e "console.log('Hello world');"
luajit out/hamlet.lua -e "console.log('Hello world');"
```

You can also translate your JavaScript to Lua in advance and then run that in Hamlet:
```shell
node parser/parser.js myscript.js > myscript.lua
lua out/hamlet.lua myscript.lua
```


## Contributing
Please be aware that Hamlet is under heavy development and there are existing plans for a lot of that which is yet to be implemented. 
I'm happy to discuss the project with anyone who wants to get involved. Give me a shout at [@paulcuth](https://twitter.com/paulcuth).


## License
MIT


