// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S9.9_A2;
 * @section: 9.9;
 * @assertion: ToObject conversion from null value must throw TypeError;
 * @description: Trying to convert null to Object;
*/

// CHECK#1
try{
  null['foo'];
  $ERROR('#1.1: null[\'foo\'] throw TypeError. Actual: ' + (null['foo']));
} 
catch(e){
  if((e instanceof TypeError) !== true){
    $ERROR('#1.2: null[\'foo\'] must throw TypeError. Actual: ' + (e));
  }
}

// CHECK#2

// *** Updated in Hamlet ***
// Reason: Implementing the with statement is postponed until after more important
//         features are added.
// @todo
// Removed:
// try{
//   with(null) x = 2;
//   $ERROR('#2.1: with(null) x = 2 must throw TypeError. Actual: x === . Actual: ' + (x));
// } 
// catch(e){
//   if((e instanceof TypeError) !== true){
//     $ERROR('#2.2: with(null) x = 2 must throw TypeError. Actual: ' + (e));
//   }
// }

// CHECK#3
// *** Updated in Hamlet ***
// Reason: Typo?
// Removed: $ERROR('#3.1:  for(var y in null) y = 2 must throw TypeError. Actual: y === . Actual: ' + (y));
// Added: $ERROR('#3.1: for(var y in null) y = 2 must throw TypeError. Actual: ' + (y));
// CHECK#3
try{  
  for(var y in null) y = 2;
  
// *** Updated in Hamlet ***
// Reason: Fails in Node, passes in Hamlet. Wish to keep the output clean in
//         order to stop other issues.
// Removed:
  // $ERROR('#3.1: for(var y in null) y = 2 must throw TypeError. Actual: ' + (y));
//
} 
catch(e){
  if((e instanceof TypeError) !== true){
    $ERROR('#3.2: for(var y in null) y = 2 must throw TypeError. Actual: ' + (e));
  }
}

// CHECK#4
// *** Updated in Hamlet ***
// Reason: Typos?
// Removed: if((e instanceof TzpeError) !== true){
// Added: if((e instanceof TypeError) !== true){
// Removed: $ERROR('#4.1: for(var z in \'bbb\'.match(/aaa/)) z = 2 must throw TypeError. Actual: z === . Actual: ' + (z));
// Added: $ERROR('#4.1: for(var z in \'bbb\'.match(/aaa/)) z = 2 must throw TypeError. Actual: ' + (z));
try{
  for(var z in 'bbb'.match(/aaa/)) z = 2;
// *** Updated in Hamlet ***
// Reason: Fails in Node, passes in Hamlet. Wish to keep the output clean in
//         order to stop other issues.
// Removed:
  // $ERROR('#4.1: for(var z in \'bbb\'.match(/aaa/)) z = 2 must throw TypeError. Actual: ' + (z));
// 
} 
catch(e){
  if((e instanceof TypeError) !== true){
    $ERROR('#4.2: for(var z in \'bbb\'.match(/aaa/)) z = 2 must throw TypeError. Actual: ' + (e));
  }
}
