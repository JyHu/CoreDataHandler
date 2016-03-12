//
//  AUUBaseRecordsCenter+Test.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUBaseRecordsCenter+Test.h"


#import "AUUPWDGroupModel.h"
#import "AUUPWDDetailModel.h"


#import "PWDDetailEntity.h"
#import "PWDGroupEntity.h"
#import "PWDExtraInfoEntity.h"
#import "PWDHistoryEntity.h"
#import "PWDManagerEntity.h"

@implementation AUUBaseRecordsCenter (Test)

- (void)insertGroup:(AUUPWDGroupModel *)groupModel
{
    AUUInsertOrUpdateOperation *operation = [[AUUInsertOrUpdateOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator model:groupModel completion:^(BOOL successed) {
        
    }];
    [operation insertOrUpdateWithEntityClass:[PWDGroupEntity class] sortedKey:@"g_id" modelConvertBlock:^(id oriModel, id object, NSManagedObjectContext *managedObjectContext) {
        [oriModel assignToEntity:object withManagedObjectContext:managedObjectContext];
    }];
    operation.needCompletionNotification = YES;
    operation.primeKey = @"g_id";
    operation.primeValueGenerateBlock = ^(id primeKey){
        return [NSString stringWithFormat:@"%@ %zd", primeKey, arc4random_uniform(10000000)];
    };
    [self enQueueRecordOperation:operation];
}

- (void)fetchAllGroup
{
    AUUFetchAllOperation *operation = [[AUUFetchAllOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator];
    [operation fetchAllWithEnityClass:[PWDGroupEntity class] sortedKey:@"g_id" entitiesConvert:^(NSArray *entities) {
        NSMutableArray *modelsArray = [entities convertEntitiesToModels];
        NSLog(@"%@", modelsArray);
    }];
    [self enQueueRecordOperation:operation];
}

- (void)cleanupGroup
{
    AUUCleanUpOperation *operation = [[AUUCleanUpOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator];
    [operation cleanupWithEnityClass:[PWDGroupEntity class] sortedKey:@"g_id" completion:^{
        
    }];
    [self enQueueRecordOperation:operation];
}

- (void)cleanupDetails
{
    AUUCleanUpOperation *operation = [[AUUCleanUpOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator];
    [operation cleanupWithEnityClass:[PWDDetailEntity class] sortedKey:@"p_id" completion:^{
        
    }];
    [self enQueueRecordOperation:operation];
}

- (void)fetchAllDetails
{
    AUUFetchAllOperation *operation = [[AUUFetchAllOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator];
    [operation fetchAllWithEnityClass:[PWDDetailEntity class] sortedKey:@"p_id" entitiesConvert:^(NSArray *entities) {
        NSMutableArray *modelsArray = [entities convertEntitiesToModels];
        NSLog(@"%@", modelsArray);
    }];
    [self enQueueRecordOperation:operation];
}

- (void)assignTest
{
    NSManagedObjectContext *contxt = [[AUUBaseHandleOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator].managedObjectContext;
    PWDGroupEntity *groupEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDGroupEntity class]) inManagedObjectContext:contxt];
    
    groupEntity.g_id = @"test gid";
    groupEntity.g_date = [NSDate date];
    groupEntity.g_name = @"group name";
    groupEntity.g_synced = @(YES);
    
    NSMutableSet *pwsset = [[NSMutableSet alloc] init];
    for (NSInteger i = 0; i < 3; i ++)
    {
        PWDDetailEntity *detailEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDDetailEntity class]) inManagedObjectContext:contxt];
        detailEntity.p_pwd = @"galadlfadll";
        detailEntity.p_id = [NSString stringWithFormat:@"password id %zd", i];
        detailEntity.p_synced = @(arc4random_uniform(2));
        detailEntity.p_account = [NSString stringWithFormat:@"account %zd", i];
        detailEntity.p_website = [NSString stringWithFormat:@"www.%zd.com", arc4random_uniform(100000000)];
        detailEntity.p_visiable = @(arc4random_uniform(2));
        detailEntity.p_cellphone = [NSString stringWithFormat:@"133%zd", arc4random_uniform(10000000)];
        detailEntity.p_visiable_count = @(arc4random_uniform(1000));
        
        NSMutableSet *historyArr = [[NSMutableSet alloc] init];
        for (NSInteger j = 0; j < arc4random_uniform(5) + 1; j ++)
        {
            PWDHistoryEntity *historyEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDHistoryEntity class]) inManagedObjectContext:contxt];
            historyEntity.h_id = [NSString stringWithFormat:@"hid%zd", arc4random_uniform(100000000)];
            historyEntity.h_pwd = [NSString stringWithFormat:@"history pwd : %zd", arc4random_uniform(10000000)];
            historyEntity.h_date = [[NSDate date] dateByAddingTimeInterval:-1 * arc4random_uniform(100000000)];
            historyEntity.h_synced = @(arc4random_uniform(2));
            
            [historyArr addObject:historyEntity];
        }
        detailEntity.history_ship = historyArr;
        
        NSMutableSet *extraSet = [[NSMutableSet alloc] init];
        for (NSInteger k = 0; k < arc4random_uniform(5); k ++)
        {
            PWDExtraInfoEntity *extraEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDExtraInfoEntity class]) inManagedObjectContext:contxt];
            
            extraEntity.e_id = [NSString stringWithFormat:@"%zd", arc4random_uniform(100000000)];
            extraEntity.e_type = @(arc4random_uniform(10));
            extraEntity.e_value = @"extra value";
            extraEntity.e_synced = @(arc4random_uniform(2));
            extraEntity.e_attrname = [NSString stringWithFormat:@"%zd", arc4random_uniform(100000000)];
            [extraSet addObject:extraEntity];
        }
        detailEntity.extra_ship = extraSet;
        
        
        PWDManagerEntity *managerEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDManagerEntity class]) inManagedObjectContext:contxt];
        managerEntity.m_id = [NSString stringWithFormat:@"manager id : %zd", arc4random_uniform(100000000)];
        managerEntity.m_synced = @(arc4random_uniform(2));
        managerEntity.m_uploaded = @(arc4random_uniform(2));
        managerEntity.m_visiable = @(arc4random_uniform(2));
        detailEntity.manager_ship = managerEntity;
        
        
        [pwsset addObject:detailEntity];
    }
    groupEntity.passwords_ship = pwsset;
    
    
    AUUPWDGroupModel *groupModel = [groupEntity assignToModel];
    
    AUUDebugLog(@"%@", groupModel);
}

@end
