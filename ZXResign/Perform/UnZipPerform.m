//
//  UnZipPerform.m
//  ZXResign
//
//  Created by FreeGeek on 15/12/26.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import "UnZipPerform.h"
#import "MobileprovisionPerform.h"
#import "AppDelegate.h"
@implementation UnZipPerform
+(void)Run
{
    float progress = ([SharedData sharedInstance].iPAFilesCount - (float)[SharedData sharedInstance].iPAFilesPathArray.count) / [SharedData sharedInstance].iPAFilesCount;
    dispatch_async(dispatch_get_main_queue(), ^{
        appDelegate.ProgressView.doubleValue = progress;
    });
    if ([SharedData sharedInstance].iPAFilesPathArray.count > 0) {
        [ZXLog LogPerformName:@"iPA Start Sign" Message:[SharedData sharedInstance].iPAFilesPathArray[0]];
        [ZXTask RunTaskWithLaunchPath:Launch_unzip
                        DirectoryPath:nil
                            Arguments:@[@"-o",@"-q",[SharedData sharedInstance].iPAFilesPathArray[0],@"-d",[SharedData sharedInstance].WorkPath]
                          OutputBlock:^(NSString *OutputString) {
                          }
                        andErrorBlock:^(NSString *ErrorString) {
                        }
                             onLaunch:^{
                             }
                               onExit:^{
                                   [ZXLog LogPerformName:@"UnZip" Message:@"Exit"];
                                   [MobileprovisionPerform replaceMobileprovision];
                               }];
    }
    else
    {
        [OtherModel copyResignediPAToNewPath];
        [ZXLog SuccessedAlertbyMessage:@"All iPA File ReSigned!"];
    }
}

@end
