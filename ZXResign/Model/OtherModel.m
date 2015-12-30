//
//  OtherModel.m
//  ZXResign
//
//  Created by FreeGeek on 15/12/26.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import "OtherModel.h"
#import "KeyChainPerform.h"
@implementation OtherModel
+(void)StartCheckScriptFiles
{
    NSString * Message;
    if (![FileManager isExecutableFileAtPath:Launch_zip]) {
        Message = @"Not Found /usr/bin/zip File";
    }
    else if (![FileManager isExecutableFileAtPath:Launch_unzip]){
        Message = @"Not Found /usr/bin/unzip File";
    }
    else if (![FileManager isExecutableFileAtPath:Launch_codesign]){
        Message = @"Not Found /usr/bin/codesign File";
    }
    else if (![FileManager isExecutableFileAtPath:Launch_security])
    {
        Message = @"Not Found /usr/bin/security File";
    }
    if (Message) {
        [ZXLog WarningAlertbyMessage:Message];
    }
    else
    {
         [KeyChainPerform KeyChainCertificate_and_mobileprovision_match];
    }
}

+(BOOL)checkVersion
{
    NSString * versionString = [[[NSProcessInfo processInfo] operatingSystemVersionString] componentsSeparatedByString:@" "][1];
    NSArray * numberArray = [versionString componentsSeparatedByString:@"."];
    if ([[numberArray firstObject] integerValue] >= 10) {
        if ([numberArray[1] integerValue] >=9) {
            return YES;
        }
        else
        {
            [ZXLog WarningAlertbyMessage:@"Must Support For OSX 10.9 and later"];
            return NO;
        }
    }
    else
    {
        [ZXLog WarningAlertbyMessage:@"Must Support For OSX 10.9 and later"];
        return NO;
    }
}

+(void)removeOtherFiles
{
    NSArray * otherFilesArray = [FileManager contentsOfDirectoryAtPath:[SharedData sharedInstance].WorkPath error:nil];
    [otherFilesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!([obj hasSuffix:@".mobileprovision"] || [obj hasSuffix:@".ipa"] || [obj isEqualToString:@"entitlements.plist"])) {
            [FileManager removeItemAtPath:[[SharedData sharedInstance].WorkPath stringByAppendingPathComponent:obj] error:nil];
        }
    }];
}

+(void)copyResignediPAToNewPath
{
    NSString * newFolderPath = [[SharedData sharedInstance].WorkPath stringByAppendingPathComponent:@"Resigned"];
    if ([FileManager fileExistsAtPath:newFolderPath]) {
        [FileManager removeItemAtPath:newFolderPath error:nil];
    }
    [FileManager createDirectoryAtPath:newFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSArray * ResignediPAArray = [FileManager contentsOfDirectoryAtPath:[SharedData sharedInstance].WorkPath error:nil];
    [ResignediPAArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasSuffix:@"Resigned.ipa"]) {
            [FileManager moveItemAtPath:[[SharedData sharedInstance].WorkPath stringByAppendingPathComponent:obj] toPath:[newFolderPath stringByAppendingPathComponent:obj] error:nil];
        }
    }];
    
}

@end
