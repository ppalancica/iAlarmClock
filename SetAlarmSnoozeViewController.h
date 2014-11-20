//
//  SetAlarmSnoozeViewController.h
//  iAlarmClock
//
//  Created by Mac on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetAlarmSnoozeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSUInteger currentSnoozeMinutes;
    
    IBOutlet UITableView *tableViewAlarmSnooze;
}

@property (nonatomic, retain) NSMutableArray *snoozeTimesArray;

@end
