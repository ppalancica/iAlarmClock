//
//  SetAlarmTimeViewController.h
//  iAlarmClock
//
//  Created by Mac on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetAlarmTimeViewController : UIViewController
{
    IBOutlet UIDatePicker *timePicker;

    IBOutlet UILabel *hourFirstDigit;
    IBOutlet UILabel *hourSecondDigit;
    
    IBOutlet UILabel *twoPoints;
    
    IBOutlet UILabel *minuteFirstDigit;
    IBOutlet UILabel *minuteSecondDigit;
}

- (IBAction)onAlarmTimeSet:(id)sender;


@end
