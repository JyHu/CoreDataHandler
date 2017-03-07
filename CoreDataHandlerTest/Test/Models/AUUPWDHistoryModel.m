//
//  AUUPWDHistoryModel.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUPWDHistoryModel.h"
#import "NSObject+AUUHelper.h"

@implementation AUUPWDHistoryModel

+ (id)generate
{
    AUUPWDHistoryModel *model = [[AUUPWDHistoryModel alloc] init];
    
    model.h_id = [model generateUUIDString];
    model.h_pwd = [model generateUUIDString];
    model.h_date = [[NSDate date] dateByAddingTimeInterval:-1 * arc4random_uniform(1000000)];
    model.h_synced = arc4random_uniform(2);
    
    return model;
}

- (NSString *)primaryKey
{
    return @"h_id";
}

- (Class)mapEntityClass
{
    return [PWDHistoryEntity class];
}

- (NSString *)description
{
    NSMutableString *desc = [[NSMutableString alloc] init];
    
    [desc appendFormat:@"h_id : %@\n", self.h_id];
    [desc appendFormat:@"h_pwd : %@\n", self.h_pwd];
    [desc appendFormat:@"h_date : %@\n", self.h_date];
    [desc appendFormat:@"h_synced : %@\n", @(self.h_synced)];
    
    return desc;
}

@end
