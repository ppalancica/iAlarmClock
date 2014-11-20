//
//  SetAlarmRepeatViewController.h
//  iAlarmClock
//
//  Created by Mac on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetAlarmRepeatViewController : UIViewController
{
    IBOutlet UITableView *tableViewAlarmRepeatDays;
    
}

@property (nonatomic, retain) NSMutableArray *dayNames;
@property (nonatomic, retain) NSMutableArray *alarmRepeatDays;

@end
