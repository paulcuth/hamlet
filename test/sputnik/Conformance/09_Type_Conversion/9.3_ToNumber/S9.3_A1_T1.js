// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S9.3_A1_T1;
 * @section: 9.3, 15.7.1;
 * @assertion: Result of number conversion from undefined value is NaN;
 * @description: Undefined convert to Number by explicit transformation;
*/

// CHECK#1
if (isNaN(Number(undefined)) !== true) {
  $ERROR('#1: Number(undefined) === Not-a-Number. Actual: ' + (Number(undefined)));
}

// CHECK#2
if (isNaN(Number(void 0)) !== true) {
  $ERROR('#2: Number(void 0) === Not-a-Number. Actual: ' + (Number(void 0)));
}

// CHECK#3
// *** Updated in Hamlet ***
// Reason: Implementating eval() is dependent on translating the parser to Lua
// 		   Therefore, this test is postoned until later.
// @todo
// Removed:
// if (isNaN(Number(eval("var x"))) !== true) {
//   $ERROR('#3: Number(eval("var x")) === Not-a-Number. Actual: ' + (Number(eval("var x"))));
// }
