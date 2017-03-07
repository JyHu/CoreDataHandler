//
//  AUUPWDGroupModel.h
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWDGroupEntity.h"
#import "AUUPWDDetailModel.h"

@class PWDDetailEntity;

@interface AUUPWDGroupModel : NSObject

@property (nullable, nonatomic, retain) NSDate *g_date;
@property (nullable, nonatomic, retain) NSString *g_id;
@property (nullable, nonatomic, retain) NSString *g_name;
@property (nonatomic, assign) BOOL g_synced;
@property (nullable, nonatomic, retain) NSArray <AUUPWDDetailModel *> *passwords_ship;

+ (nonnull id)generate;

@end
