//
//  AUUPWDGroupModel.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUPWDGroupModel.h"
#import "AUUPWDDetailModel.h"
#import "PWDDetailEntity.h"
#import "NSObject+AUUHelper.h"

@implementation AUUPWDGroupModel

+ (id)generate
{
    AUUPWDGroupModel *model = [[AUUPWDGroupModel alloc] init];
    
    model.g_id = [AUUBaseRecordsCenter generateUUIDString];
    model.g_name = [NSString stringWithFormat:@"group name %zd", arc4random_uniform(100000)];
    model.g_date = [[NSDate date] dateByAddingTimeInterval:-1 * arc4random_uniform(100000000)];
    model.g_synced = arc4random_uniform(2);
    
    NSMutableArray *arr  = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < arc4random_uniform(10) + 10; i ++)
    {
        [arr addObject:[AUUPWDDetailModel generate]];
    }
    model.passwords_ship = arr;
    
    return model;
}

- (Class)mapEntityClass
{
    return [PWDGroupEntity class];
}

- (NSString *)primaryKey
{
    return @"g_id";
}

- (NSString *)description
{
    NSMutableString *desc = [[NSMutableString alloc] init];
    
    [desc appendFormat:@"g_id : %@\n", self.g_id];
    [desc appendFormat:@"g_name : %@\n", self.g_name];
    [desc appendFormat:@"g_date : %@\n", self.g_date];
    [desc appendFormat:@"g_synced : %@\n", @(self.g_synced)];
    
    for (AUUPWDDetailModel *model in self.passwords_ship)
    {
        [desc appendFormat:@"    password_ship : %@\n", [model description]];
    }
    
    return desc;
}

@end
