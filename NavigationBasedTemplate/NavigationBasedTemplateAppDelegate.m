//
//  NavigationBasedTemplateAppDelegate.m
//  NavigationBasedTemplate
//
//  Created by Pavel Pavlusha on 3/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NavigationBasedTemplateAppDelegate.h"
#import "Utilities.h"

@implementation NavigationBasedTemplateAppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{  
    if (localNotificationsForSnooze == nil)
    {
        localNotificationsForSnooze = [[NSMutableArray alloc] init];
    }
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
//    self.window.backgroundColor = [UIColor darkGrayColor];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
} 

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    // Not necessary to fire the Alarm, just to refresh the Settings View
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AlarmFired" object:nil];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AutoLock"])
    {
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
    else
    {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [localNotificationsForSnooze release];
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notification 
{
    NSLog(@"notification = %@", notification);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AlarmFired" object:nil];
    
    if (app.applicationState == UIApplicationStateActive)
    {
        // Manually create the alert and start playing the song
//        NSLog(@"state == foreground");
        if ([player isPlaying])
        {
            [player stop];
            player = nil;
        }
        
        NSString *melodyName = [notification.userInfo objectForKey:@"NewAlarmMelody"];
        NSString *path = [[NSBundle mainBundle] pathForResource:melodyName ofType:@"mp3"];
        
        player = [[AVAudioPlayer alloc] 
                    initWithContentsOfURL:[NSURL fileURLWithPath:path]
                                    error:nil];
        
        player.numberOfLoops = -1;
        player.volume = [[notification.userInfo objectForKey:@"NewAlarmVolume"] floatValue];
        player.delegate = self;
        
        [player prepareToPlay];
        [player play];
        
        UIAlertView *alert;
        
        if ([[notification.userInfo objectForKey:@"NewAlarmSnooze"] integerValue] != 0)
        {
            alert = [[UIAlertView alloc] initWithTitle:@"iAlarmClock" 
                                               message:notification.alertBody
                                              delegate:self
                                     cancelButtonTitle:@"Close" 
                                     otherButtonTitles:@"Snooze", nil];
            
            [localNotificationsForSnooze addObject:[notification copy]];
        }
        else
        {
            alert = [[UIAlertView alloc] initWithTitle:@"iAlarmClock" 
                                               message:notification.alertBody
                                              delegate:self
                                     cancelButtonTitle:@"Ok" 
                                     otherButtonTitles: nil];
        }
        
        alert.tag = 1;
        
        [alert show];
        [alert release];
    }
    else
    {
        // The default behaviour, the system will display the alert and play the sound
        // This is reached after Snooze/View button was pressed
        // In case it was pressed Snooze, we need to reschedule it
//        NSLog(@"state == background");
        
        
        NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
        
        if (5 == [[versionCompatibility objectAtIndex:0] intValue]) 
        {
            // iOS5 is installed
            if ([[notification.userInfo objectForKey:@"NewAlarmSnooze"] integerValue] != 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iAlarmClock" 
                                                   message:notification.alertBody
                                                  delegate:self
                                         cancelButtonTitle:@"Close" 
                                         otherButtonTitles:@"Snooze", nil];
                [alert show];
                [alert release];
                
                [localNotificationsForSnooze addObject:[notification copy]];
            }
        } 
        else 
        { 
            // iOS4 is installed
            UILocalNotification *localNotification = [notification copy];
            
            if ([[notification.userInfo objectForKey:@"NewAlarmSnooze"] integerValue] != 0)
            {
                NSInteger snoozeMinutes = [[notification.userInfo objectForKey:@"NewAlarmSnooze"] integerValue];
                
                localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:(snoozeMinutes  * 60)];
                
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                [localNotification release];
                
                //            NSLog(@"Snooze Button Pressed");
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [player stop];
    player = nil;
    
    if (buttonIndex == 1)
    {
        // If needs to Snooze, reshedule the current alarm for a couple of minutes later
        UILocalNotification *localNotification = [localNotificationsForSnooze lastObject];
        NSInteger snoozeMinutes = [[localNotification.userInfo objectForKey:@"NewAlarmSnooze"] integerValue];
        
        localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:(snoozeMinutes * 60)];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        [localNotificationsForSnooze removeLastObject];
    }
}

@end
