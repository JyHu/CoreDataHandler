//
//  AUUBaseRecordsCenter.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUBaseRecordsCenter.h"
#import "AUUBaseHandleOperation.h"
#import <deque>
#import "AUUMacros.h"

using namespace std;
typedef deque<BOOL> FlagQueue;

@interface AUUBaseRecordsCenter()

@property (nonatomic, strong, readonly) NSManagedObjectModel        *auu_managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext      *auu_managedObjectContext;
@property (nonatomic, strong)           NSFetchedResultsController  *auu_fetchedResultsController;

@property (nonatomic, strong)   NSOperationQueue    *operationQueue;
@property (assign, atomic)      FlagQueue           *mFlagQueue;
@property (retain, nonatomic)   NSDate              *auu_lastModifiedDate;

@end

@implementation AUUBaseRecordsCenter

@synthesize auu_managedObjectModel          = _auu_managedObjectModel;
@synthesize auu_managedObjectContext        = _auu_managedObjectContext;
@synthesize auu_fetchedResultsController    = _auu_fetchedResultsController;
@synthesize operationQueue                  = _operationQueue;
@synthesize mFlagQueue                      = _mFlagQueue;
@synthesize auu_lastModifiedDate            = _auu_lastModifiedDate;
@synthesize persistentStoreCoordinator      = _persistentStoreCoordinator;

+ (AUUBaseRecordsCenter *)shareCenter
{
    static AUUBaseRecordsCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[AUUBaseRecordsCenter alloc] init];
    });
    return center;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // 初始化状态队列
        self.mFlagQueue = new FlagQueue();
        self.maxConcurrentOperationCount = 1;
        [self initlization];
    }
    
    return self;
}

- (void)initlization
{
    
}

#pragma mark - Core data handler

- (NSManagedObjectContext *)auu_managedObjectContext
{
    if (_auu_managedObjectContext != nil)
    {
        return _auu_managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (!coordinator)
    {
        return nil;
    }
    
    _auu_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_auu_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mergeChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
    
    return _auu_managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    NSAssert(self.sqliteName && [self.sqliteName isKindOfClass:[NSString class]], @"没有设置sqlite的名字");
    
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self auu_managedObjectModel]];
    
    NSString *sqliteName = [NSString stringWithFormat:@"%@.sqlite", self.sqliteName];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:sqliteName];
    
    AUUDebugLog(@"本地的sqlite路径：%@", storeURL);
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : [NSNumber numberWithBool:YES],
                              NSInferMappingModelAutomaticallyOption : [NSNumber numberWithBool:YES],
                              NSPersistentStoreFileProtectionKey : NSFileProtectionNone
                             };
    NSError *error;
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil URL:storeURL
                                                         options:options error:&error])
    {
        AUUDebugLog(@"获取数据持久层失败%@", error);
        
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)auu_managedObjectModel
{
    if (!_auu_managedObjectModel)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.sqliteName withExtension:@"momd"];
        _auu_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _auu_managedObjectModel;
}

#pragma mark - Managed methods 

- (void)pushFlag2Queue:(BOOL)flag
{
    self.mFlagQueue -> push_back(flag);
}

- (void)rollbackFlagQueue
{
    self.mFlagQueue -> pop_back();
}

- (void)mergeChanges:(NSNotification *)notify
{
    if (notify.object != self.auu_managedObjectContext)
    {
        [self performSelectorOnMainThread:@selector(updateMainContext:)
                               withObject:notify waitUntilDone:NO];
    }
}

- (void)updateMainContext:(NSNotification *)notify
{
    AUUDebugLog(@"Come to merge the changes of the another context .");
    
    NSAssert([NSThread mainThread], @"更新数据持久层不是在主线程");
    
    [self.auu_managedObjectContext mergeChangesFromContextDidSaveNotification:notify];
    
    self.auu_lastModifiedDate = [NSDate date];
    
    if (self.mFlagQueue -> front())
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:AUURecordDidChangedNotification
                                                            object:nil];
        
        AUUDebugLog(@"已在主线程中发送数据变动的通知");
    }
    
    self.mFlagQueue -> pop_front();
}

#pragma mark - Operation handler

- (void)enQueueRecordOperation:(AUUBaseHandleOperation *)operation
{
    [self.operationQueue addOperation:operation];
    
    AUUDebugLog(@"Current operation count %@", @([self.operationQueue operationCount]));
}

- (void)setSqliteName:(NSString *)sqliteName
{
    if (sqliteName && [sqliteName isKindOfClass:[NSString class]] && sqliteName.length > 0)
    {
        _sqliteName = sqliteName;
        
        [self operationQueue];
        
        [self auu_managedObjectContext];
    }
}

#pragma mark - Getter and Setter

- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue)
    {
        _operationQueue = [[NSOperationQueue alloc] init];
        
        [_operationQueue setMaxConcurrentOperationCount:self.maxConcurrentOperationCount];
    }
    
    return _operationQueue;
}

- (NSDate *)lastModifiedDate
{
    return self.auu_lastModifiedDate;
}

- (void)setMaxConcurrentOperationCount:(NSUInteger)maxConcurrentOperationCount
{
    if (maxConcurrentOperationCount > 0)
    {
        _maxConcurrentOperationCount = maxConcurrentOperationCount;
        
        [self.operationQueue setMaxConcurrentOperationCount:maxConcurrentOperationCount];
    }
}

#pragma mark - Help methods

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

@end


NSString *const AUURecordDidChangedNotification = @"AUURecordDidChangedNotification";
NSString *const AUUFetchAllRecordsNotification = @"AUUFetchAllRecordsNotification";





