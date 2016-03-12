//
//  AUUBaseRecordsCenter+Test.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUBaseRecordsCenter.h"

@class AUUPWDGroupModel;

@interface AUUBaseRecordsCenter (Test)

- (void)insertGroup:(AUUPWDGroupModel *)groupModel;

- (void)fetchAllGroup;

- (void)assignTest;

- (void)cleanupGroup;

- (void)fetchAllDetails;

- (void)cleanupDetails;

@end
