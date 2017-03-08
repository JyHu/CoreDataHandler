//
//  AUUBaseRecordsCenter+Test.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUBaseRecordsCenter+Test.h"
#import "NSObject+AUUHelper.h"

#import "AUUPWDGroupModel.h"
#import "AUUPWDDetailModel.h"


#import "PWDDetailEntity.h"
#import "PWDGroupEntity.h"
#import "PWDExtraInfoEntity.h"
#import "PWDHistoryEntity.h"
#import "PWDManagerEntity.h"

#import "CoreDataHandler.h"

#import "AUUGroupInsertUpdateOperation.h"
#import "AUUFetchAllGroupOperation.h"

#import "NSManagedObject+AUUHelper.h"

@implementation AUUBaseRecordsCenter (Test)

- (void)insertGroup:(AUUPWDGroupModel *)groupModel
{
    AUUGroupInsertUpdateOperation *operation = [[AUUGroupInsertUpdateOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator];
    [operation insertGroup:groupModel];
    [self enQueueRecordOperation:operation];
}

- (void)fetchAllGroup
{
    AUUFetchAllGroupOperation *operation = [[AUUFetchAllGroupOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator];
    [operation fetchAllGroupsWithCompletion:^(NSArray *entities) {
        NSLog(@"%@", entities);
    }];
//    AUUFetchAllOperation *operation = [[AUUFetchAllOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator];
//    [operation fetchAllWithEnityClass:[PWDGroupEntity class] sortedKey:@"g_id" fetchedEntities:^(NSArray *entities) {
//        NSLog(@"%@", [[entities firstObject] description]);
//        
//        AUUPWDGroupModel *groupModel = [[entities firstObject] assignToModel];
//        
//        for (AUUPWDDetailModel *detailModel in groupModel.passwords_ship)
//        {
//            NSLog(@"%@ %@", NSStringFromClass([detailModel class]), detailModel);
//        }
//        
//        AUUDeleteOperation *deleteOperation = [[AUUDeleteOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator];
//        [deleteOperation deleteobjectWithModel:groupModel completion:^(BOOL successed) {
//            NSLog(@"delete object %@", successed ? @"yes" : @"no");
//        }];
//        [[AUUBaseRecordsCenter shareCenter] enQueueRecordOperation:deleteOperation];
//        
//        NSLog(@"----");
//    }];
    [self enQueueRecordOperation:operation];
}

- (void)cleanupGroup
{
    AUUCleanUpOperation *operation = [[AUUCleanUpOperation alloc] initWithSharedPSC:self.persistentStoreCoordinator];
    [operation cleanupWithEnityClass:[PWDGroupEntity class] sortedKey:@"g_id"];
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
    [operation fetchAllWithEnityClass:[PWDDetailEntity class] sortedKey:@"p_id" fetchedEntities:^(NSArray *entities) {
        NSArray *modelsArray = [entities convertEntitiesToModels];
        NSLog(@"%@", modelsArray);
    }];
    [self enQueueRecordOperation:operation];
}

@end
