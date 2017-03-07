//
//  PWDGroupEntity.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "PWDGroupEntity.h"
#import "PWDDetailEntity.h"
#import "AUUPWDGroupModel.h"

@implementation PWDGroupEntity

- (Class)mapModelClass
{
    return [AUUPWDGroupModel class];
}

@end
