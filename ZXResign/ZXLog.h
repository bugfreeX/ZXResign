//
//  ZXLog.h
//  ZXResign
//
//  Created by FreeGeek on 15/12/26.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXLog : NSObject
+(void)LogPerformName:(NSString *)performName Message:(id)message;
+(void)WarningAlertbyMessage:(NSString *)message;
+(void)SuccessedAlertbyMessage:(NSString *)message;
@end
