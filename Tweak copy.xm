@interface BBBulletin
@property(copy, nonatomic) NSString *sectionID; // @dynamic sectionID;
@property (nonatomic, copy) NSString *title;

@property(copy, nonatomic) NSString *message; // @dynamic title;
@property(retain, nonatomic) NSDate *date;
@property(copy, nonatomic) NSString *bulletinID;
@property(retain, nonatomic) NSDate *publicationDate;
@property(retain, nonatomic) NSDate *lastInterruptDate;
@property(nonatomic) BOOL showsMessagePreview;
@property(nonatomic) BOOL clearable;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) NSString *sectionDisplayName;
@property (nonatomic, readonly) NSString *topic;

@end

#include <spawn.h>
extern char **environ;

/*

%hook BBServer

- (void)publishBulletin:(BBBulletin*)bulletin destinations:(unsigned long long)arg2 alwaysToLockScreen:(BOOL)arg3
- (void)_publishBulletinRequest:(id)arg1 forSectionID:(id)arg2 forDestinations:(unsigned int)arg3 alwaysToLockScreen:(BOOL)arg4;
*/

%hook SBLockScreenNotificationListController    
- (void)observer:(id)arg1 addBulletin:(BBBulletin*)bulletin forFeed:(unsigned long long)arg3
{
	NSString *title = bulletin.title;
	NSString * sectionDisplayName = bulletin.sectionDisplayName;
	NSString *topic = bulletin.topic;
	NSString *id = bulletin.sectionID;
	NSString *message = bulletin.message;
	NSString *subtitle = bulletin.subtitle;
	NSString *notif = [NSString stringWithFormat:@"%@ %@", subtitle, message];
	
	NSString *sms = @"com.apple.MobileSMS";
	NSString *str = [NSString stringWithFormat:@"stb -s %@", bulletin.message];
	const char *ptr = [str cStringUsingEncoding: NSASCIIStringEncoding];
	NSLog(@"fit pusher: title %@, subtitle %@, message %@, id %@, topic %@, sectionDisplayName %@", title, subtitle, message, id, topic, sectionDisplayName); 
	if([id isEqualToString:sms]) {
		%orig;
	}
	else if(![id isEqualToString:sms]) {
		%orig;
		system("stb");
		
	}
}
%end

