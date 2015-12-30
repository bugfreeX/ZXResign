//
//  AppSignPerform.m
//  ZXResign
//
//  Created by FreeGeek on 15/12/28.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import "AppSignPerform.h"
#import "AppValidationPerform.h"
@implementation AppSignPerform
+(void)Sign
{
        NSMutableArray * arguments = [NSMutableArray arrayWithObjects:@"-fs",[SharedData sharedInstance].CerName,@"--no-strict",nil];
        [arguments addObject:[NSString stringWithFormat:@"--entitlements=%@",[SharedData sharedInstance].EntitlementsPlistPath]];
        [arguments addObjectsFromArray:[NSArray arrayWithObjects:[SharedData sharedInstance].AppBundlePath, nil]];
        [ZXLog LogPerformName:@"Start Sign App file" Message:@"Signing~"];
        [ZXTask RunTaskWithLaunchPath:Launch_codesign
                        DirectoryPath:nil
                            Arguments:arguments
                          OutputBlock:^(NSString *OutputString) {
                          }
                        andErrorBlock:^(NSString *ErrorString) {
                            [ZXLog LogPerformName:@"App file signing" Message:ErrorString];
                        }
                             onLaunch:^{
                             }
                               onExit:^{
                                   [ZXLog LogPerformName:@"App file signed" Message:@"Successed"];
                                   [AppValidationPerform validation];
                                   
                               }];

}

@end
