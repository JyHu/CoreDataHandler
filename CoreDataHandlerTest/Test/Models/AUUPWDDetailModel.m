//
//  AUUPWDDetailModel.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUPWDDetailModel.h"
#import "PWDManagerEntity.h"
#import "PWDHistoryEntity.h"
#import "AUUPWDHistoryModel.h"
#import "AUUPWDExtraInfoModel.h"
#import "PWDExtraInfoEntity.h"
#import "CoreDataHandler.h"

@implementation AUUPWDDetailModel

+ (id)generate
{
    AUUPWDDetailModel *model = [[self alloc] init];
    model.p_id = [AUUBaseRecordsCenter generateUUIDString];
    model.p_pwd = [AUUBaseRecordsCenter generateUUIDString];
    model.p_synced = arc4random_uniform(2);
    model.p_account = [AUUBaseRecordsCenter generateUUIDString];
    model.p_website = [NSString stringWithFormat:@"www.%zd.com", arc4random_uniform(10000000)];
    model.p_visiable = arc4random_uniform(2);
    model.p_cellphone = [NSString stringWithFormat:@"133%zd", arc4random_uniform(100000000)];
    model.p_visiable_count = arc4random_uniform(100);
    
    NSMutableArray *hisarray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < arc4random_uniform(5) + 10; i ++)
    {
        [hisarray addObject:[AUUPWDHistoryModel generate]];
    }
    model.history_ship = hisarray;
    
    NSMutableArray *extARr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < arc4random_uniform(5) + 10; i ++)
    {
        [extARr addObject:[AUUPWDExtraInfoModel generate]];
    }
    model.extra_ship = extARr;
    
    model.manager_ship = [AUUPWDManagerModel generate];
    
    return model;
}

- (NSString *)primaryKey
{
    return @"p_id";
}

- (Class)mapEntityClass
{
    return [PWDDetailEntity class];
}

- (NSString *)description
{
    NSMutableString *desc = [[NSMutableString alloc] init];
    [desc appendFormat:@"p_id : %@\n", self.p_id];
    [desc appendFormat:@"p_pwd : %@\n", self.p_pwd];
    [desc appendFormat:@"p_synced : %@\n", @(self.p_synced)];
    [desc appendFormat:@"p_account : %@\n", self.p_account];
    [desc appendFormat:@"p_website : %@\n", self.p_website];
    [desc appendFormat:@"p_visiable : %@\n", @(self.p_visiable)];
    [desc appendFormat:@"p_cellphhone : %@\n", self.p_cellphone];
    [desc appendFormat:@"p_visiable_count : %@\n", @(self.p_visiable_count)];
    
    for (AUUPWDHistoryModel *model in self.history_ship)
    {
        [desc appendFormat:@"history_ship :\n"];
        [desc appendFormat:@"     %@\n", [model description]];
    }
    for (AUUPWDExtraInfoModel *model in self.extra_ship)
    {
        [desc appendFormat:@"extra_ship : \n"];
        [desc appendFormat:@"     %@", [model description]];
    }
    [desc appendFormat:@"manager_ship : \n"];
    [desc appendFormat:@"     %@\n", [self.manager_ship description]];
    
    return desc;
}

@end
