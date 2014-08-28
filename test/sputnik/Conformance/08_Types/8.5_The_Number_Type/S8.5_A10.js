// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S8.5_A10;
 * @section: 8.5, 7.8.3;
 * @assertion: Infinity is not a keyword;
 * @description: Create variable entitled Infinity;
*/


var Infinity=1.0;
Infinity='asdf';
Infinity=true;

// *** Updated in Hamlet ***
// Reason: Return Infinity to original value so that later tests in the
//         concatenated file execute as expected
// Added:
Infinity=Number.POSITIVE_INFINITY;
///