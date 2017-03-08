//
//  AUUFetchAllGroupOperation.h
//  CoreDataOperate
//
//  Created by JyHu on 2017/3/8.
//
//

#import <CoreDataHandler/CoreDataHandler.h>

@interface AUUFetchAllGroupOperation : AUUFetchAllOperation

- (void)fetchAllGroupsWithCompletion:(void (^)(NSArray *entities))completion;

@end
