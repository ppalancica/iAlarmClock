//
//  RootViewController.h
//  NavigationBasedTemplate
//
//  Created by Pavel Pavlusha on 3/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController 
{
    BOOL shakeIsEnabled;
    BOOL lightIsOn;
    
    BOOL slideFingerIsEnabled;
    CGPoint pointTouchStarted;
    
    NSTimer *secondsTimer;
    
    IBOutlet UILabel *labelAmPm;

    IBOutlet UILabel *hourFirstDigitBackground;
    IBOutlet UILabel *hourSecondDigitBackground;
    IBOutlet UILabel *twoPointsBackground;
    IBOutlet UILabel *minuteFirstDigitBackground;
    IBOutlet UILabel *minuteSecondDigitBackground;    
    IBOutlet UILabel *secondFirstDigitBackground;    
    IBOutlet UILabel *secondSecondDigitBackground;
       
    IBOutlet UILabel *currentHourFirstDigit;
    IBOutlet UILabel *currentHourSecondDigit;
    IBOutlet UILabel *twoPoints;
    IBOutlet UILabel *currentMinuteFirstDigit;
    IBOutlet UILabel *currentMinuteSecondDigit;    
    IBOutlet UILabel *currentSecondFirstDigit;
    IBOutlet UILabel *currentSecondSecondDigit;
    
    IBOutlet UILabel *monday;
    IBOutlet UILabel *tuesday;
    IBOutlet UILabel *wednesday;
    IBOutlet UILabel *thursday;
    IBOutlet UILabel *friday;
    IBOutlet UILabel *saturday;
    IBOutlet UILabel *sunday;
    
    IBOutlet UIImageView *bellMonday;
    IBOutlet UIImageView *bellTuesday;
    IBOutlet UIImageView *bellWednesday;
    IBOutlet UIImageView *bellThursday;
    IBOutlet UIImageView *bellFriday;
    IBOutlet UIImageView *bellSaturday;
    IBOutlet UIImageView *bellSunday;
    
    IBOutlet UILabel *labelTodayDate;
    IBOutlet UIButton *buttonSettings;
}

- (IBAction)onButtonSettingsTap:(id)sender;

@end
