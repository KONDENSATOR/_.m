//
//  NSArray+SS.m
//  SubjectiveScript.m
//
//  Created by Kevin Malakoff on 7/17/12.
//  Copyright (c) 2012 Kevin Malakoff. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "NSArray+SS.h"
#import "NSMutableArray+SS.h"
#import "NSNumber+SS.h"
#import "NSMutableString+SS.h"
#import "NSObject+SS.h"
#import "SS+Types.h"

@implementation NSArray (SS)

+ (A*(^)(const B* values, I count))newB
{
  return ^(const B* values, I count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.B(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const I* values, I count))newI
{
  return ^(const I* values, I count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.I(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const UI* values, I count))newUI
{
  return ^(const UI* values, I count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.UI(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const F* values, I count))newF
{
  return ^(const F* values, I count) {
    A* result = [A arrayWithCapacity:count];
    
    for (I index=0; index<count; index++) {
      [result addObject:N.F(values[index])];
    }
    return result;
  };
}

+ (A*(^)(const id* values))newO
{
  return ^(const id* values) {
    A* result = A.new;
    for (const id* value=values; *value != nil; value++) {
      [result addObject:*value];
    }
    return result;
  };
}


- (NSS*(^)())toString { return ^() { return S.newFormatted(@"[%@]", self.join(@",")); }; }
- (UI)length { return self.count; }

- (NSO*(^)(I index))getAt
{
  return ^(I index) {
    return (index<self.length) ? [self objectAtIndex:index] : NSNull.null;
  };
}

- (S*(^)(NSS* separator))join 
{ 
  return ^(NSS* separator) { 
    S* result = S.new;
    I count = self.count;
    
    for (I index=0; index<count; index++) {
      NSO* item = [self objectAtIndex:index];
      if (index>0) result.append(separator);

      // JavaScript collapses arrays on join only if they do not contain other arrays and there are multiple elements. A bit quirky, but supported.
      if ((index>0) && SS.isArray(item) && (((NSA*)item).count==1)) {
        BOOL hasArrays = NO;
        for (NSO* subitem in (NSA*)item) {
          if (SS.isArray(subitem)) {
            hasArrays = YES;
            break;
          }
        }
        if(hasArrays)
          result.append(item.toString());
        else
          result.append(item.join(separator));
      }
      else
        result.append(item.toString());
    }
    return result;
  }; 
}

- (NSA*(^)(UI start, UI count))slice
{
  return ^(UI start, UI count) {
    if ((start + count)>self.length-1) count = self.length - start; // clamp to end of array
    if (count<=0) return NSA.new;
    return [self subarrayWithRange:NSMakeRange(start, count)];
  };
}

- (A*(^)())reverse
{
  return ^() {
    A* result = A.newC(self.count); 
    for (id item in [self reverseObjectEnumerator]) {
        [result addObject:item];
    }
    return result;
  };
}

- (A*(^)())flatten
{
  return ^() {
    A* output = A.new;
    for (id value in self) {
      if (SS.isArray(value))
        [output addObjectsFromArray:((NSA*)value).flatten()];
      else
        output.push(value);
    }
    return output;
  };
}

- (NSA*(^)(SSCompareBlock block))sort
{
  return ^(SSCompareBlock block) {
    if (SS.isNull(block)) block = ^NSComparisonResult((NSO* left, NSO* right)) {
      return [left compare:right];
    };
    return [self sortedArrayUsingComparator:block];
  };
}

@end