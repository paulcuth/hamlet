// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S8.7_A5_T2;
* @section: 8.7, 11.4.1;
* @assertion: Delete unary operator can't delete object to be referenced;
* @description: Delete referenced object, __ref = obj;
*/

//////////////////////////////////////////////////////////////////////////////
//CHECK#1

// *** Updated in Hamlet ***
// Reason: Intention of ttest is that var is undefined, which is not true once 
// 		   file is concatencated.
// Removed: _ref
// Added: _nullref

if (typeof(__nullref) !== "undefined"){
    $ERROR('#1: typeof(__ref) === "undefined". Actual: ' + (typeof(__ref)));  
}; 
//
//////////////////////////////////////////////////////////////////////////////

obj = new Object();
__ref = obj;

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
if (typeof(__ref) === "undefined"){
    $ERROR('#2: obj = new Object(); __ref = obj; typeof(__ref) !== "undefined"');
}; 
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#3
if (delete __ref !== true){
    $ERROR('#3: obj = new Object(); __ref = obj; delete __ref === true. Actual: ' + (delete __ref));
};
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#4
if (typeof(__ref) !== "undefined"){
    $ERROR('#4: obj = new Object(); __ref = obj; delete __ref; typeof(__ref) === "undefined". Actual: ' + (typeof(__ref)));
};
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#5
if (typeof(obj) !== "object"){
    $ERROR('#5: obj = new Object(); __ref = obj; delete __ref; typeof(obj) === "object". Actual: ' + (typeof(obj)));
};
//
//////////////////////////////////////////////////////////////////////////////
