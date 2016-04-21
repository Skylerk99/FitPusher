#import "Headers.h"
#import <ZWEmoji.m>
NSMutableDictionary *Wapplist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.skylerk99.fitpusher.Wapplist.plist"];
NSMutableDictionary *Bapplist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.skylerk99.fitpusher.Bapplist.plist"];


//[[applist objectForKey:identifier] boolValue]

static BOOL enable = YES;
static BOOL success = YES;
static BOOL timeStamp = NO;
static BOOL ascii = NO;
static BOOL emoji = NO;
static CGFloat list = 1;
NSString *testNotif;
BBServer *bbServer;
NSString *sendID;


%hook BBServer
- (void)publishBulletin:(BBBulletin*)bulletin destinations:(unsigned long long)arg2 alwaysToLockScreen:(BOOL)arg3
//- (void)_addBulletin:(BBBulletin*)bulletin
{
    %orig;

	if (enable)
	{
        BBBulletin *bulletin2 = [[BBBulletin alloc] init];
		NSString *title = bulletin.title;
		NSString *rand = bulletin.bulletinID;
		NSString *id = bulletin.sectionID;
		NSString *message = bulletin.message;
		NSString *subtitle = bulletin.subtitle;
		NSDate *date = bulletin.date;
		NSString *recordID = bulletin.recordID;
		NSString *send;
		//NSString *sendID = @"com.apple.MobileSMS";
	//	NSString* name = [[id componentsSeparatedByString:@"."] lastObject];
		NSDate * previousDate = [NSDate date];
		NSDate *newDate = [previousDate dateByAddingTimeInterval:25];
	//	NSString *firstCapChar = [[name substringToIndex:1] capitalizedString];
	//	NSString *Title = [name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
        SBApplication *app = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:id];

		NSString *sms = @"com.apple.MobileSMS";
		NSString *weather = @"com.apple.weather.today";
		NSString *phone = @"com.apple.mobilephone";
		NSString *cal = @"com.apple.mobilecal";
		NSString *cal2 = @"com.apple.mobilecal.today";

		NSDate *currentTime = [NSDate date];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"hh:mm"];
		NSString *time = [dateFormatter stringFromDate: currentTime];

		if ([subtitle isEqualToString:@"FitPusher"])
		{
			bulletin.expirationDate = newDate;
		}

        if (sendID == nil)
        {
            sendID = sms;
        }
		if (title == nil)
        {
				title = app.displayName;
		}

		if (message == nil)
		{
			message = @"";
		}
		if (subtitle == nil)
		{
			subtitle = @"";
		}

		if (list == 0 && [[Wapplist objectForKey:id] boolValue])
		{
			send = @"YES";
		}
		else if (list == 1 && [[Bapplist objectForKey:id] boolValue])
		{
			send = @"NO";
		}
		else
		{
			send = @"NO";
		}


		NSString *notif = [NSString stringWithFormat:@"%@ %@", subtitle, message];

		if(timeStamp)
		{
			notif = [NSString stringWithFormat:@"%@\n%@", notif, time];
		}
		if ([notif length] <= 2)
		{
			notif = time;
		}

		//		NSString *str = [NSString stringWithFormat:@"stb -n -t \"%@\" -m \"%@\" -s FitPusher", title, notif];
		//		NSString *str2 = [NSString stringWithFormat:@"stb -b com.apple.mobilecal -n -t \"%@\" -m \"%@\" -s FitPusher", title, notif];
		//		const char *ptr = [str cStringUsingEncoding: NSUTF8StringEncoding];
		//		const char *ptr2 = [str2 cStringUsingEncoding: NSUTF8StringEncoding];
        
        notif = [notif stringByReplacingOccurrencesOfString:@"⁠" withString:@""];
        notif = [notif stringByReplacingOccurrencesOfString:@"‎" withString:@""];
        notif = [notif stringByReplacingOccurrencesOfString:@"‎" withString:@""];
        if (emoji)
        {
        notif = [ZWEmoji unemojify:notif];
        }
        
     //   NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
     //   notif = [[notif componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
        
        if (ascii)
        {
        NSMutableString *asciiCharacters = [NSMutableString string];
        for (NSInteger i = 32; i < 127; i++)  {
            [asciiCharacters appendFormat:@"%c", i];
        }
        
        NSCharacterSet *nonAsciiCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:asciiCharacters] invertedSet];
        
        notif = [[notif componentsSeparatedByCharactersInSet:nonAsciiCharacterSet] componentsJoinedByString:@""];
        }
        
        
		bulletin2.sectionID =  sendID;
		bulletin2.title = title;
        //bulletin2.bulletinID = id;
		bulletin2.message  = notif;
		bulletin2.clearable = YES;
		bulletin2.bulletinID = [NSString stringWithFormat:@"%@-%@", rand, [NSString stringWithFormat:@"%d", arc4random_uniform(21474836)]];
		bulletin2.date = [NSDate date];
		bulletin2.publicationDate = [NSDate date];
		bulletin2.lastInterruptDate = [NSDate date];
		bulletin2.subtitle = @"FitPusher";
		bulletin2.sound = nil;
		if([id isEqualToString:sms] || [id isEqualToString:phone] || [id isEqualToString:cal] || [id isEqualToString:cal2] || [id isEqualToString:weather] || [recordID isEqualToString:@"NextTodayAlarm"] || [recordID isEqualToString:@"FirstTomorrowAlarm"])
		{
		}
		else
		{
			if ([date timeIntervalSinceNow] > -15)
			{
				if (list == 0)
				{
					if ([[Wapplist objectForKey:id] boolValue])
					{
						[bbServer publishBulletin:bulletin2 destinations:14 alwaysToLockScreen:YES];					}
				}
				else if (list == 1)
				{
					if (![[Bapplist objectForKey:id] boolValue])
					{
						[bbServer publishBulletin:bulletin2 destinations:14 alwaysToLockScreen:YES];					}
				}
			}
		}



		NSLog(@"	SOUND:FITPUSH: %@",	 bulletin.sound);
		NSLog(@"	bannerAccessoryRemoteViewControllerClassName:FITPUSH: %@",	 bulletin.	bannerAccessoryRemoteViewControllerClassName);
		NSLog(@"	bulletinID:FITPUSH: %@",	 bulletin.	bulletinID);
		NSLog(@"	bulletinVersionID:FITPUSH: %@",	 bulletin.	bulletinVersionID);
		NSLog(@"	debugDescription:FITPUSH: %@",	 bulletin.	debugDescription);
		NSLog(@"	description:FITPUSH: %@",	 bulletin.	description);
		NSLog(@"	dismissalID:FITPUSH: %@",	 bulletin.	dismissalID);
		NSLog(@"	fullAlternateActionLabel:FITPUSH: %@",	 bulletin.	fullAlternateActionLabel);
		NSLog(@"	fullUnlockActionLabel:FITPUSH: %@",	 bulletin.	fullUnlockActionLabel);
		NSLog(@"	message:FITPUSH: %@",	 bulletin.	message);
		NSLog(@"	missedBannerDescriptionFormat:FITPUSH: %@",	 bulletin.	missedBannerDescriptionFormat);
		NSLog(@"	parentSectionID:FITPUSH: %@",	 bulletin.	parentSectionID);
		NSLog(@"	publisherBulletinID:FITPUSH: %@",	 bulletin.	publisherBulletinID);
		NSLog(@"	recordID:FITPUSH: %@",	 bulletin.	recordID);
		NSLog(@"	secondaryContentRemoteServiceBundleIdentifier:FITPUSH: %@",	 bulletin.	secondaryContentRemoteServiceBundleIdentifier);
		NSLog(@"	secondaryContentRemoteViewControllerClassName:FITPUSH: %@",	 bulletin.	secondaryContentRemoteViewControllerClassName);
		NSLog(@"	section:FITPUSH: %@",	 bulletin.	section);
		NSLog(@"	sectionDisplayName:FITPUSH: %@",	 bulletin.sectionDisplayName);
		NSLog(@"	sectionID:FITPUSH: %@",	 bulletin.	sectionID);
		NSLog(@"	subtitle:FITPUSH: %@",	 bulletin.	subtitle);
		NSLog(@"	title:FITPUSH: %@",	 bulletin.	title);
		NSLog(@"	topic:FITPUSH: %@",	 bulletin.	topic);
		NSLog(@"	universalSectionID:FITPUSH: %@",	 bulletin.	universalSectionID);
		NSLog(@"	unlockActionLabel:FITPUSH: %@",	 bulletin.	unlockActionLabel);
		NSLog(@"	unlockActionLabelOverride:FITPUSH: %@",	 bulletin.	unlockActionLabelOverride);
        NSLog(@"	NAME:FITPUSH: %@", app.displayName);

	}

	else
	{
	}
}
%end

%hook SBLockScreenNotificationListController
- (void)observer:(id)arg1 addBulletin:(BBBulletin*)bulletin forFeed:(unsigned long long)arg3 playLightsAndSirens:(_Bool)arg4 withReply:(id)arg5

{
	NSString *subtitle = bulletin.subtitle;

	if ([subtitle isEqualToString:@"FitPusher"])
	{
	}
	else
	{
		%orig;
	}
}
%end


%hook SBBulletinBannerController
-(void)observer:(id)observer addBulletin:(BBBulletin*)bulletin forFeed:(unsigned long long)arg3 playLightsAndSirens:(_Bool)arg4 withReply:(id)arg5
{
	NSString *subtitle = bulletin.subtitle;

	if ([subtitle isEqualToString:@"FitPusher"])
	{
	}
	else
	{
		%orig;
	}
}
%end

%hook SBBulletinObserverViewController
-(void)observer:(id)arg1 addBulletin:(BBBulletin*)bulletin forFeed:(unsigned long long)arg3
{
	NSString *subtitle = bulletin.subtitle;

	if ([subtitle isEqualToString:@"FitPusher"])
	{
	}
	else
	{
		%orig;
	}
}
%end

%hook BBServer
- (id)init {
	bbServer = %orig;
	return bbServer;
}
%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
	%orig;
	double delayInSeconds = 0.5;
	double delayInSeconds2 = 4.5;
	SBCCBluetoothSetting *bluetooth = [%c(SBCCBluetoothSetting) new];
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		[bluetooth _updateState];
		[bluetooth _toggleState];

		NSLog(@"TOGGLE 1");
	});

	dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds2 * NSEC_PER_SEC));
	dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
		[bluetooth _updateState];

		[bluetooth _toggleState];
		[bluetooth release];
		NSLog(@"TOGGLE 2");
		if (success)
		{
			//system("stb -s FitPusher -m \"You're tracker is now re-connected\" -t Success");
			HBLogDebug(@"Done pushing notification")
			BBBulletin *bulletin = [[BBBulletin alloc] init];
			bulletin.sectionID =  @"com.apple.MobileSMS";
			bulletin.title =  @"Fitbit Watch";
			bulletin.message  = @"Your Fitbit watch is now connected";
			bulletin.clearable = YES;
			bulletin.subtitle = @"FitPusher";
			bulletin.bulletinID = @"FitBit";
			bulletin.date = [NSDate date];
			bulletin.publicationDate = [NSDate date];
			bulletin.lastInterruptDate = [NSDate date];
            bulletin.sound = nil;
			SystemSoundID lowSound;
			AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:lowsound isDirectory:NO],&lowSound);
			if(lowSound) bulletin.sound=[BBSound alertSoundWithSystemSoundID:lowSound];
			if (bbServer)
				[bbServer publishBulletin:bulletin destinations:14 alwaysToLockScreen:YES];
		}
	});

}
%end


static void showTestBanner() {
    
        NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.skylerk99.fitpusher.plist"];
        if(prefs)
        {
            enable = [prefs objectForKey:@"enable"] ? [[prefs objectForKey:@"enable"] boolValue] : enable;
            emoji = [prefs objectForKey:@"emoji"] ? [[prefs objectForKey:@"emoji"] boolValue] : emoji;
            timeStamp = [prefs objectForKey:@"timeStamp"] ? [[prefs objectForKey:@"timeStamp"] boolValue] : timeStamp;
            ascii = [prefs objectForKey:@"ascii"] ? [[prefs objectForKey:@"ascii"] boolValue] : ascii;
            success = [prefs objectForKey:@"success"] ? [[prefs objectForKey:@"success"] boolValue] : success;
            list = [prefs objectForKey:@"list"] ? [[prefs objectForKey:@"list"] floatValue] : list;
            testNotif = [prefs objectForKey:@"testNotif"] ? [prefs objectForKey:@"testNotif"] : testNotif;
            sendID = [prefs objectForKey:@"sendID"] ? [prefs objectForKey:@"sendID"] : sendID;
        }
        [prefs release];
    
    
    if (testNotif.length == 0) {
        testNotif = @"Test Notification";
    }
    NSDate * previousDate = [NSDate date];
    NSDate *newDate = [previousDate dateByAddingTimeInterval:25];
	BBBulletin *bulletin = [[BBBulletin alloc] init];
	bulletin.sectionID =  @"com.fitbit.FitbitMobile";
	bulletin.title =  @"Fitbit Watch";
    bulletin.expirationDate = newDate;
	bulletin.message  = testNotif;
	bulletin.clearable = YES;
	//bulletin.subtitle = @"FitPusher";
	bulletin.bulletinID = [NSString stringWithFormat:@"%@-%@", [NSString stringWithFormat:@"%d", arc4random_uniform(21474836)], [NSString stringWithFormat:@"%d", arc4random_uniform(21474836)]];
	bulletin.date = [NSDate date];
	bulletin.publicationDate = [NSDate date];
	bulletin.lastInterruptDate = [NSDate date];
	SystemSoundID lowSound;
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:lowsound isDirectory:NO],&lowSound);
	if(lowSound) bulletin.sound=[BBSound alertSoundWithSystemSoundID:lowSound];
	if (bbServer)
		[bbServer publishBulletin:bulletin destinations:14 alwaysToLockScreen:YES];
}


static void loadPrefs()
{
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.skylerk99.fitpusher.plist"];
	if(prefs)
	{
        enable = [prefs objectForKey:@"enable"] ? [[prefs objectForKey:@"enable"] boolValue] : enable;
        emoji = [prefs objectForKey:@"emoji"] ? [[prefs objectForKey:@"emoji"] boolValue] : emoji;
        timeStamp = [prefs objectForKey:@"timeStamp"] ? [[prefs objectForKey:@"timeStamp"] boolValue] : timeStamp;
        ascii = [prefs objectForKey:@"ascii"] ? [[prefs objectForKey:@"ascii"] boolValue] : ascii;
		success = [prefs objectForKey:@"success"] ? [[prefs objectForKey:@"success"] boolValue] : success;
        list = [prefs objectForKey:@"list"] ? [[prefs objectForKey:@"list"] floatValue] : list;
        testNotif = [prefs objectForKey:@"testNotif"] ? [prefs objectForKey:@"testNotif"] : testNotif;
        sendID = [prefs objectForKey:@"sendID"] ? [prefs objectForKey:@"sendID"] : sendID;

	}
	[prefs release];
}


%ctor
{

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.skylerk99.fitpusher.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    (CFNotificationCallback)showTestBanner,
                                    CFSTR("com.skylerk99.fitpusher/showtestbanner"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);


}


