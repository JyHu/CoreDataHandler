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
    [self deleteobjectWithModels:@[model]];
}
- (void)deleteobjectWithModel:(id)model completion:(void (^)(BOOL successed))completion
{
    [self deleteobjectWithModels:@[model] completion:completion];
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
    [self deleteobjectWithModels:@[model] forEntityClass:cls primaryKey:priKey completion:completion];
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
            
            [self deleteObjects];
            
            [self saveChangesWithFlag:YES];
        }
    }
    
    if (self.completion)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completion(YES);
        });
    }
    
    AUUDebugFinishWithInfo(@"删除实体类%@数据的线程结束", self.entityClass);
}

@end
