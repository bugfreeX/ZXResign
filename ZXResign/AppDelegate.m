//
//  AppDelegate.m
//  ZXResign
//
//  Created by FreeGeek on 15/12/18.
//  Copyright © 2015年 ZhongXi. All rights reserved.
//

#import "AppDelegate.h"
#import "MobileprovisionPerform.h"
#import "KeyChainPerform.h"
@interface AppDelegate ()


@property (weak) IBOutlet NSTextField *iPATextfield;
@property (weak) IBOutlet NSTextField *MobileprovisionTextfield;
@property (weak) IBOutlet NSButton *iPABtn;
@property (weak) IBOutlet NSButton *MobileprovisionBtn;
@property (weak) IBOutlet NSButton *ResignBtn;

@end

@implementation AppDelegate


- (IBAction)ResignAction:(id)sender {

    //Start Resign
    [MobileprovisionPerform creatEntitlementsPlistByMobileprovisionPath:_MobileprovisionTextfield.stringValue WorkPath:_iPATextfield.stringValue];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    if ([UserDefaults stringForKey:IPA_PATH]) {
        [_iPATextfield setStringValue:[UserDefaults stringForKey:IPA_PATH]];
    }
    if ([UserDefaults stringForKey:Mobileprovision_PATH]) {
        [_MobileprovisionTextfield setStringValue:[UserDefaults stringForKey:Mobileprovision_PATH]];
    }
}

- (IBAction)iPAAction:(id)sender {
    [_window makeFirstResponder:nil];
    NSOpenPanel * openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setAllowsOtherFileTypes:NO];
    if ([openDlg runModal] == NSModalResponseOK) {
        NSString * iPAPath = [[openDlg URLs][0] path];
        [_iPATextfield setStringValue:iPAPath];
        [UserDefaults setObject:iPAPath forKey:IPA_PATH];
    }
}
- (IBAction)MobileprovisionAction:(id)sender {
    [_window makeFirstResponder:nil];
    NSOpenPanel * openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanCreateDirectories:NO];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setAllowsOtherFileTypes:NO];
    [openDlg setAllowedFileTypes:@[@"mobileprovision"]];
    if ([openDlg runModal] == NSModalResponseOK) {
        NSString * MobileprovisionPath = [[openDlg URLs][0] path];
        [_MobileprovisionTextfield setStringValue:MobileprovisionPath];
        [UserDefaults setObject:MobileprovisionPath forKey:Mobileprovision_PATH];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
