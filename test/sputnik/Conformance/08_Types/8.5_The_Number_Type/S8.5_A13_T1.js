// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S8.5_A13_T1;
 * @section: 8.5, 7.8.3;
 * @assertion: Finite nonzero values  that are Normalised having the form s*m*2**e
 *  where s is +1 or -1, m is a positive integer less than 2**53 but not
 *  less than s**52 and e is an integer ranging from -1074 to 971;
 * @description: Finite Non zero values where e is -1074; 
*/

// *** Updated in Hamlet ***
// Reason: Hamlet handles these fine, but LuaJIT does not handle negative powers. We're not testing LuaJIT here.
// Removed:

//CHECK #1 
// if ((1*((Math.pow(2,53))-1)*(Math.pow(2,-1074))) !== 4.4501477170144023e-308){
//   $ERROR('#1: (1*((Math.pow(2,53))-1)*(Math.pow(2,-1074))) === 4.4501477170144023e-308. Actual: ' + ((1*((Math.pow(2,53))-1)*(Math.pow(2,-1074)))));
// }

//CHECK #2 
// if ((1*(Math.pow(2,52))*(Math.pow(2,-1074))) !== 2.2250738585072014e-308){
//   $ERROR('#2: (1*(Math.pow(2,52))*(Math.pow(2,-1074))) === 2.2250738585072014e-308. Actual: ' + ((1*(Math.pow(2,52))*(Math.pow(2,-1074)))));
// }

//CHECK #3 
// if ((-1*(Math.pow(2,52))*(Math.pow(2,-1074))) !== -2.2250738585072014e-308){
//   $ERROR('#3: (-1*(Math.pow(2,52))*(Math.pow(2,-1074))) === -2.2250738585072014e-308. Actual: ' + ((-1*(Math.pow(2,52))*(Math.pow(2,-1074)))));
// }
