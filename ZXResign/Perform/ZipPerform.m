//
//  ZipPerform.m
//  ZXResign
//
//  Created by FreeGeek on 15/12/28.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import "ZipPerform.h"
#import "UnZipPerform.h"
@implementation ZipPerform
+(void)zip
{
    NSString * NewiPAName = [[[[[[SharedData sharedInstance].iPAFilesPathArray[0] componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."] firstObject] stringByAppendingString:@"-Resigned.ipa"];
    [ZXLog LogPerformName:@"Zip" Message:NewiPAName];
    [ZXTask RunTaskWithLaunchPath:Launch_zip
                    DirectoryPath:[SharedData sharedInstance].WorkPath
                        Arguments:@[@"-qry",NewiPAName,@"Payload"]
                      OutputBlock:^(NSString *OutputString) {
                      }
                    andErrorBlock:^(NSString *ErrorString) {
                    }
                         onLaunch:^{
                         }
                           onExit:^{
                               
                               [ZXLog LogPerformName:[NSString stringWithFormat:@"%@ Resign",[[[SharedData sharedInstance].iPAFilesPathArray[0] componentsSeparatedByString:@"/"] lastObject]] Message:@"Success"];
                               [ZXLog LogPerformName:@"New iPA Path" Message:NewiPAName];
                               [ZXLog LogPerformName:@"********************************" Message:nil];
                               [OtherModel removeOtherFiles];
                               [[SharedData sharedInstance].iPAFilesPathArray removeObjectAtIndex:0];
                               [UnZipPerform Run];
                           }];
}



@end
