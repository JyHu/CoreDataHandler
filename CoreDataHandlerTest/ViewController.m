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
#import "AUUBaseRecordsCenter+Test.h"
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
    
    [AUUBaseRecordsCenter shareCenter].sqliteName = @"PasswordsData";
    
    AUUPWDGroupModel *groupModel = [AUUPWDGroupModel generate];
    
    [[AUUBaseRecordsCenter shareCenter] fetchAllGroup];
    
    [[AUUBaseRecordsCenter shareCenter] fetchAllDetails];
    
    [[AUUBaseRecordsCenter shareCenter] insertGroup:groupModel];
    
    [[AUUBaseRecordsCenter shareCenter] fetchAllGroup];
    
    [[AUUBaseRecordsCenter shareCenter] fetchAllDetails];
    
    [[AUUBaseRecordsCenter shareCenter] cleanupGroup];
    
    [[AUUBaseRecordsCenter shareCenter] fetchAllGroup];
    
    [[AUUBaseRecordsCenter shareCenter] fetchAllDetails];
    
    [[AUUBaseRecordsCenter shareCenter] cleanupDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
