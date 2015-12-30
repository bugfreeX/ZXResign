//
//  MobileprovisionPerform.m
//  ZXResign
//
//  Created by FreeGeek on 15/12/26.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import "MobileprovisionPerform.h"
#import "ParseAppFilePerform.h"
@implementation MobileprovisionPerform
+(void)creatEntitlementsPlistByMobileprovisionPath:(NSString *)mobileprovisionPath WorkPath:(NSString *)workPath
{
    if ([OtherModel checkVersion] == NO) {
        return;
    }
    if ([self searchAlliPAFilesByWorkPath:workPath] == NO) {
        return;
    }
    [OtherModel removeOtherFiles];
    [SharedData sharedInstance].MobileprovisionPath = mobileprovisionPath;
    [SharedData sharedInstance].WorkPath = workPath;
    NSDictionary * MobileprovisionDict = [self getMobileProvisionbyPath:mobileprovisionPath];
    
    NSDictionary * EntitlementsDict = MobileprovisionDict[@"Entitlements"];
    NSString * entitlementsPath = [workPath stringByAppendingPathComponent:@"entitlements.plist"];
    [SharedData sharedInstance].EntitlementsPlistPath = entitlementsPath;
    [SharedData sharedInstance].CerName = MobileprovisionDict[@"TeamName"];
    /**
     *  get mobileprovision file BundleIdentifier
     */
    NSString * teamIdentifier = EntitlementsDict[@"com.apple.developer.team-identifier"];
    [SharedData sharedInstance].BundleIdentifier_Mobileprovision = [[EntitlementsDict[@"application-identifier"] componentsSeparatedByString:[teamIdentifier stringByAppendingString:@"."]] lastObject];
    [ZXLog LogPerformName:@"Mobileprovision file bundleIdentifier" Message:[SharedData sharedInstance].BundleIdentifier_Mobileprovision];
    [ZXLog LogPerformName:@"Ceate Entitlements---EntitlementsPath" Message:[SharedData sharedInstance].EntitlementsPlistPath];
    [ZXLog LogPerformName:@"Ceate Entitlements---CerName" Message:[SharedData sharedInstance].CerName];
    /**
     *  create entitlements.plist
     */
    BOOL isWriteEntitlements = [EntitlementsDict writeToFile:entitlementsPath atomically:YES];
    if (isWriteEntitlements) {
        [OtherModel StartCheckScriptFiles];
    }
    else
    {
        [ZXLog LogPerformName:@"entitlements.plist write error" Message:nil];
    }
}

+(void)replaceMobileprovision
{
    NSString * PayloadPath = [[SharedData sharedInstance].WorkPath stringByAppendingPathComponent:@"Payload"];
    [ZXLog LogPerformName:@"App Work Path" Message:PayloadPath];
    NSArray * PayloadFilesArray = [FileManager contentsOfDirectoryAtPath:PayloadPath error:nil];
    __block NSString * appPath;
    [PayloadFilesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasSuffix:@".app"]) {
            appPath = [PayloadPath stringByAppendingPathComponent:obj];
        }
    }];
    [SharedData sharedInstance].AppBundlePath = appPath;
    [ZXLog LogPerformName:@"App Bundle Path" Message:[SharedData sharedInstance].AppBundlePath];
    NSString * oldMobileprovisionPath = [appPath stringByAppendingPathComponent:@"embedded.mobileprovision"];
    if ([FileManager fileExistsAtPath:oldMobileprovisionPath]) {
        [ZXLog LogPerformName:@"replace embedded.mobileprovision" Message:@"embedded.mobileprovision is exist,will remove"];
        [FileManager removeItemAtPath:oldMobileprovisionPath error:nil];
    }
    else
    {
        [ZXLog LogPerformName:@"replace embedded.mobileprovision" Message:@"embedded.mobileprovision no exist"];
    }
     [FileManager copyItemAtPath:[SharedData sharedInstance].MobileprovisionPath toPath:oldMobileprovisionPath error:nil];
    [ZXLog LogPerformName:@"copy embedded.mobileprovision" Message:[NSString stringWithFormat:@"Copy to :%@",oldMobileprovisionPath]];
    
    NSString * infoPlistPath = [appPath stringByAppendingPathComponent:@"Info.plist"];
    NSMutableDictionary * infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:infoPlistPath];
    [SharedData sharedInstance].BundleIdentifier_InfoPlist = infoDict[@"CFBundleIdentifier"];
    [ZXLog LogPerformName:@"Info.plist bundleIdentifier" Message:[SharedData sharedInstance].BundleIdentifier_InfoPlist];
    [ZXLog LogPerformName:@"mobileprovision bundleIdentifier" Message:[SharedData sharedInstance].BundleIdentifier_Mobileprovision];
    // remove Info.plist CFBundleResourceSpecification key
    [infoDict removeObjectForKey:@"CFBundleResourceSpecification"];
    if (![[SharedData sharedInstance].BundleIdentifier_InfoPlist isEqualToString:[SharedData sharedInstance].BundleIdentifier_Mobileprovision]) {
        [infoDict setValue:[SharedData sharedInstance].BundleIdentifier_Mobileprovision forKey:@"CFBundleIdentifier"];
        [ZXLog LogPerformName:@"New BundleIdentifier" Message:[SharedData sharedInstance].BundleIdentifier_Mobileprovision];
    }
    BOOL isWrite = [infoDict writeToFile:infoPlistPath atomically:YES];
    if (isWrite) {
        [ParseAppFilePerform parseApp];
    }
    else
    {
        [ZXLog LogPerformName:@"Write Info.plist" Message:@"Error"];
    }
}

+(BOOL)searchAlliPAFilesByWorkPath:(NSString *)workPath
{
    NSArray * allFiles = [FileManager contentsOfDirectoryAtPath:workPath error:nil];
    NSMutableArray * iPAFileNameArray = [NSMutableArray array];
    NSMutableArray * iPAFilePathArray = [NSMutableArray array];
    [allFiles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasSuffix:@".ipa"]) {
            [iPAFilePathArray addObject:[workPath stringByAppendingPathComponent:obj]];
            [iPAFileNameArray addObject:obj];
        }
    }];
    [SharedData sharedInstance].iPAFilesCount = iPAFileNameArray.count;
    if (iPAFilePathArray.count>0) {
        [SharedData sharedInstance].iPAFilesPathArray = iPAFilePathArray;
        [ZXLog LogPerformName:@"iPA Files" Message:iPAFileNameArray];
        return YES;
    }
    else
    {
        [ZXLog LogPerformName:@"iPA Files" Message:@"no iPA Files"];
        [ZXLog WarningAlertbyMessage:@"not iPA Files"];
        return NO;
    }
}

+(NSDictionary*) getMobileProvisionbyPath:(NSString *)path
{
    static NSDictionary* mobileProvision = nil;
    if (!mobileProvision) {
        NSString *provisioningPath = path;
        if (!provisioningPath) {
            mobileProvision = @{};
            return mobileProvision;
        }
        // NSISOLatin1 keeps the binary wrapper from being parsed as unicode and dropped as invalid
        NSString *binaryString = [NSString stringWithContentsOfFile:provisioningPath encoding:NSISOLatin1StringEncoding error:NULL];
        if (!binaryString) {
            return nil;
        }
        NSScanner *scanner = [NSScanner scannerWithString:binaryString];
        BOOL ok = [scanner scanUpToString:@"<plist" intoString:nil];
        if (!ok) { NSLog(@"unable to find beginning of plist");
            //            return UIApplicationReleaseUnknown;
        }
        NSString *plistString;
        ok = [scanner scanUpToString:@"</plist>" intoString:&plistString];
        if (!ok) { NSLog(@"unable to find end of plist");
            //            return UIApplicationReleaseUnknown;
        }
        plistString = [NSString stringWithFormat:@"%@</plist>",plistString];
        // juggle latin1 back to utf-8!
        NSData *plistdata_latin1 = [plistString dataUsingEncoding:NSISOLatin1StringEncoding];
        //		plistString = [NSString stringWithUTF8String:[plistdata_latin1 bytes]];
        //		NSData *plistdata2_latin1 = [plistString dataUsingEncoding:NSISOLatin1StringEncoding];
        NSError *error = nil;
        mobileProvision = [NSPropertyListSerialization propertyListWithData:plistdata_latin1 options:NSPropertyListImmutable format:NULL error:&error];
        if (error) {
            NSLog(@"error parsing extracted plist — %@",error);
            if (mobileProvision) {
                mobileProvision = nil;
            }
            return nil;
        }
    }
    return mobileProvision;
}
@end
