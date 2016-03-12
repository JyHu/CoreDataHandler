//
//  AUUPWDHistoryModel.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUPWDHistoryModel.h"

@implementation AUUPWDHistoryModel

- (void)assignToEntity:(PWDHistoryEntity *)entity withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    entity.h_id = self.h_id;
    entity.h_pwd = self.h_pwd;
    entity.h_date = self.h_date;
    entity.h_synced = @(self.h_synced);
}

+ (id)generate
{
    AUUPWDHistoryModel *model = [[AUUPWDHistoryModel alloc] init];
    
    model.h_id = [AUUBaseRecordsCenter generateUniqueIdentifier];
    model.h_pwd = [AUUBaseRecordsCenter generateUniqueIdentifier];
    model.h_date = [[NSDate date] dateByAddingTimeInterval:-1 * arc4random_uniform(1000000)];
    model.h_synced = arc4random_uniform(2);
    
    return model;
}

@end
