//
//  AppValidationPerform.m
//  ZXResign
//
//  Created by FreeGeek on 15/12/28.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import "AppValidationPerform.h"
#import "ZipPerform.h"
@implementation AppValidationPerform
+(void)validation
{
    NSMutableArray * arguments = [NSMutableArray arrayWithObjects:@"-v", nil];
    [arguments addObject:[SharedData sharedInstance].AppBundlePath];
    [ZXTask RunTaskWithLaunchPath:Launch_codesign
                    DirectoryPath:nil
                        Arguments:arguments
                      OutputBlock:^(NSString *OutputString) {
                          [ZXLog LogPerformName:@"Validation App OutputString" Message:OutputString];
                      }
                    andErrorBlock:^(NSString *ErrorString) {
                        [ZXLog LogPerformName:@"Validation App ErrorString" Message:ErrorString];
                    }
                         onLaunch:^{
                         }
                           onExit:^{
                               [ZipPerform zip];
                           }];
}
@end
