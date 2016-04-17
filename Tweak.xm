#import "Headers.h"


static NSString *notif;




%hook BBServer
//- (void)publishBulletin:(BBBulletin*)bulletin destinations:(unsigned long long)arg2 alwaysToLockScreen:(BOOL)arg3
- (void)_addBulletin:(BBBulletin*)bulletin

{
	NSString *description = bulletin.description;
	NSString *title = bulletin.title;
	NSString *sectionDisplayName = bulletin.sectionDisplayName;
	NSString *topic = bulletin.topic;
	NSString *id = bulletin.sectionID;
	NSString *message = bulletin.message;
	NSString *subtitle = bulletin.subtitle;
	NSDate *date = bulletin.date;

	NSBundle *bundle = [NSBundle bundleWithIdentifier:id];
	NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleExecutable"];
	NSLog(@"AppName: %@ \n appVersion: %@",appName, bundle );

	NSString* name = [[id componentsSeparatedByString:@"."] lastObject];
	NSDate * previousDate = [NSDate date];
	NSDate *newDate = [previousDate dateByAddingTimeInterval:25];

	if ([subtitle isEqualToString:@"FitPusher"])
	{
		bulletin.expirationDate = newDate;
	}

	if (title == nil)
	{
		if([id isEqualToString:@"com.toyopagroup.picaboo"])
		{
			title = @"Snapchat";
		}
		else
		{

			title = name;
		}
	}
	if (subtitle != nil)
	{
		NSString *notif = [NSString stringWithFormat:@"%@ %@", subtitle, message];
	}
	else
	{
		NSString *notif = message;
	}
	if (message == nil)
	{
		message = @"";
	}
	NSString *firstCapChar = [[title substringToIndex:1] capitalizedString];
	NSString *Title = [title stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
	NSString *sms = @"com.apple.MobileSMS";
	NSString *weather = @"com.apple.weather.today";
	NSString *phone = @"com.apple.mobilephone";
	NSString *cal = @"com.apple.mobilecal";
	NSString *cal2 = @"com.apple.mobilecal.today";
	NSString *str = [NSString stringWithFormat:@"stb -n -t \"%@\" -m \"%@\" -s FitPusher", Title, message];
	NSString *str2 = [NSString stringWithFormat:@"stb -b com.apple.mobilecal -n -t \"%@\" -m \"%@\" -s FitPusher", Title, message];
	const char *ptr = [str cStringUsingEncoding: NSUTF8StringEncoding];
	const char *ptr2 = [str2 cStringUsingEncoding: NSUTF8StringEncoding];


	if([id isEqualToString:sms] || [id isEqualToString:phone] || [id isEqualToString:cal] || [id isEqualToString:cal2] || [id isEqualToString:weather])
	{
	}

	else
	{
		if ([date timeIntervalSinceNow] > -15)
		{
			if([id isEqualToString:@"com.apple.mobiletimer"] && ![title isEqualToString:@"Mobiletimer"])
			{
				system(ptr2);
			}
			else
			{
				system(ptr);
			}
		}
		else
		{
		}
	}
	%orig;

	NSLog(@"	alternateActionLabel:FITPUSH: %@",	 bulletin.	alternateActionLabel);
	NSLog(@"	bannerAccessoryRemoteServiceBundleIdentifier:FITPUSH: %@",	 bulletin.	bannerAccessoryRemoteServiceBundleIdentifier);
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
	NSLog(@"	unlockActionLabelOverride:FITPUSH: %@",	 bulletin.	unlockActionLabelOverride);


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


