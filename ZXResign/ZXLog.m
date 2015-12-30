//
//  ZXLog.m
//  ZXResign
//
//  Created by FreeGeek on 15/12/26.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import "ZXLog.h"
#import "AppDelegate.h"
@implementation ZXLog
+(void)LogPerformName:(NSString *)performName Message:(id)message
{
    NSString * log;
    if (message) {
        log = [NSString stringWithFormat:@"***** %@ *****     %@",performName,message];
    }
    else
    {
         log = [NSString stringWithFormat:@"***** %@ *****",performName];
    }
        NSLog(@"%@",log);
}
+(void)WarningAlertbyMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAlert * alert = [[NSAlert alloc]init];
        [alert setMessageText:@"Warning!"];
        [alert addButtonWithTitle:@"I Know"];
        [alert setInformativeText:message];
        [alert setAlertStyle:NSWarningAlertStyle];
        AppDelegate * delegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        [alert beginSheetModalForWindow:delegate.window completionHandler:^(NSModalResponse returnCode) {
            
        }];
    });
}
+(void)SuccessedAlertbyMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAlert * alert = [[NSAlert alloc]init];
        [alert setMessageText:@"Successed!"];
        [alert addButtonWithTitle:@"I Know"];
        [alert setInformativeText:message];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:appDelegate.window completionHandler:^(NSModalResponse returnCode) {
        }];
    });
}

@end
