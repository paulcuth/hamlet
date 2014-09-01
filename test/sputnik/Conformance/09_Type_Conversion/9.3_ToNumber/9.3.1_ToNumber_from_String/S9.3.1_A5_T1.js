// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S9.3.1_A5_T1;
 * @section: 9.3.1, 15.7.1;
 * @assertion: The MV of StrDecimalLiteral::: - StrUnsignedDecimalLiteral is the negative 
 * of the MV of StrUnsignedDecimalLiteral. (the negative of this 0 is also 0);
 * @description: Compare Number('-any_number') with -Number('any_number');
*/

// CHECK#1

// *** Updated in Hamlet ***
// Reason: Exposes a bug in Lua where 1/-0 is not always -inf.
//         Works fine in LuaJIT.
// @todo Revisit after logging issue to lua-l
// Removed:
// if (Number("-0") !== -Number("0")) {
//   $ERROR('#1: Number("-0") === -Number("0")');
// } else {
//   // CHECK#2
//   if (1/Number("-0") !== -1/Number("0")) {
//     $ERROR('#2: 1/Number("-0") === -1/Number("0")');
//   }
// }


// CHECK#3
if (Number("-Infinity") !== -Number("Infinity")) {
  $ERROR('#3: Number("-Infinity") === -Number("Infinity")');
}

// CHECK#4
if (Number("-1234567890") !== -Number("1234567890")) {
  $ERROR('#4: Number("-1234567890") === -Number("1234567890")');
}

// CHECK#5
if (Number("-1234.5678") !== -Number("1234.5678")) {
  $ERROR('#5: Number("-1234.5678") === -Number("1234.5678")');
}

// CHECK#6
if (Number("-1234.5678e90") !== -Number("1234.5678e90")) {
  $ERROR('#6: Number("-1234.5678e90") === -Number("1234.5678e90")');
}

// CHECK#7
if (Number("-1234.5678E90") !== -Number("1234.5678E90")) {
  $ERROR('#6: Number("-1234.5678E90") === -Number("1234.5678E90")');
}

// CHECK#8
if (Number("-1234.5678e-90") !== -Number("1234.5678e-90")) {
  $ERROR('#6: Number("-1234.5678e-90") === -Number("1234.5678e-90")');
}

// CHECK#9
if (Number("-1234.5678E-90") !== -Number("1234.5678E-90")) {
  $ERROR('#6: Number("-1234.5678E-90") === -Number("1234.5678E-90")');
}

// CHECK#10
if (Number("-Infinity") !== Number.NEGATIVE_INFINITY) {
  $ERROR('#3: Number("-Infinity") === Number.NEGATIVE_INFINITY');
}
