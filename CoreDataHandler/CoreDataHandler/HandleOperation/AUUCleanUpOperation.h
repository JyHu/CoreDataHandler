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

@end
