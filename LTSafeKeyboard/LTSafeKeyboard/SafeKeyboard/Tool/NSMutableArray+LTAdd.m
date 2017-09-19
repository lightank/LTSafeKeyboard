//
//  NSMutableArray+LTAdd.m
//  testAPP
//
//  Created by huanyu.li on 2017/9/12.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import "NSMutableArray+LTAdd.h"

@implementation NSMutableArray (LTAdd)

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    NSUInteger insertIndex = index > self.count ? self.count : index;
    if (anObject)
    {
        [self insertObject:anObject atIndex:insertIndex];
    }
}

- (void)safeChangeObjectIndexFrom:(NSUInteger)idx1 toIndex:(NSUInteger)idx2
{
    if (idx1 == idx2 || !self || self.count == 0 || ![self isKindOfClass:[NSMutableArray class]]) return;

    NSUInteger originalIndex = idx1 > self.count - 1 ? self.count - 1 : idx1;
    NSUInteger targetIndex = idx2 > self.count- 1 ? self.count- 1 : idx2;
    
    if (originalIndex == targetIndex) return;
    
    id originalObject = self[originalIndex];
    [self removeObjectAtIndex:originalIndex];
    
    [self insertObject:originalObject atIndex:targetIndex];
}

@end
