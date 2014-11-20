//
//  ThemeColorViewController.h
//  iAlarmClock
//
//  Created by Mac on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeColorViewController : UIViewController
{
    NSArray *colorsArray;
    NSUInteger currentThemeIndex;
    
    IBOutlet UIImageView *imageViewTheme;
    IBOutlet UITableView *tableViewThemeColors;
}

@end
