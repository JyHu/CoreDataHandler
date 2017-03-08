//
//  AUUBaseRecordsCenter.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AUUBaseHandleOperation;

@interface AUUBaseRecordsCenter : NSObject <NSFetchedResultsControllerDelegate>

/**
 *  @author JyHu, 16-03-10 23:03:11
 *
 *  单利类，返回一个Coredata的管理中心
 *
 *  @return self
 *
 *  @since 1.0
 */
+ (AUUBaseRecordsCenter *)shareCenter;

/**
 留给外部的一些初始化操作
 */
- (void)initlization;

/**
 *  @author JyHu, 16-03-10 23:03:55
 *
 *  设置Coredata存储时的sqlite的名字
 *
 *  @since 1.0
 */
@property (copy, nonatomic) NSString *sqliteName;

/**
 *  @author JyHu, 16-03-10 23:03:17
 *
 *  Coredata数据存储有变动的时候，将是否通知变动的状态值推到队列中
 *
 *  @param flag 是否发送数据变动的通知
 *
 *  @since 1.0
 */
- (void)pushFlag2Queue:(BOOL)flag;

/**
 *  @author JyHu, 16-03-10 23:03:06
 *
 *  状态回滚
 *
 *  @since 1.0
 */
- (void)rollbackFlagQueue;

/**
 *  @author JyHu, 16-03-10 23:03:16
 *
 *  最近的一次数据变动的时间
 *
 *  @since 1.0
 */
@property (retain, nonatomic, readonly) NSDate *lastModifiedDate;

/**
 *  @author JyHu, 16-03-10 23:03:30
 *
 *  数据持久化存储助理
 *
 *  @since 1.0
 */
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 *  @author JyHu, 16-03-10 23:03:43
 *
 *  将操作数据变动的operation放入线程池
 *
 *  @param operation 数据操作的线程
 *
 *  @since 1.0
 */
- (void)enQueueRecordOperation:(AUUBaseHandleOperation *)operation;

/**
 OperationQueue中最大并行的线程数，默认是1
 */
@property (assign, nonatomic) NSUInteger maxConcurrentOperationCount;

@end

/**
 *  @author JyHu, 16-03-10 23:03:55
 *
 *  数据变动时的通知
 *
 *  @since 1.0
 */
extern NSString *const AUURecordDidChangedNotification;
extern NSString *const AUUFetchAllRecordsNotification;









