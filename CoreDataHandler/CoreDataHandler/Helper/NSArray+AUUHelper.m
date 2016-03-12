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

- (NSMutableArray *)convertEntitiesToModels
{
    if (self && self.count > 0)
    {
        NSMutableArray *modelsArray = [[NSMutableArray alloc] init];
        
        for (id entity in self)
        {
            if ([entity isKindOfClass:[NSManagedObject class]])
            {
                [modelsArray addObject:[entity assignToModel]];
            }
        }
        
        return modelsArray;
    }
    
    return nil;
}

@end
