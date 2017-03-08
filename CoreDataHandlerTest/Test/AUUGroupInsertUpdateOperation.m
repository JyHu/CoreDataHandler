//
//  AUUGroupInsertUpdateOperation.m
//  CoreDataOperate
//
//  Created by JyHu on 2017/3/8.
//
//

#import "AUUGroupInsertUpdateOperation.h"

@interface AUUGroupInsertUpdateOperation()

@property (retain, nonatomic) AUUPWDGroupModel *groupModel;

@end

@implementation AUUGroupInsertUpdateOperation

- (void)insertGroup:(AUUPWDGroupModel *)groupModel
{
    self.sortedKey = @"g_id";
    self.groupModel = groupModel;
    [self insertOrUpdateObject:groupModel];
}

- (void)asyncHandleWithEntities:(NSArray *)entities exitStatus:(BOOL *)exitStatus insertOrUpdateError:(NSError *)error
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", entities);
        *exitStatus = YES;
    });
}

@end
