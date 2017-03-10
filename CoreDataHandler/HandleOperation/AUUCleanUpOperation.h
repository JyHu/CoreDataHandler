//
//  AUUCleanUpOperation.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUBaseHandleOperation.h"

/**
 *  @author JyHu, 16-03-11 17:03:44
 *
 *  清空数据的线程
 *
 *  @since v1.0
 */
@interface AUUCleanUpOperation : AUUBaseHandleOperation

/**
 *  @author JyHu, 16-03-11 17:03:52
 *
 *  清空数据时要设置的一些参数
 *
 *  @param cls        要清空的Entity的class
 *  @param skey       排序的key
 *  @param completion 清空结束的回调block
 *
 *  @since v1.0
 */
- (void)cleanupWithEnityClass:(Class)cls sortedKey:(NSString *)skey
                   completion:(void (^)(void))completion;
- (void)cleanupWithEnityClass:(Class)cls sortedKey:(NSString *)skey;

/**
 异步线程的操作，允许外部在清理之前做一些操作

 @param entities 即将要清理掉的数据
 @param exitStatus 是否退出外部异步线程
 @param error 错误
 */
- (void)asyncHandleWithEntities:(NSMutableArray *)entities exitStatus:(BOOL *)exitStatus cleanUpError:(NSError *)error;

@end
