//
//  AppDelegate.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AppDelegate.h"


#import "PWDGroupEntity.h"
#import "PWDDetailEntity.h"
#import "PWDHistoryEntity.h"
#import "PWDManagerEntity.h"
#import "PWDExtraInfoEntity.h"

#import "AUUPWDGroupModel.h"
#import "AUUPWDDetailModel.h"
#import "AUUPWDHistoryModel.h"
#import "AUUPWDExtraInfoModel.h"
#import "AUUPWDManagerModel.h"

@interface AppDelegate ()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    return YES;
}

- (void)insertCoreData
{
    AUUPWDGroupModel *groupModel = [AUUPWDGroupModel new];
    
    PWDGroupEntity *groupEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDGroupEntity class]) inManagedObjectContext:[self managedObjectContext]];
    groupEntity.g_id        = groupModel.g_id;
    groupEntity.g_date      = groupModel.g_date;
    groupEntity.g_name      = groupModel.g_name;
    groupEntity.g_synced    = @(groupModel.g_synced);
    
    NSMutableArray *detailArray = [[NSMutableArray alloc] init];
    for (AUUPWDDetailModel *detailModel in groupModel.passwords_ship)
    {
        PWDDetailEntity *detailEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDDetailEntity class]) inManagedObjectContext:[self managedObjectContext]];
        detailEntity.p_id               = detailModel.p_id;
        detailEntity.p_pwd              = detailModel.p_pwd;
        detailEntity.p_synced           = @(detailModel.p_synced);
        detailEntity.p_account          = detailModel.p_account;
        detailEntity.p_website          = detailModel.p_website;
        detailEntity.p_visiable         = @(detailModel.p_visiable);
        detailEntity.p_cellphone        = detailModel.p_cellphone;
        detailEntity.p_visiable_count   = @(detailModel.p_visiable_count);
        
        NSMutableArray *historiesArr = [[NSMutableArray alloc] init];
        for (AUUPWDHistoryModel *hisModel in detailModel.history_ship)
        {
            PWDHistoryEntity *hisEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDHistoryEntity class]) inManagedObjectContext:[self managedObjectContext]];
            hisEntity.h_id = hisModel.h_id;
            hisEntity.h_pwd = hisModel.h_pwd;
            hisEntity.h_date = hisModel.h_date;
            hisEntity.h_synced = @(hisModel.h_synced);
            [historiesArr addObject:hisEntity];
        }
        detailEntity.history_ship = [NSSet setWithArray:historiesArr];
        
        NSMutableArray *extArray = [[NSMutableArray alloc] init];
        for (AUUPWDExtraInfoModel *extModel in detailModel.extra_ship)
        {
            PWDExtraInfoEntity *extEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDExtraInfoEntity class]) inManagedObjectContext:[self managedObjectContext]];
            extEntity.e_id = extModel.e_id;
            extEntity.e_type = @(extModel.e_type);
            extEntity.e_value = extModel.e_value;
            extEntity.e_synced = @(extModel.e_synced);
            extEntity.e_attrname = extModel.e_attrname;
            [extArray addObject:extEntity];
        }
        detailEntity.extra_ship = [NSSet setWithArray:extArray];
        
        PWDManagerEntity *manEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PWDManagerEntity class]) inManagedObjectContext:[self managedObjectContext]];
        manEntity.m_id = detailModel.manager_ship.m_id;
        manEntity.m_synced = @(detailModel.manager_ship.m_synced);
        manEntity.m_uploaded = @(detailModel.manager_ship.m_synced);
        manEntity.m_visiable = @(detailModel.manager_ship.m_visiable);
        detailEntity.manager_ship = manEntity;
        
        [detailArray addObject:detailEntity];
    }
    
    NSError *error;
    if(![[self managedObjectContext] save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
}

- (void)dataFetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([PWDGroupEntity class])
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    for (PWDGroupEntity *groupEntity in fetchedObjects) {
        NSLog(@"%@", groupEntity.g_id);
        /*
         跟insert的数据映射类似，反过来，balabala一堆代码。
         */
    }
}

- (void)cleanup
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactInfo"
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in fetchObjects)
    {
        /*
         需要将其中一对多的所有属性都进行循环删除
         */
        [self.managedObjectContext deleteObject:obj];
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "JinyouHu.Temple" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Temple" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Temple.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
