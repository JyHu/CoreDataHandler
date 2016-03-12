//
//  AUUInsertOrUpdateOperation.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUBaseHandleOperation.h"

/**
 *  @author JyHu, 16-03-11 17:03:26
 *
 *  数据转换的Block，将model中得数据转到Entity中
 *
 *  @param oriModel             原始的model
 *  @param object               要将数据转换到的Entity
 *  @param managedObjectContext 上下文
 *
 *  @warning    block中得操作是在异步线程中
 *
 *  @since v1.0
 */
typedef void (^AUUModelConvertBlock)(id oriModel,
                                     id object,
                                     NSManagedObjectContext * managedObjectContext);

/**
 *  @author JyHu, 16-03-11 17:03:34
 *
 *  用于做唯一判断查询的值，类似于sqlite中得主键
 *
 *  @param primeKey 主键
 *
 *  @return 自己根据自己定义的Entity设定的主键的值
 *
 *  @since v1.0
 */
typedef id (^AUUPrimeValueGenerateBlock)(id primeKey);

/**
 数据查询的operation
 */
@interface AUUInsertOrUpdateOperation : AUUBaseHandleOperation

/**
 *  @author JyHu, 16-03-11 17:03:18
 *
 *  初始化方法
 *
 *  @param psc         持久化存储助理
 *  @param modelsArray 要存储的数据（model）的数组
 *  @param completion  操作结束后的block回调
 *
 *  @return self
 *
 *  @since v1.0
 */
- (id)initWithSharedPSC:(NSPersistentStoreCoordinator *)psc
            modelsArray:(NSArray *)modelsArray
             completion:(void (^)(BOOL successed))completion;

/**
 *  @author JyHu, 16-03-11 17:03:35
 *
 *  初始化方法
 *
 *  @param psc        持久化存储助理
 *  @param model      要存储的数据模型（model）
 *  @param completion 操作结束后的blok回调
 *
 *  @return self
 *
 *  @since v1.0
 */
- (id)initWithSharedPSC:(NSPersistentStoreCoordinator *)psc
                  model:(id)model
             completion:(void (^)(BOOL successed))completion;

/**
 *  @author JyHu, 16-03-12 20:03:14
 *
 *  设置一些必要的参数
 *
 *  @param entityClass       要操作的Entity的Class
 *  @param sortedKey         用来对查询到的数据排序的key
 *  @param modelConvertBlock 数据转换用的block
 *
 *  @since v1.0
 */
- (void)insertOrUpdateWithEntityClass:(Class)entityClass
                            sortedKey:(NSString *)sortedKey
                    modelConvertBlock:(AUUModelConvertBlock)modelConvertBlock;

#pragma mark - 
#pragma mark - 以下的参数是非必须按的参数，是为了保持数据的唯一性，用于数据更新用
#pragma mark -

/**
 *  @author JyHu, 16-03-11 17:03:28
 *
 *  是否需要操作成功后的通知提醒，默认为NO
 *
 *  @since v1.0
 */
@property (assign, nonatomic) BOOL needCompletionNotification;

/**
 *  @author JyHu, 16-03-11 17:03:22
 *
 *  主键，如果设置了，就必须设置primeValueGenerateBlock这个block
 *
 *  @since v1.0
 */
@property (retain, nonatomic) NSString *primeKey;

/**
 *  @author JyHu, 16-03-11 17:03:51
 *
 *  设置的生成主键值的block
 *
 *  @since v1.0
 */
@property (copy, nonatomic) AUUPrimeValueGenerateBlock primeValueGenerateBlock;

@end
