//
//  PWDDetailEntity.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "PWDDetailEntity.h"
#import "PWDHistoryEntity.h"
#import "PWDManagerEntity.h"
#import "AUUPWDDetailModel.h"

@implementation PWDDetailEntity

- (Class)mapModelClass
{
    return [AUUPWDDetailModel class];
}

@end
