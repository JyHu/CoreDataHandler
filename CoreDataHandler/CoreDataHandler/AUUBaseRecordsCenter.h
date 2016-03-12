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
 *  事务回滚
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
 *  <#Description#>
 *
 *  @since <#1.0#>
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
 *  @author JyHu, 16-03-12 12:03:44
 *
 *  生成一个32位随机的字符串
 *
 *      eg : 965DD1C9-7C75-466F-9D3B-681F96440A57
 *
 *  @return NSString
 *
 *  @since v1.0
 */
+ (NSString *)generateUniqueIdentifier;

@end

/**
 *  @author JyHu, 16-03-10 23:03:55
 *
 *  数据变动时的通知
 *
 *  @since 1.0
 */
extern NSString *const AUURecordDidChangedNotification;










