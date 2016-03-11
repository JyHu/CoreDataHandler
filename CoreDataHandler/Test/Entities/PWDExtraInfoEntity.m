//
//  PWDExtraInfoEntity.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "PWDExtraInfoEntity.h"
#import "PWDDetailEntity.h"
#import "AUUPWDExtraInfoModel.h"

@implementation PWDExtraInfoEntity

// Insert code here to add functionality to your managed object subclass

- (id)assignToModel
{
    return [self assignToModelWithClass:[AUUPWDExtraInfoModel class]];
}

@end
