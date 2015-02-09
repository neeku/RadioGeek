//
//  NIKAppDelegate.m
//  RadioGeek
//
//  Created by Neeku on 10/26/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKAppDelegate.h"

#import "NIKMasterViewController.h"
#import "NIKAudioManager.h"
#import "Flurry.h"

@implementation NIKAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override point for customization after application launch.
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
	    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
	    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
	    splitViewController.delegate = (id)navigationController.topViewController;
	    
	}
	//checks to see if the app is ever launched before or if it's the first launch.
	//so if the key 'everlaunched' is false, the code recognizes the app's first launch.
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
	}
	else
	{
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
	}
	//for iphone 3.5" and 4" displays
	self.window.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
	
	[Flurry startSession:@"ZS3H7JJ5K52RP7M67XZB"];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

//#pragma mark - Audio Player, Remote Control Events
//
////Make sure we can recieve remote control events
//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}
//
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl && currentAudioManager != nil)
	{
        if (event.subtype == UIEventSubtypeRemoteControlPlay)
		{
			[currentAudioManager playAudio];
			//            [[NIKDetailViewController sharedController].feedEntry.audioManager playAudio];
			
        }
		else if (event.subtype == UIEventSubtypeRemoteControlPause)
		{
            [currentAudioManager pauseAudio];
        }
		else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause)
		{
            [currentAudioManager togglePlayPause];
        }
		else if (event.subtype == UIEventSubtypeRemoteControlBeginSeekingBackward)
		{
			[currentAudioManager rewindTheAudio];
		}
		else if (event.subtype == UIEventSubtypeRemoteControlBeginSeekingForward)
		{
			[currentAudioManager fastForwardTheAudio];
		}
	}
}

#pragma mark - Application's directories

// Returns the URL to the application's Documents directory.
- (NSString *)applicationDocumentsDirectory
{
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	return documentsDirectory;
}

// Returns the path to the application's Support directory.
- (NSString *)applicationSupportDirectory
{
	NSString *appSupportDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    return appSupportDir;
}

@end
