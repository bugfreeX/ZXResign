//
//  ZXTask.h
//  ZXResign
//
//  Created by FreeGeek on 15/12/26.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDTask.h"
@interface ZXTask : NSObject
+(void)RunTaskWithLaunchPath:(NSString *)path DirectoryPath:(NSString *)directoryPath Arguments:(NSArray *)arguments OutputBlock:(void (^)(NSString* OutputString))OutputString andErrorBlock: (void (^)(NSString*ErrorString))ErrorString onLaunch: (void (^)())launched onExit: (void (^)()) exit;
@end
