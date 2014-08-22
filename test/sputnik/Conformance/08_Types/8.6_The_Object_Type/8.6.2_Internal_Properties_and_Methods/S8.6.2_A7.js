// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S8.6.2_A7;
* @section: 8.6.2, 15.8;
* @assertion: Objects that implement internal method [[Construct]] are called constructors. Math object is NOT constructor;
* @description: Checking if execution of "var objMath=new Math" passes; 
* @negative;
*/

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
// *** Updated in Hamlet ***
// Reason: To handle negative
// Added: try/catch
try{
	var objMath=new Math;
	$ERROR('Should not be able in instanciate Math object');
} catch (e) {}
//////////////////////////////////////////////////////////////////////////////
