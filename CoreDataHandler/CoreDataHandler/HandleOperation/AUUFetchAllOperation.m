//
//  AUUFetchAllOperation.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUFetchAllOperation.h"

@interface AUUFetchAllOperation()

@property (assign, nonatomic) Class entityClass;

@property (retain, nonatomic) NSString *sortedKey;

@property (copy, nonatomic) void (^convert)(NSArray *objs);

@end

@implementation AUUFetchAllOperation

- (void)fetchAllWithEnityClass:(Class)cls sortedKey:(NSString *)skey
                    objConvert:(void (^)(NSArray *))convert
{
    self.entityClass = cls;
    self.sortedKey = skey;
    self.convert = convert;
}

- (void)main
{
    AUUDebugLog(@"查询实体类%@所有数据的线程开始", self.entityClass);
    
    if ([self initVariableWithEntityClass:self.entityClass sortedKey:self.sortedKey])
    {
        [self fetchedResultsController];
        
        self.convert([[self fetchedResultsController] fetchedObjects]);
    }
    
    AUUDebugLog(@"查询实体类%@所有数据的线程结束", self.entityClass);
}

@end
