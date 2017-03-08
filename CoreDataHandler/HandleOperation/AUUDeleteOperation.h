//
//  AUUDeleteOperation.h
//  CoreDataOperate
//
//  Created by JyHu on 2017/3/7.
//
//

#import <CoreDataHandler/CoreDataHandler.h>

@interface AUUDeleteOperation : AUUBaseHandleOperation

- (void)deleteobjectWithModel:(id)model;
- (void)deleteobjectWithModel:(id)model completion:(void (^)(BOOL successed))completion;

- (void)deleteobjectWithModels:(NSArray *)models;
- (void)deleteobjectWithModels:(NSArray *)models completion:(void (^)(BOOL successed))completion;

- (void)deleteobjectWithModel:(id)model forEntityClass:(Class)cls primaryKey:(NSString *)priKey;
- (void)deleteobjectWithModel:(id)model forEntityClass:(Class)cls primaryKey:(NSString *)priKey completion:(void (^)(BOOL successed))completion;

- (void)deleteobjectWithModels:(NSArray *)models forEntityClass:(Class)cls primaryKey:(NSString *)priKey;
- (void)deleteobjectWithModels:(NSArray *)models forEntityClass:(Class)cls primaryKey:(NSString *)priKey completion:(void (^)(BOOL successed))completion;


/**
 删除数据时的异步操作

 @param models 当前要删除的数据
 @param exitStatus 控制线程退出的状态
 @param error 错误信息
 */
- (void)asyncHandleWithModels:(NSArray *)models exitStatus:(BOOL *)exitStatus deleteError:(NSError *)error;

@end
