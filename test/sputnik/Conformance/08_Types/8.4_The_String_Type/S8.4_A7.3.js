// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S8.4_A7.3;
* @section: 8.4, 7.8.4;
* @assertion: <PS> between chunks of one string not allowed;
* @description: Insert <PS> between chunks of one string;
* @negative;
*/

// Reason: Implementating eval() is dependent on translating the parser to Lua
// 		   Therefore, this test is postoned until later.
// @todo
// Removed:
//eval("var x = asdf\u2028ghjk");
