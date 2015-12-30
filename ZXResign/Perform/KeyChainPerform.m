//
//  KeyChainPerform.m
//  ZXResign
//
//  Created by FreeGeek on 15/12/26.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import "KeyChainPerform.h"
#import "UnZipPerform.h"
@implementation KeyChainPerform
+(void)KeyChainCertificate_and_mobileprovision_match
{
    [ZXTask RunTaskWithLaunchPath:Launch_security DirectoryPath:nil Arguments:@[@"find-identity",@"-v",@"-p",@"codesigning"] OutputBlock:^(NSString *OutputString) {
        if ([self dealWithCerResults:OutputString]) {
            [UnZipPerform Run];
        }
    } andErrorBlock:^(NSString *ErrorString) {
        [ZXLog LogPerformName:@"KeyChain" Message:ErrorString];
    } onLaunch:^{
    } onExit:^{
    }];
}

+(BOOL)dealWithCerResults:(NSString *)cerResults
{
    if (cerResults) {
        NSArray * rawResult = [cerResults componentsSeparatedByString:@"\""];
        NSMutableArray * cer_results = [NSMutableArray array];
        for (int i = 0; i <= [rawResult count] - 2; i+=2) {
            if (rawResult.count - 1 < i + 1) {
                // Invalid array, don't add an object to that position
            }
            else
            {
                // Valid object
                [cer_results addObject:[rawResult objectAtIndex:i+1]];
            }
        }
        NSString * cer_index_distribution = [SharedData sharedInstance].CerName;
        //NSUInteger count = [cer_results count];
        for (int j = 0; j<[cer_results count];j++) {
            NSString * Cer_Name = cer_results[j];
            NSRange cer_index_range = [Cer_Name rangeOfString:cer_index_distribution];
            if (cer_index_range.length>0) {
                [SharedData sharedInstance].CerName = Cer_Name;
                [ZXLog LogPerformName:@"KeyChain and the mobileprovision file match" Message:@"PASS"];
                [ZXLog LogPerformName:@"KeyChain Cer" Message:[SharedData sharedInstance].CerName];
                return YES;
            }
        }
        [ZXLog WarningAlertbyMessage:@"KeyChain and the mobileprovision file no match"];
        [ZXLog LogPerformName:@"KeyChain and the mobileprovision file no match" Message:@"NOT PASS"];
        return NO;
    }
    else
    {
        [ZXLog WarningAlertbyMessage:@"There is no certificate in KeyChain"];
        return NO;
    }
}

@end
