//
//  AUUDeleteOperation.m
//  CoreDataOperate
//
//  Created by JyHu on 2017/3/7.
//
//

#import "AUUDeleteOperation.h"
#import "NSManagedObject+AUUHelper.h"

@interface AUUDeleteOperation()

@property (retain, nonatomic) NSArray *deletedModelsArr;

@property (retain, nonatomic) NSString *primaryKey;

@property (copy, nonatomic) void (^completion)(BOOL successed);

@property (assign, nonatomic) Class entityClass;

@end

@implementation AUUDeleteOperation

- (void)deleteobjectWithModel:(id)model
{
    [self deleteobjectWithModels: (model ? @[model] : nil)];
}
- (void)deleteobjectWithModel:(id)model completion:(void (^)(BOOL successed))completion
{
    [self deleteobjectWithModels: (model ? @[model] : nil) completion:completion];
}

- (void)deleteobjectWithModels:(NSArray *)models
{
    [self deleteobjectWithModels:models completion:nil];
}
- (void)deleteobjectWithModels:(NSArray *)models completion:(void (^)(BOOL successed))completion
{
    if (models && [models isKindOfClass:[NSArray class]] && models.count > 0)
    {
        [self deleteobjectWithModels:models forEntityClass:[[models firstObject] mapEntityClass] primaryKey:[[models firstObject] primaryKey] completion:completion];
    }
    else
    {
        [self deleteobjectWithModels:nil forEntityClass:nil primaryKey:nil completion:nil];
    }
}

- (void)deleteobjectWithModel:(id)model forEntityClass:(Class)cls primaryKey:(NSString *)priKey
{
    [self deleteobjectWithModel:model forEntityClass:cls primaryKey:priKey completion:nil];
}
- (void)deleteobjectWithModel:(id)model forEntityClass:(Class)cls primaryKey:(NSString *)priKey completion:(void (^)(BOOL successed))completion
{
    [self deleteobjectWithModels: (model ? @[model] : nil) forEntityClass:cls primaryKey:priKey completion:completion];
}

- (void)deleteobjectWithModels:(NSArray *)models forEntityClass:(Class)cls primaryKey:(NSString *)priKey
{
    [self deleteobjectWithModels:models forEntityClass:cls primaryKey:priKey completion:nil];
}
- (void)deleteobjectWithModels:(NSArray *)models forEntityClass:(Class)cls primaryKey:(NSString *)priKey completion:(void (^)(BOOL successed))completion
{
    self.deletedModelsArr = models;
    self.primaryKey = priKey;
    self.completion = completion;
    self.entityClass = cls;
}

- (void)deleteObjects
{
    for (id model in self.deletedModelsArr)
    {
        NSManagedObject *object = [self originalObjectWithPrimeValue:[model valueForKey:self.primaryKey] primaryKey:self.primaryKey];
        
        if (object)
        {
            [object cleanupWithManagedObjectContext:self.managedObjectContext];
        }
    }
}

- (id)originalObjectWithPrimeValue:(id)value primaryKey:(NSString *)primaryKey
{
    if (!primaryKey)
    {
        return nil;
    }
    
    for (id obj in [[self fetchedResultsController] fetchedObjects])
    {
        id oriPrimeKeyValue = [obj valueForKey:primaryKey];
        
        if ([oriPrimeKeyValue isEqual:value])
        {
            AUUDebugLog(@"在本地数据库中找到相应的实体对象，%@", obj);
            
            return obj;
        }
    }
    
    AUUDebugLog(@"在本地数据库中没有找到相对应的实体对象，primeKey=%@, value=%@", primaryKey, value);
    
    return nil;
}

- (void)main
{
    AUUDebugBeginWithInfo(@"删除实体类%@数据的线程开始", self.entityClass);
    
    
    
    if (self.deletedModelsArr && [self.deletedModelsArr isKindOfClass:[NSArray class]] && self.deletedModelsArr.count > 0)
    {
        Class cls = self.entityClass ?: [[self.deletedModelsArr firstObject] mapEntityClass];
        self.primaryKey = self.primaryKey ?: [[self.deletedModelsArr firstObject] primaryKey];
        if ([self initVariableWithEntityClass:cls sortedKey:self.primaryKey])
        {
            [self fetchedResultsController];
            [self asyncBlockWithError:nil];
            [self deleteObjects];
            [self saveChangesWithFlag:YES];
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:@{@"errorInfo" : @"初始化查询失败，请检查一下sortedKey和entityClass是否有效"}];
        
        [self asyncBlockWithError:error];
    }
    

    
    if (self.completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completion(YES);
        });
    }
    
    AUUDebugFinishWithInfo(@"删除实体类%@数据的线程结束", self.entityClass);
}

- (void)asyncBlockWithError:(NSError *)error
{
    BOOL exitStatus = NO;
    
    if ([self respondsToSelector:@selector(asyncHandleWithModels:exitStatus:deleteError:)]) {
        [self asyncHandleWithModels:self.deletedModelsArr exitStatus:&exitStatus deleteError:nil];
    } else if ([self respondsToSelector:@selector(asyncHandleWithExitStatus:error:)]) {
        [self asyncHandleWithExitStatus:&exitStatus error:nil];
    } else {
        exitStatus = YES;
    }
    
    while (!exitStatus) {
        [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
    }
}

@end
