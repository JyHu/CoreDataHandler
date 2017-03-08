//
//  AUUFetchAllGroupOperation.m
//  CoreDataOperate
//
//  Created by JyHu on 2017/3/8.
//
//

#import "AUUFetchAllGroupOperation.h"
#import "PWDGroupEntity.h"

@implementation AUUFetchAllGroupOperation

- (void)fetchAllGroupsWithCompletion:(void (^)(NSArray *))completion
{
    [self fetchAllWithEnityClass:[PWDGroupEntity class] sortedKey:@"g_id" fetchedEntities:completion];
}

- (void)asyncHandleWithEntities:(NSArray *)entities exitStatus:(BOOL *)exitStatus fetchError:(NSError *)error
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", entities);
        *exitStatus = YES;
    });
}

@end
