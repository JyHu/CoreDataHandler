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
#import "AUUBaseRecordsCenter.h"

@implementation AUUPWDDetailModel

- (void)assignToEntity:(PWDDetailEntity *)entity withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    entity.p_id = self.p_id;
    entity.p_pwd = self.p_pwd;
    entity.p_synced = @(self.p_synced);
    entity.p_account = self.p_account;
    entity.p_website = self.p_website;
    entity.p_visiable = @(self.p_visiable);
    entity.p_cellphone = self.p_cellphone;
    entity.p_visiable_count = @(self.p_visiable_count);
    
    
    PWDManagerEntity *mangerEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDManagerEntity class]) inManagedObjectContext:managedObjectContext];
    [self.manager_ship assignToEntity:mangerEntity withManagedObjectContext:managedObjectContext];
    entity.manager_ship = mangerEntity;
    
    NSMutableSet *hissets = [[NSMutableSet alloc] init];
    for (AUUPWDHistoryModel *hismodel in self.history_ship)
    {
        PWDHistoryEntity *hisEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDHistoryEntity class]) inManagedObjectContext:managedObjectContext];
        [hismodel assignToEntity:hisEntity withManagedObjectContext:managedObjectContext];
        [hissets addObject:hisEntity];
    }
    entity.history_ship = hissets;
    
    NSMutableSet *extsets = [[NSMutableSet alloc] init];
    for (AUUPWDExtraInfoModel *exmodel in self.extra_ship)
    {
        PWDExtraInfoEntity *extentity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDExtraInfoEntity class]) inManagedObjectContext:managedObjectContext];
        [exmodel assignToEntity:extentity withManagedObjectContext:managedObjectContext];
        [extsets addObject:extentity];
    }
    entity.extra_ship = extsets;
}

+ (id)generate
{
    AUUPWDDetailModel *model = [[self alloc] init];
    model.p_id = [AUUBaseRecordsCenter generateUniqueIdentifier];
    model.p_pwd = [AUUBaseRecordsCenter generateUniqueIdentifier];
    model.p_synced = arc4random_uniform(2);
    model.p_account = [AUUBaseRecordsCenter generateUniqueIdentifier];
    model.p_website = [NSString stringWithFormat:@"www.%zd.com", arc4random_uniform(10000000)];
    model.p_visiable = arc4random_uniform(2);
    model.p_cellphone = [NSString stringWithFormat:@"133%zd", arc4random_uniform(100000000)];
    model.p_visiable_count = arc4random_uniform(100);
    
    NSMutableArray *hisarray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < arc4random_uniform(5); i ++)
    {
        [hisarray addObject:[AUUPWDHistoryModel generate]];
    }
    model.history_ship = hisarray;
    
    NSMutableArray *extARr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < arc4random_uniform(5); i ++)
    {
        [extARr addObject:[AUUPWDExtraInfoModel generate]];
    }
    model.extra_ship = extARr;
    
    model.manager_ship = [AUUPWDManagerModel generate];
    
    return model;
}

@end
