#!/usr/bin/env node


var acorn = require('acorn'),
	fs = require('fs');




function parse (code) {
	var tree = acorn.parse(code)
	// console.log (JSON.stringify(tree))
	if (tree.type != 'Program') throw new TypeError('Program expected');

	var output = parseProgram(tree);
	// console.log ('===================\n' + output);

	return output;
}




function parseProgram (node) {
	var state = { locals: {}, functions: [], functionNames: [] },
		body = parseBlockStatement(node, state),
		locals = state.locals,
		functions = state.functions,
		declarations = '',
		i, value;

	for (i in locals) {
		value = locals[i];
		if (value == 'undefined') value = 'global:get("' + i + '")';
		declarations += 'local ' + i + '=' + value + '\n';
	}

	for (i in functions) {
		declarations += functions[i] + '\n';
	}

	return '' + declarations + body + '\n';
}




function parseBlockStatement (program, state) {
	var body = program.body,
		result = '';

	for (var i = 0, node; node = body[i]; i++) {
		result += parseNode(node, state) + '\n';
	}

	return result;
}




function parseNode (node, state) {

	switch (node.type) {
		case 'VariableDeclaration':
			return parseVariableDeclaration(node, state);

		case 'FunctionDeclaration':
			return parseFunctionDeclaration(node, state);

		case 'Identifier':
			return parseIdentifier(node, state);

		case 'Literal':
			return parseLiteral(node, state);

		case 'CallExpression':
			return parseCallExpression(node, state);

		case 'MemberExpression':
			return parseMemberExpression(node, state);

		case 'ExpressionStatement':
			return parseExpressionStatement(node, state);

		case 'BinaryExpression':
			return parseBinaryExpression(node, state);

		case 'ForStatement':
			return parseForStatement(node, state);

		case 'BlockStatement':
			return parseBlockStatement(node, state);

		case 'AssignmentExpression':
			return parseAssignmentExpression(node, state);

		case 'UpdateExpression':
			return parseUpdateExpression(node, state);

		case 'ObjectExpression':
			return parseObjectExpression(node, state);

		case 'IfStatement':
			return parseIfStatement(node, state);

		case 'FunctionExpression':
			return parseFunctionExpression(node, state);

		case 'UnaryExpression':
			return parseUnaryExpression(node, state);

		case 'EmptyStatement':
			return parseEmptyStatement(node, state);

		case 'NewExpression':
			return parseNewExpression(node, state);

		case 'ForInStatement':
			return parseForInStatement(node, state);

		case 'ReturnStatement':
			return parseReturnStatement(node, state);

		case 'ThisExpression':
			return parseThisExpression(node, state);

		case 'TryStatement':
			return parseTryStatement(node, state);

		case 'ThrowStatement':
			return parseThrowStatement(node, state);

		case 'LogicalExpression':
			return parseLogicalExpression(node, state);

		case 'ArrayExpression':
			return parseArrayExpression(node, state);

		case 'WithStatement':
			return parseWithStatement(node, state);

		default:
			throw TypeError('Unknown node type: ' + node.type);
	}
}




function parseVariableDeclaration (node, state) {
	var declarations = node.declarations,
		local = node.kind == 'var',
		result = '';

	for (var i = 0, node; node = declarations[i]; i++) {
		if (node.type == 'VariableDeclarator') {
			result += parseVariableDeclarator(node, state, local);
		} else {
			throw TypeError('Unknown declaration');
		}
	}

	return result;
}




function parseVariableDeclarator (node, state, local) {
	var id = parseNode(node.id, state),
		init = node.init;

	if (local) state.locals[id] = 'undefined';

	return init? id + '=' + parseNode(init, state) : '';
}




function parseIdentifier (node) {
	return node.name.replace('$', '_dollar_');
}




function parseLiteral (node) {
	var val = node.value;

	if (typeof val == 'string') {
		val = val.replace('\0', '\\0')
		// todo Escape all invalid sequences in lua.

		return JSON.stringify(val);
	} else if (val instanceof RegExp) {
		var flags = '';
		if (val.global) flags += 'g';
		if (val.ignoreCase) flags += 'i';
		if (val.multiline) flags += 'm';

		return '__hamlet_new(RegExp("' + val.source + '","' + flags + '"))';
	}

	return '' + val;
}




function parseCallExpression (node, state) {
	var callee = parseNode(node.callee, state),
		arguments = node.arguments,
		context = node.callee.type == 'MemberExpression'? parseNode(node.callee.object, state) : 'global',
		args = [],
		i, arg;	
		// TODO? env?

	for (i = 0; arg = arguments[i]; i++) {
		args.push(parseNode(arg, state));
	}

	args.unshift(context);
	return callee + '(' + args.join() + ')';
}




function parseMemberExpression (node, state) {
	var object = parseNode(node.object, state),
		property = parseNode(node.property, state);

	if (!node.computed) property = '"' + property + '"';

	if (state) {
		state.locals.__hamlet_object_get = '__hamlet_type_Object.get';
		return '__hamlet_object_get('+ object + ',' + property + ')';
	}

	return object + ':get(' + property + ')';
}




function parseExpressionStatement (node, state) {
	return parseNode(node.expression, state);
}




function parseBinaryExpression (node, state) {
	var left = parseNode(node.left, state),
		right = parseNode(node.right, state),
		operator = node.operator;

	switch (operator) {
		case '==': return '__hamlet_equal(' + left + ',' + right + ')';
		case '!=': return 'not(__hamlet_equal(' + left + ',' + right + '))';
		case 'in': return '__hamlet_binaryIn(' + left + ',' + right + ')';
		case 'instanceof': return '__hamlet_instanceof(' + left + ',' + right + ')';
		case '+': return '__hamlet_add(' + left + ',' + right + ')';
		case '<': return '__hamlet_lessThan(' + left + ',' + right + ', true)';
		case '>': return '__hamlet_lessThan(' + right + ',' + left + ', false)';
		case '<=': return '__hamlet_lessThanEqualTo(' + left + ',' + right + ', true)';
		case '>=': return '__hamlet_lessThanEqualTo(' + right + ',' + left + ', false)';
		case '<<': return '__hamlet_leftShift(' + left + ',' + right + ')';
		case '>>': return '__hamlet_rightShiftSigned(' + left + ',' + right + ')';
		case '>>>': return '__hamlet_rightShiftUnsigned(' + left + ',' + right + ')';

		case '===':
			operator = '==';
			break;

		case '!==':
			operator = '~=';
			break;
	}

	return '(' + left + operator + right + ')';
}




function parseForStatement (node, state) {
	var init = parseNode(node.init, state),
		test = parseNode(node.test, state),
		update = parseNode(node.update, state),
		body = parseNode(node.body, state);

	return init + '\nwhile (' + test + ') do\n' + body + update + '\nend';
}




function parseAssignmentExpression (node, state) {
	var left = parseNode(node.left),
		right = parseNode(node.right, state),
		operator = node.operator,
		match;

	switch (operator) {
		case '+=': 
			operator = '=';
			right = '__hamlet_add(' + left + ',' + right + ')';
			break;

		case '-=': 
			operator = '=';
			right = '__hamlet_subtract(' + left + ',' + right + ')';
			break;
	}		

	if (match = left.match(/^(.*):get\(([^)]+)\)$/)) {
		if (state) {
			state.locals.__hamlet_object_put = '__hamlet_type_Object.put';
			return '__hamlet_object_put(' + match[1] + ',' + match[2] + ',' + right + ')';
		}

		return match[1] + ':put(' + match[2] + ',' + right + ')';
	}

	return left + operator + right;
}




function parseUpdateExpression (node, state) {
	var argument = node.argument,
		operator = node.operator == '++'? 'add' : 'subtract',
		isMemberExpression = argument.type == 'MemberExpression',
		isPrefix = node.prefix,
		object, property;

	if (isMemberExpression) {
		// state.locals.__hamlet_object_get = '__hamlet_type_Object.get';
		// state.locals.__hamlet_object_put = '__hamlet_type_Object.put';

		object = parseNode(argument.object, state);
		property = parseNode(argument.property, state);

		return '__hamlet_updateOp(' + object + ',"' + property + '",__hamlet_' + operator + ',' + isPrefix + ')';
	}

	argument = parseNode(argument, state);
	return '__hamlet_ToNumber((function()local result result, ' + argument + '=__hamlet_updateOp(nil,' + argument + ',__hamlet_' + operator + ',' + isPrefix + ') return result end)())';
}




function parseObjectExpression (node, state) {
	var properties = node.properties,
		props = [],
		prop, i, key;

	for (i = 0; prop = properties[i]; i++) {
		key = parseNode(prop.key, state);
		// if (key.substr(0, 1) != '"') key = '"' + key + '"';
		if (prop.key.type == 'Identifier') key = '"' + key + '"';

		props.push('[' + key+ ']=' + parseNode(prop.value, state))
	}

	props = props.length? '{' + props.join(',') + '}' : 'nil'

	if (state) {
		state.locals.__hamlet_object_new = '__hamlet_type_Object.new';
		return '__hamlet_object_new(__hamlet_type_Object,' + props + ')';
	}

	return '__hamlet_type_Object:new(' + props + ')';
}




function parseIfStatement (node, state) {
	var test = parseNode(node.test, state),
		consequent = parseNode(node.consequent, state),
		alternate = node.alternate;

	if (alternate) alternate = parseNode(alternate, state);

	return 'if __hamlet_ToBoolean(' + test + ') then\n' + consequent + (alternate? 'else\n' + alternate : '') + '\nend'
}




function parseFunctionDeclaration (node, state) {
	var id = parseNode(node.id),
		functions = state.functions,
		names = state.functionNames,
		result = 'local ' + id + '=' + parseFunctionExpression(node);

	if (names.indexOf(id) == -1) {
		names.push(id);
		functions.push(result);
	} else {
		functions[id] = result;
	}

	return '';
}




function parseFunctionExpression (node) {

	var state = { locals: {}, functions: [], functionNames: [] },
		id = node.id? parseNode(node.id) : '',
		params = node.params.map(parseNode),
		paramList = params.length? '"' + params.join('","') + '"' : '',
		// rest ?
		body = parseNode(node.body, state),
		locals = state.locals,
		functions = state.functions,
		strict = false,			// TODO: Work out strict mode.
		result, i;

	params.unshift('this');
	params = params.join(', ');

	result = '__hamlet_type_Function:new("' + id + '", {' + paramList + '}, ' + strict + ', function (' + params + ')\n';
	result += 'local arguments = __hamlet_getArguments()\n';

	for (i in locals) {
		result += 'local ' + i + '=' + locals[i] + '\n';
	}

	for (i in functions) {
		result += functions[i] + '\n';
	}

	return result + body + 'end)'
}




function parseUnaryExpression (node, state) {
	var body = parseNode(node.argument, state),
		obj, property;

	switch (node.operator) {
		case '-': return '-__hamlet_ToNumber(' + body + ')';
		case '+': return '__hamlet_ToNumber(' + body + ')';
		case '!': return 'not __hamlet_ToBoolean(' + body + ')';
		case '~': return '__hamlet_bitwiseNot(' + body + ')';
		case 'typeof': return '__hamlet_typeof(' + body + ')';
		case 'void': return '__hamlet_void(' + body + ')';

		case 'delete': 
			if (node.argument.type == 'MemberExpression') {
				object = parseNode(node.argument.object);
				property = parseNode(node.argument.property);
			} else {
				object = 'nil';
				property = parseNode(node.argument);
			}

			if (property.substr(0,1) != '"') property = '"' + property + '"';
			return '__hamlet_delete(' + object + ',' + property + ')';
	}

	throw new ReferenceError('Unknown unary operator: ' + node.operator);
}




function parseEmptyStatement (node, state) {
	return '\n';
}




function parseNewExpression (node, state) {
	var callee = parseNode(node.callee, state),
		argNodes = node.arguments,
		args = [],
		i, argNode;

	for (i = 0; argNode = argNodes[i]; i++) {
		args.push(',' + parseNode(argNode, state));
	}

	return '__hamlet_new(' + callee + args.join('') + ')';
}




function parseForInStatement (node, state) {

	var left,
		right = parseNode(node.right, state),
		body = parseNode(node.body, state),
		each = node.each;			// TODO

	if (node.left.type == 'VariableDeclaration') {
		var dec0 = node.left.declarations[0];
		if (dec0.type == 'VariableDeclarator') {
			left = dec0.id.name;
		}
	}

	if (!left) left = parseNode(node.left, state);
	return 'for ' + left + ' in __hamlet_forIn(' + right + ') do\n' + body + '\nend';
}




function parseReturnStatement (node, state) {
	var argument = parseNode(node.argument, state);
	return 'return(' + argument + ')';
}




function parseThisExpression (node, state) {
	return 'this';
}




function parseTryStatement (node, state) {
// console.log (JSON.stringify(node));
	var body = parseNode(node.block, state),
		param = parseNode(node.handler.param, state),
		handler = parseNode(node.handler.body, state),
		// handers = body.handlers,
		fin = node.finalizer && parseNode(node.finalizer, state),	// todo
		result;	

	result = 'local __hamlet_pcall_result, __hamlet_pcall_value = __hamlet_pcall(function()\n' + body + '\nend)';
	result += 'if not __hamlet_pcall_result then\ndo\nlocal ' + param + '=__hamlet_getError(__hamlet_pcall_value)\n' + handler + '\nend\nend'

	return result;
}




function parseThrowStatement (node, state) {
	var argument = parseNode(node.argument);
	return '__hamlet_throw(' + argument + ')';
}




function parseLogicalExpression (node, state) {
	var left = parseNode(node.left, state),
		right = parseNode(node.right, state),
		operator = node.operator;

	switch (operator) {
		case '&&':
			operator = 'and';
			break;

		case '||':
			operator = 'or';
			break;
	}

	return '((' + left + ')' + operator + '(' + right + '))';
}




function parseArrayExpression (node, state) {
	var items = node.elements.map(function (item) { 
		return item === null? 'nil' : parseNode(item, state);
	});

	return '__hamlet_new(Array,' + items.join(',') + ')';
}




function parseWithStatement (node, state) {
	throw new Error('With statements are currently not supported.')
}




module.exports = {

	parse: parse,

	parseFile: function (filename, callback) {
		fs.readFile(filename, function (err, data) {
			if (err) return callback (err);
			callback(null, parse(data));
		})
	},

	parseFileSync: function (filename) {
		var data = fs.readFileSync(filename);
		return parse(data);
	}

};




if (process && process.mainModule.filename == module.filename) {
	var filename = process.argv[2];

	if (!filename) {
		console.error('No file specified.');

	} else if (filename == '-e') {
		var code = process.argv[3];
		console.log(parse(code));

	} else {
		var content = require('fs').readFileSync(filename);

		if (!content) {
			console.error('Error reading file: ' + filename);
		} else {
			console.log(module.exports.parseFileSync(filename));
		}
	}
}

