//
//  AUUPWDGroupModel.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUPWDGroupModel.h"
#import "AUUPWDDetailModel.h"
#import "PWDDetailEntity.h"

@implementation AUUPWDGroupModel

- (void)assignToEntity:(PWDGroupEntity *)entity withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    entity.g_id = self.g_id;
    entity.g_name = self.g_name;
    entity.g_date = self.g_date;
    entity.g_synced = @(self.g_synced);
    
    NSMutableSet *pwdsets = [[NSMutableSet alloc] init];
    for (AUUPWDDetailModel *pwdmodel in self.passwords_ship)
    {
        PWDDetailEntity *detailEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDDetailEntity class]) inManagedObjectContext:managedObjectContext];
        [pwdmodel assignToEntity:detailEntity withManagedObjectContext:managedObjectContext];
        [pwdsets addObject:detailEntity];
    }
    entity.passwords_ship = pwdsets;
    
}

+ (id)generate
{
    AUUPWDGroupModel *model = [[AUUPWDGroupModel alloc] init];
    
    model.g_id = [AUUBaseRecordsCenter generateUniqueIdentifier];
    model.g_name = [NSString stringWithFormat:@"group name %zd", arc4random_uniform(100000)];
    model.g_date = [[NSDate date] dateByAddingTimeInterval:-1 * arc4random_uniform(100000000)];
    model.g_synced = arc4random_uniform(2);
    
    NSMutableArray *arr  = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < arc4random_uniform(10); i ++)
    {
        [arr addObject:[AUUPWDDetailModel generate]];
    }
    model.passwords_ship = arr;
    
    return model;
}

@end
