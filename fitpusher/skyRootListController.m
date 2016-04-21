
#include "skyRootListController.h"
#define fitpusherPath @"/User/Library/Preferences/com.skylerk99.fitpusher.plist"
#define TEST_BANNER "com.skylerk99.fitpusher/test-banner"

@implementation skyRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];

	}
	return _specifiers;
}


-(id) readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary *fitpusherSettings = [NSDictionary dictionaryWithContentsOfFile:fitpusherPath];
	if (!fitpusherSettings[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return fitpusherSettings[specifier.properties[@"key"]];
}

-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:fitpusherPath]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:fitpusherPath atomically:YES];
	//  NSDictionary *fitpusherSettings = [NSDictionary dictionaryWithContentsOfFile:fitpusherPath];
	CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
	if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
	//  system("killall -9 Music");
}

-(void)showTestBanner{
    [self.view endEditing:YES];
    CFPreferencesAppSynchronize(CFSTR("com.skylerk99.fitpusher"));
    CFNotificationCenterPostNotification(
                                         CFNotificationCenterGetDarwinNotifyCenter(),
                                         CFSTR("com.skylerk99.fitpusher/showtestbanner"),
                                         NULL,
                                         NULL,
                                         YES
                                         );
}

- (void)kill {
    NSLog(@"KILLALL FITPUSH");
	system("killall -9 SpringBoard");
}
@end
