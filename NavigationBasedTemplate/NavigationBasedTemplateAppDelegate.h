//
//  NavigationBasedTemplateAppDelegate.h
//  NavigationBasedTemplate
//
//  Created by Pavel Pavlusha on 3/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NavigationBasedTemplateAppDelegate : NSObject <UIApplicationDelegate, AVAudioPlayerDelegate, UIAlertViewDelegate> 
{
    AVAudioPlayer *player;
    
    NSMutableArray *localNotificationsForSnooze;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
