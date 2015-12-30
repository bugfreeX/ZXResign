//
//  FrameworkSignPerform.m
//  ZXResign
//
//  Created by FreeGeek on 15/12/28.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import "FrameworkSignPerform.h"
#import "AppSignPerform.h"
@implementation FrameworkSignPerform
+(void)Sign
{
    NSMutableArray * frameworkArray = [NSMutableArray array];
    NSArray * AllFilesArray = [FileManager subpathsAtPath:[SharedData sharedInstance].AppBundlePath];
    [AllFilesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasSuffix:@".framework"] || [obj hasSuffix:@".dylib"] || [obj hasSuffix:@".appex"]) {
            [frameworkArray addObject:[[SharedData sharedInstance].AppBundlePath stringByAppendingPathComponent:obj]];
            
        }
    }];
    [ZXLog LogPerformName:@"Will Sign Frameworks" Message:frameworkArray];
    [ZXLog LogPerformName:@"Start Sign Framework" Message:@"Signing~"];
    [self frameworkSignByFrameworkArray:frameworkArray block:^{
        [ZXLog LogPerformName:@"Sign Framework end" Message:@"Successed"];
        [AppSignPerform Sign];
    }];
}

+(void)frameworkSignByFrameworkArray:(NSMutableArray *)frameworkArray block:(void(^)())block
{
    if (frameworkArray.count == 0) {
        block();
        return;
    }
    __block int temp = 0;
    for (int i = 0; i < frameworkArray.count; i++) {
        NSString * signPath;
        if ([frameworkArray[i] hasSuffix:@".dylib"]) {
            signPath = frameworkArray[i];
        }
        else
        {
            signPath = [frameworkArray[i] stringByAppendingPathComponent:@"Info.plist"];
        }
        [ZXTask RunTaskWithLaunchPath:Launch_codesign
                        DirectoryPath:nil
                            Arguments:@[@"--deep",@"--force",@"--verify",@"--verbose",@"--sign",[SharedData sharedInstance].CerName,signPath,frameworkArray[i]]
                          OutputBlock:^(NSString *OutputString) {
                          }
                        andErrorBlock:^(NSString *ErrorString) {
                        }
                             onLaunch:^{
                             }
                               onExit:^{
                                   temp++;
                                   if (temp == frameworkArray.count) {
                                       block();
                                   }
                               }];
    }
}
@end
