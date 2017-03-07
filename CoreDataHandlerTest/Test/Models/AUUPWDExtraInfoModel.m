//
//  AUUPWDExtraInfoModel.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUPWDExtraInfoModel.h"
#import "NSObject+AUUHelper.h"

@implementation AUUPWDExtraInfoModel

+ (id)generate
{
    AUUPWDExtraInfoModel *model = [[AUUPWDExtraInfoModel alloc] init];
    
    model.e_id = [model generateUUIDString];
    model.e_type = arc4random_uniform(10);
    model.e_value = [NSString stringWithFormat:@"generate value %zd", arc4random_uniform(100000)];
    model.e_synced = arc4random_uniform(2);
    model.e_attrname = [NSString stringWithFormat:@"generate attrname %zd", arc4random_uniform(1000000)];
    
    return model;
}

- (NSString *)primaryKey
{
    return @"e_id";
}

- (Class)mapEntityClass
{
    return [PWDExtraInfoEntity class];
}

- (NSString *)description
{
    NSMutableString *desc = [[NSMutableString alloc] init];
    
    [desc appendFormat:@"e_id : %@\n", self.e_id];
    [desc appendFormat:@"e_type : %@\n", @(self.e_type)];
    [desc appendFormat:@"e_value : %@\n", self.e_value];
    [desc appendFormat:@"e_synced : %@\n", @(self.e_synced)];
    [desc appendFormat:@"e_attrname : %@\n", self.e_attrname];
    
    return desc;
}

@end
