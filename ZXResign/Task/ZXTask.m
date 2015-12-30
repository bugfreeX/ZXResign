//
//  ZXTask.m
//  ZXResign
//
//  Created by FreeGeek on 15/12/26.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import "ZXTask.h"

@implementation ZXTask
+(void)RunTaskWithLaunchPath:(NSString *)path DirectoryPath:(NSString *)directoryPath Arguments:(NSArray *)arguments OutputBlock:(void (^)(NSString* OutputString))OutputString andErrorBlock: (void (^)(NSString*ErrorString))ErrorString onLaunch: (void (^)())launched onExit: (void (^)()) exit
{
    GCDTask * Task = [[GCDTask alloc]init];
    [Task setLaunchPath:path];
    [Task setCurrentDirectoryPath:directoryPath];
    [Task setArguments:arguments];
    [Task launchWithOutputBlock:^(NSData *stdOutData) {
        NSString * output = [[NSString alloc]initWithData:stdOutData encoding:NSUTF8StringEncoding];
        OutputString(output);
    } andErrorBlock:^(NSData *stdErrData) {
        NSString * output = [[NSString alloc]initWithData:stdErrData encoding:NSUTF8StringEncoding];
        ErrorString(output);
    } onLaunch:^{
        launched();
    } onExit:^{
        exit();
    }];
}

@end
