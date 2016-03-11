//
//  PWDManagerEntity.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "PWDManagerEntity.h"
#import "AUUPWDManagerModel.h"

@implementation PWDManagerEntity

// Insert code here to add functionality to your managed object subclass

- (id)assignToModel
{
    return [self assignToModelWithClass:[AUUPWDManagerModel class]];
}

@end
