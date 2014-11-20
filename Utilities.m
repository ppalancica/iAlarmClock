//
//  Utilities.m
//  NavigationBasedTemplate
//
//  Created by Mac on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f \
        green:((rgbValue & 0xFF00) >> 8) / 255.0f \
        blue:(rgbValue & 0xFF) / 255.0f \
        alpha:1.0f]

@implementation Utilities

+ (UIColor *)currentThemeColor
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *themeColorName = [userDefaults stringForKey:@"theme_color_name"];
    
    UIColor *color;// = [UIColor greenColor];
    
    if ([themeColorName isEqualToString:@"red"])
    {
        color = [UIColor redColor];
    }
    else if ([themeColorName isEqualToString:@"green"])
    {
        color = [UIColor greenColor];
    }
    else if ([themeColorName isEqualToString:@"blue"])
    {
        color = [UIColor blueColor];
    }
    else if ([themeColorName isEqualToString:@"cyan"])
    {
        color = [UIColor cyanColor];
    }
    else if ([themeColorName isEqualToString:@"yellow"])
    {
//        color = [UIColor yellowColor];
        color = UIColorFromRGB(0xFFD700); 
    }
    else if ([themeColorName isEqualToString:@"magenta"])
    {
        color = [UIColor magentaColor];
    }
    else if ([themeColorName isEqualToString:@"orange"])
    {
        color = [UIColor orangeColor];
    }
    else if ([themeColorName isEqualToString:@"purple"])
    {
        color = [UIColor purpleColor];
    }
    else if ([themeColorName isEqualToString:@"chocolate"])
    {
        color = UIColorFromRGB(0xD2691E);
    }
//    else 
//    {
//        // the default theme
//        color = [UIColor greenColor];
//    }
    
    return color;
}

// returns the path to the file where the data is/will be saved
+ (NSString *)alarmsDataFilePath 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
//    NSLog(@"%@", [documentsDirectory stringByAppendingPathComponent:@"alarms_list.plist"]);
    return [documentsDirectory stringByAppendingPathComponent:@"alarms_list.plist"];
}

+ (void)reScheduleAlarms 
{
    NSLog(@"%s", __FUNCTION__);
    
    NSMutableArray *alarmsData = [[NSMutableArray alloc] initWithContentsOfFile:[[self class] alarmsDataFilePath]];
    
    for (int i = 0; i < alarmsData.count; i++) 
    {
        NSDictionary *dictAlarmInfo = [alarmsData objectAtIndex:i];
        NSDate *alarmTime = (NSDate *) [dictAlarmInfo objectForKey:@"NewAlarmTime"]; 
        NSArray *repeatDayNames = (NSArray *) [dictAlarmInfo objectForKey:@"NewAlarmRepeatDays"];
        
        
//        if (repeatDayNames.count == 0 && [alarmTime earlierDate:[NSDate date]])
        if (repeatDayNames.count == 0 && [alarmTime timeIntervalSince1970] < [[NSDate date] timeIntervalSince1970])
        {
            [alarmsData removeObjectAtIndex:i];
        }
    }
    
    [alarmsData writeToFile:[[self class] alarmsDataFilePath] atomically:YES];
    [alarmsData release];
}

@end
