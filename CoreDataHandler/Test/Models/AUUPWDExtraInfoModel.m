//
//  AUUPWDExtraInfoModel.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUPWDExtraInfoModel.h"

@implementation AUUPWDExtraInfoModel

- (void)assignToEntity:(PWDExtraInfoEntity *)entity withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    entity.e_id = self.e_id;
    entity.e_type = @(self.e_type);
    entity.e_value = self.e_value;
    entity.e_synced = @(self.e_synced);
    entity.e_attrname = self.e_attrname;
}

+ (id)generate
{
    AUUPWDExtraInfoModel *model = [[AUUPWDExtraInfoModel alloc] init];
    
    model.e_id = [AUUBaseRecordsCenter generateUniqueIdentifier];
    model.e_type = arc4random_uniform(10);
    model.e_value = [NSString stringWithFormat:@"generate value %zd", arc4random_uniform(100000)];
    model.e_synced = arc4random_uniform(2);
    model.e_attrname = [NSString stringWithFormat:@"generate attrname %zd", arc4random_uniform(1000000)];
    
    return model;
}

@end
