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
    
    
    
//    AUUDebugLog(@"%@", [AUUBaseRecordsCenter generateUniqueIdentifier]);
    
//    [[AUUBaseRecordsCenter shareCenter] assignTest];
    
//    [self test];
}

- (void)test
{
    unsigned int properties_count = 0;
    
    objc_property_t *property_ptr = class_copyPropertyList([PWDGroupEntity class], &properties_count);
    
    for (unsigned int i = 0; i < properties_count; i ++)
    {
        objc_property_t property_t = property_ptr[i];
        
        const char *name = property_getName(property_t);
        
        const char *attribtues = property_getAttributes(property_t);
        
        NSLog(@"%@ %@", [NSString stringWithCString:name encoding:NSUTF8StringEncoding], [NSString stringWithCString:attribtues encoding:NSUTF8StringEncoding]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
