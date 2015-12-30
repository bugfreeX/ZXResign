//
//  FilePathModel.h
//  ZXResign
//
//  Created by FreeGeek on 15/12/18.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedData : NSObject
+(SharedData *)sharedInstance;
@property (nonatomic , strong) NSString * MobileprovisionPath;
@property (nonatomic , strong) NSString * WorkPath;
@property (nonatomic , assign) float iPAFilesCount;
@property (nonatomic , strong) NSMutableArray * iPAFilesPathArray;
@property (nonatomic , strong) NSString * EntitlementsPlistPath;
@property (nonatomic , strong) NSString * CerName;
@property (nonatomic , strong) NSString * BundleIdentifier_Mobileprovision;
@property (nonatomic , strong) NSString * BundleIdentifier_InfoPlist;
@property (nonatomic , strong) NSString * AppBundlePath;
@end
