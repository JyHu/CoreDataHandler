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

// Insert code here to add functionality to your managed object subclass

- (id)assignToModel
{
    return [self assignToModelWithClass:[AUUPWDGroupModel class]];
}

@end
