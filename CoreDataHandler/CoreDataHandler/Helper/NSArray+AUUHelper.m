//
//  NSArray+AUUHelper.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/12.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "NSArray+AUUHelper.h"
#import "NSManagedObject+AUUHelper.h"

@implementation NSArray (AUUHelper)

- (NSArray *)convertEntitiesToModels
{
    return [self auu_map:^id(NSManagedObject *entity) {
        if ([entity isKindOfClass:[NSManagedObject class]]) {
            return [entity assignToModel];
        }
        return nil;
    }];
}

- (NSArray *)auu_map:(id(^)(id))map
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    if (self && self.count > 0) {
        for (id obj in self) {
            id trans = map(obj);
            if (trans) {
                [res addObject:trans];
            }
        }
    }
    
    return res;
}

@end
