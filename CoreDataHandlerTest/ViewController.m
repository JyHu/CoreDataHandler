//
//  ViewController.m
//  CoreDataHandler
//
//  Created by 胡金友 on 16/3/10.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import <objc/runtime.h>
#import "AUUTestRecordsCenter.h"
#import "AUUInsertOrUpdateOperation.h"

#import "PWDGroupEntity.h"
#import "PWDDetailEntity.h"
#import "PWDManagerEntity.h"
#import "PWDHistoryEntity.h"
#import "PWDExtraInfoEntity.h"

#import "AUUPWDGroupModel.h"
#import "AUUPWDDetailModel.h"
#import "AUUPWDManagerModel.h"
#import "AUUPWDHistoryModel.h"
#import "AUUPWDExtraInfoModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [AUUTestRecordsCenter shareInstance].sqliteName = @"PasswordsData";
    
    [self test];
}

- (void)test
{
    AUUPWDGroupModel *groupModel = [AUUPWDGroupModel generate];
    
    [[AUUTestRecordsCenter shareInstance] fetchAllGroup];
    
    [[AUUTestRecordsCenter shareInstance] fetchAllDetails];
    
    [[AUUTestRecordsCenter shareInstance] insertGroup:groupModel];
    
    [[AUUTestRecordsCenter shareInstance] fetchAllGroup];
    
    [[AUUTestRecordsCenter shareInstance] fetchAllDetails];
    
    [[AUUTestRecordsCenter shareInstance] cleanupGroup];
    
    [[AUUTestRecordsCenter shareInstance] fetchAllGroup];
    
    [[AUUTestRecordsCenter shareInstance] fetchAllDetails];
    
    [[AUUTestRecordsCenter shareInstance] cleanupDetails];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
