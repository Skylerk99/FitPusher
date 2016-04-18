//#import <Springboard/SBApplicationController.h>
//#import <SpringBoard/SpringBoard.h>
//#import <Springboard/SBBulletinBannerController.h>
#import <AudioToolbox/AudioToolbox.h>
#import <rocketbootstrap/rocketbootstrap.h>
#include <time.h>
#include <errno.h>
#include <sys/sysctl.h>
#include <stdlib.h>
#define lowsound @"/System/Library/Audio/UISounds/low_power.caf"
@interface BBContent : NSObject <NSCopying, NSSecureCoding>
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *title;
@end


@interface BBSound
+ (id)alertSoundWithSystemSoundID:(unsigned long)arg1;
@end


@interface BBServer
- (void)_publishBulletinRequest:(id)arg1 forSectionID:(id)arg2 forDestinations:(unsigned int)arg3 alwaysToLockScreen:(BOOL)arg4;
- (void)demo_lockscreen:(unsigned long long)arg1;
- (void)_sendAddBulletin:(id)arg1 toFeeds:(unsigned int)arg2;
- (void)publishBulletin:(id)bulletin destinations:(int)dests alwaysToLockScreen:(BOOL)lock;
- (void)_addBulletin:(id)arg1;

@end

@interface SpringBoard : NSObject
- (void)_relaunchSpringBoardNow;
- (void)_runAppSwitcherDismissTest;
- (void)_powerDownNow;
- (void)_rebootNow;
- (void)lockButtonWasHeld;
- (void)languageChanged;
- (void)reboot;
- (void)_batterySaverModeChanged:(int)arg1;
@end

@interface SBCCBluetoothSetting : NSObject
- (void)_updateState;
- (void)_toggleState;
@end

@interface FBSSceneSettings : NSObject
@end

@interface FBSMutableSceneSettings : FBSSceneSettings
@property(nonatomic, getter=isBackgrounded) BOOL backgrounded;
@end


@interface BBAction : NSObject
+ (BBAction *)actionWithLaunchBundleID:(id)arg1;
@end

@interface APSIncomingMessage :NSObject
- (id)initWithTopic:(id)arg1 userInfo:(NSDictionary *)arg2;
@end

@interface SBRemoteNotificationServer
+(id)sharedInstance;
-(void)registerForMessageName:(NSString*)messageName target:(id)target selector:(SEL)selector;
@end

@interface VolumeControl
+ (VolumeControl *)sharedVolumeControl;
- (void)decreaseVolume;
- (void)increaseVolume;
- (void)cancelVolumeEvent;
@end

@interface CPDistributedMessagingCenter : NSObject
+(CPDistributedMessagingCenter*)centerNamed:(NSString*)serverName;
-(void)registerForMessageName:(NSString*)messageName target:(id)target selector:(SEL)selector;
-(void)runServerOnCurrentThread;
@end

@interface BBBulletin
{
	BBContent * _content;
}
//@property(copy, nonatomic) NSString *sectionID; // @dynamic sectionID;
//@property (nonatomic, copy) NSString *title;

//@property(copy, nonatomic) NSString *message; // @dynamic title;
@property(retain, nonatomic) NSDate *date;
//@property(copy, nonatomic) NSString *bulletinID;
@property(retain, nonatomic) NSDate *publicationDate;
@property(retain, nonatomic) NSDate *lastInterruptDate;
@property(nonatomic) BOOL showsMessagePreview;
@property(nonatomic) BOOL clearable;
//@property (nonatomic, copy) NSString *subtitle;
//@property (nonatomic, readonly) NSString *sectionDisplayName;
//@property (nonatomic, readonly) NSString *topic;
//@property (readonly, copy) NSString *description;
//@property (nonatomic, readonly) NSString *fullAlternateActionLabel;
@property (nonatomic, retain) BBContent *content;
@property (nonatomic, retain) NSDate *expirationDate;
@property(copy, nonatomic) BBSound *sound; // @dynamic defaultAction;


@property	(nonatomic,	readonly)	NSString	*alternateActionLabel;
@property	(nonatomic,	readonly)	NSString	*bannerAccessoryRemoteServiceBundleIdentifier;
@property	(nonatomic,	readonly)	NSString	*bannerAccessoryRemoteViewControllerClassName;
@property	(nonatomic,	copy)	NSString	*bulletinID;
@property	(nonatomic,	copy)	NSString	*bulletinVersionID;
@property	(readonly,	copy)	NSString	*debugDescription;
@property	(readonly,	copy)	NSString	*description;
@property	(nonatomic,	copy)	NSString	*dismissalID;
@property	(nonatomic,	readonly)	NSString	*fullAlternateActionLabel;
@property	(nonatomic,	readonly)	NSString	*fullUnlockActionLabel;
@property	(nonatomic,	copy)	NSString	*message;
@property	(nonatomic,	readonly)	NSString	*missedBannerDescriptionFormat;
@property	(nonatomic,	copy)	NSString	*parentSectionID;
@property	(nonatomic,	copy)	NSString	*publisherBulletinID;
@property	(nonatomic,	copy)	NSString	*recordID;
@property	(nonatomic,	readonly)	NSString	*secondaryContentRemoteServiceBundleIdentifier;
@property	(nonatomic,	readonly)	NSString	*secondaryContentRemoteViewControllerClassName;
@property	(nonatomic,	copy)	NSString	*section;
@property	(nonatomic,	readonly)	NSString	*sectionDisplayName;
@property	(nonatomic,	copy)	NSString	*sectionID;
@property	(nonatomic,	copy)	NSString	*subtitle;
@property	(nonatomic,	copy)	NSString	*title;
@property	(nonatomic,	readonly)	NSString	*topic;
@property	(nonatomic,	copy)	NSString	*universalSectionID;
@property	(nonatomic,	readonly)	NSString	*unlockActionLabel;
@property	(nonatomic,	copy)	NSString	*unlockActionLabelOverride;
@property (nonatomic, readonly) BOOL suppressesTitle;

@end