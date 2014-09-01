// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S9.8_A4_T2;
 * @section: 9.8;
 * @assertion: Result of String conversion from string value is the input argument (no conversion);
 * @description: Some strings convert to String by implicit transformation;
*/

// CHECK#1
var x1 = "abc";
if (x1 + "" !== x1) {
  $ERROR('#1: "abc" + "" === "abc". Actual: ' + ("abc" + ""));
}

// CHECK#2
var x2 = "abc";
if (typeof x2 + "" !== typeof x2) { 
  $ERROR('#2: typeof "abc" + "" === "string". Actual: ' + (typeof "abc" + ""));
}
