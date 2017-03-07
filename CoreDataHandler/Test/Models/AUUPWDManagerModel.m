//
//  AUUPWDManagerModel.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUPWDManagerModel.h"
#import "NSObject+AUUHelper.h"

@implementation AUUPWDManagerModel

+ (id)generate
{
    AUUPWDManagerModel *model = [[AUUPWDManagerModel alloc] init];
    
    model.m_id = [AUUBaseRecordsCenter generateUUIDString];
    model.m_synced = arc4random_uniform(2);
    model.m_uploaded = arc4random_uniform(2);
    model.m_visiable = arc4random_uniform(2);
    
    return model;
}

- (NSString *)primaryKey
{
    return @"m_id";
}

- (Class)mapEntityClass
{
    return [PWDManagerEntity class];
}

- (NSString *)description
{
    NSMutableString *desc = [[NSMutableString alloc] init];
    
    [desc appendFormat:@"m_id : %@\n", self.m_id];
    [desc appendFormat:@"m_synced : %@\n", @(self.m_synced)];
    [desc appendFormat:@"m_uploaded : %@\n", @(self.m_uploaded)];
    [desc appendFormat:@"m_visiable : %@\n", @(self.m_visiable)];
    
    return desc;
}

@end
