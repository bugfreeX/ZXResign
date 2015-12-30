//
//  ParseAppFilePerform.m
//  ZXResign
//
//  Created by FreeGeek on 15/12/28.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import "ParseAppFilePerform.h"
#import "FrameworkSignPerform.h"
@implementation ParseAppFilePerform
+(void)parseApp
{
    __block NSString * AuthorizationInformation;
    [ZXTask RunTaskWithLaunchPath:Launch_codesign
                    DirectoryPath:nil
                        Arguments:@[@"-vv",@"-d",[SharedData sharedInstance].AppBundlePath]
                      OutputBlock:^(NSString *OutputString) {
                      }
                    andErrorBlock:^(NSString *ErrorString) {
                        if (AuthorizationInformation) {
                            AuthorizationInformation = [AuthorizationInformation stringByAppendingString:ErrorString];
                        }
                        else
                        {
                            AuthorizationInformation = ErrorString;
                        }
                    }
                         onLaunch:^{
                         }
                           onExit:^{
                               [ZXLog LogPerformName:@"Support CUP type " Message:[self CheckCUPtypeByResults:AuthorizationInformation]];
                               //[AppSignPerform Sign];
                               [FrameworkSignPerform Sign];
                           }];
}

+(NSMutableArray *)CheckCUPtypeByResults:(NSString *)results
{
    NSMutableArray * CupTypeArray = [NSMutableArray array];
    if ([results rangeOfString:@"armv7"].length != 0) {
        [CupTypeArray addObject:@"armv7"];
    }
    if ([results rangeOfString:@"armv7s"].length != 0) {
        [CupTypeArray addObject:@"armv7s"];
    }
    if ([results rangeOfString:@"arm64"].length != 0) {
        [CupTypeArray addObject:@"arm64"];
    }
    return CupTypeArray;
}

@end
