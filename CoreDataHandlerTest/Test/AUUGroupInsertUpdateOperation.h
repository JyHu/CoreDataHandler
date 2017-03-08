//
//  AUUGroupInsertUpdateOperation.h
//  CoreDataOperate
//
//  Created by JyHu on 2017/3/8.
//
//

#import <CoreDataHandler/CoreDataHandler.h>
#import "AUUPWDGroupModel.h"

@interface AUUGroupInsertUpdateOperation : AUUInsertOrUpdateOperation

- (void)insertGroup:(AUUPWDGroupModel *)groupModel;

@end
