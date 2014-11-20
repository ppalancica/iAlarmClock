//
//  AddAlarmViewController.m
//  iAlarmClock
//
//  Created by Mac on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddAlarmViewController.h"
#import "CustomCellBackground.h"
#import "Utilities.h"
#import "SetAlarmTimeViewController.h"
#import "SetAlarmNameViewController.h"
#import "SetAlarmMelodyViewController.h"
#import "SetAlarmRepeatViewController.h"
#import "SetAlarmSnoozeViewController.h"

@interface AddAlarmViewController()

- (void)saveAlarm;
- (void)volumeChanged:(UISlider *)sender;

@end

@implementation AddAlarmViewController

// Private methods start

- (void)saveAlarm
{
    NSString *alarmsDataFilePath = [Utilities alarmsDataFilePath];
    NSMutableArray *arrayAlarmData;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:alarmsDataFilePath]) 
    {
        arrayAlarmData = [[NSMutableArray alloc] initWithContentsOfFile:alarmsDataFilePath];
    }
    else 
    {
        arrayAlarmData = [[NSMutableArray alloc] init];
    }  
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
//    localNotification.timeZone = [[NSCalendar currentCalendar] timeZone];
//    localNotification.timeZone = [NSTimeZone localTimeZone];
//    localNotification.timeZone = [NSTimeZone systemTimeZone];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    // Get the info from NSUserDefaults for the next alarm to be scheduled
	NSMutableDictionary *dictAlarmInfo = [NSMutableDictionary dictionary];
    NSDate *alarmTime = [defaults objectForKey:@"NewAlarmTime"];
    
    // Break the date up into components
//    NSCalendar *calendar = [NSCalendar currentCalendar]; 
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:alarmTime];
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:alarmTime];
    
    // Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
    [dateComps setMinute:[timeComponents minute]];
    //        [dateComps setSecond:[timeComponents second]];
    [dateComps setSecond:0];
    alarmTime = [calendar dateFromComponents:dateComps];
    //            localNotification.fireDate = alarmTime;
    [dateComps release];
    
    
	[dictAlarmInfo setObject:alarmTime 
                      forKey:@"NewAlarmTime"];    
    [dictAlarmInfo setObject:[defaults arrayForKey:@"NewAlarmRepeatDays"] 
                      forKey:@"NewAlarmRepeatDays"];
	[dictAlarmInfo setObject:[defaults objectForKey:@"NewAlarmName"] 
                      forKey:@"NewAlarmName"];
	[dictAlarmInfo setObject:[defaults stringForKey:@"NewAlarmMelody"] 
                      forKey:@"NewAlarmMelody"];
	[dictAlarmInfo setObject:[NSNumber numberWithFloat:[defaults floatForKey:@"NewAlarmVolume"]] 
                      forKey:@"NewAlarmVolume"];
    
    [dictAlarmInfo setObject:[NSNumber numberWithInteger:[defaults integerForKey:@"NewAlarmSnooze"]] 
                      forKey:@"NewAlarmSnooze"];
    
    localNotification.alertBody = [defaults stringForKey:@"NewAlarmName"];
    localNotification.soundName = [NSString stringWithFormat:@"%@.mp3", [defaults stringForKey:@"NewAlarmMelody"]];
    localNotification.userInfo = dictAlarmInfo;
    
    if ([defaults integerForKey:@"NewAlarmSnooze"] != 0)
    {
        localNotification.alertAction = @"Snooze";
    }
    else
    {
        localNotification.alertAction = @"View";
    }
        
    NSArray *repeatDayNames = [defaults arrayForKey:@"NewAlarmRepeatDays"];
    
    if ([repeatDayNames count] == 0)
    {
        // Set alarm for Today only
        unsigned unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSDateComponents *comp1 = [calendar components:unitFlags fromDate:alarmTime];
        NSDateComponents *comp2 = [calendar components:unitFlags fromDate:[NSDate date]];         
        
        if ([comp1 hour] < [comp2 hour] || 
            ([comp1 hour] == [comp2 hour] && [comp1 minute] <= [comp2 minute])) 
        {           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention!!!"
                                                            message:@"You have to specify a time in the future for the alarm!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            // Schedule alarm for today only    
            [arrayAlarmData addObject:dictAlarmInfo];
            [arrayAlarmData writeToFile:alarmsDataFilePath atomically:YES];
            
            localNotification.fireDate = alarmTime;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        // Set alarm for the specific selected days
        NSDate *mondayDateTime = alarmTime;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
        
        dateFormatter.locale = [NSLocale currentLocale];  
        [dateFormatter setWeekdaySymbols:[NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil]];
        [dateFormatter setDateFormat:@"EEEE"];

        NSString *dateString = [dateFormatter stringFromDate:alarmTime];
        [dateFormatter release];

                NSLog(@"azi este %@", dateString);
        
        int secondsPerDay = 60 * 60 * 24;
        
        if ([dateString isEqualToString:@"Monday"]) 
        {
        }
        else if ([dateString isEqualToString:@"Tuesday"]) 
        {
            mondayDateTime = [alarmTime dateByAddingTimeInterval:-secondsPerDay * 1];
        }
        else if ([dateString isEqualToString:@"Wednesday"]) 
        {
            mondayDateTime = [alarmTime dateByAddingTimeInterval:-secondsPerDay * 2];
        }
        else if ([dateString isEqualToString:@"Thursday"]) 
        {
            mondayDateTime = [alarmTime dateByAddingTimeInterval:-secondsPerDay * 3];
        }
        else if ([dateString isEqualToString:@"Friday"]) 
        {
            mondayDateTime = [alarmTime dateByAddingTimeInterval:-secondsPerDay * 4];
        }
        else if ([dateString isEqualToString:@"Saturday"]) {
            mondayDateTime = [alarmTime dateByAddingTimeInterval:-secondsPerDay * 5];
        }
        else if ([dateString isEqualToString:@"Sunday"]) {
            mondayDateTime = [alarmTime dateByAddingTimeInterval:-secondsPerDay * 6];
        }       
        
        //mondayDateTime = [mondayDateTime dateByAddingTimeInterval:-secondsPerDay];
        
        for (NSString *dayName in repeatDayNames) 
        {                
            localNotification.repeatInterval = NSWeekCalendarUnit;
            
            if ([dayName isEqualToString:@"Monday"])
            {        
                localNotification.fireDate = [mondayDateTime dateByAddingTimeInterval:secondsPerDay * 0];                        
            } 
            else if ([dayName isEqualToString:@"Tuesday"])
            {
                localNotification.fireDate = [mondayDateTime dateByAddingTimeInterval:secondsPerDay * 1];
            } 
            else if ([dayName isEqualToString:@"Wednesday"])
            {
                localNotification.fireDate = [mondayDateTime dateByAddingTimeInterval:secondsPerDay * 2];
            } 
            else if ([dayName isEqualToString:@"Thursday"])
            {
                localNotification.fireDate = [mondayDateTime dateByAddingTimeInterval:secondsPerDay * 3];
            }
            else if ([dayName isEqualToString:@"Friday"])
            {
                localNotification.fireDate = [mondayDateTime dateByAddingTimeInterval:secondsPerDay * 4];
            } 
            else if ([dayName isEqualToString:@"Saturday"])
            {
                localNotification.fireDate = [mondayDateTime dateByAddingTimeInterval:secondsPerDay * 5];
            }
            else if ([dayName isEqualToString:@"Sunday"])
            {
                localNotification.fireDate = [mondayDateTime dateByAddingTimeInterval:secondsPerDay * 6];
            }
            
            // This is in case the fire time is earlier than Today's time
            if ([localNotification.fireDate timeIntervalSince1970] < [[NSDate date] timeIntervalSince1970])
            {
                localNotification.fireDate = [localNotification.fireDate dateByAddingTimeInterval:secondsPerDay * 7];
            }
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Notification programmed %@", localNotification);
        } 
                
        [arrayAlarmData addObject:dictAlarmInfo];
        [arrayAlarmData writeToFile:alarmsDataFilePath atomically:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [arrayAlarmData release];
    [localNotification release];
}

- (void)volumeChanged:(UISlider *)sender
{   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setFloat:sender.value forKey:@"NewAlarmVolume"];
    [defaults synchronize];
}

// Private methods end

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title = @"Add Alarm";
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] 
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                             target:self
                                                             action:@selector(saveAlarm)];   
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [tableViewAlarmFeatures reloadData];
    
    [super viewWillAppear:YES];
}

- (void)viewDidUnload
{
    [tableViewAlarmFeatures release];
    tableViewAlarmFeatures = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    [tableViewAlarmFeatures release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 7;
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.backgroundView = [[[CustomCellBackground alloc] init] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        
        
        UILabel *labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, 45)];
        
        labelInfo.tag = 1;
        labelInfo.textAlignment = UITextAlignmentRight;
        labelInfo.font = [UIFont fontWithName:@"DS-Digital-Bold" size:22];   						  
        labelInfo.textColor = [Utilities currentThemeColor];
        labelInfo.backgroundColor = [UIColor clearColor]; 
        
        [cell addSubview:labelInfo];
        [labelInfo release];
        
        
        UISwitch *onOffSwitch = [[UISwitch alloc] init];
        
        onOffSwitch.frame = CGRectMake(195, 8, 94, 27);
        onOffSwitch.tag = 3;
        [onOffSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
        if ([onOffSwitch respondsToSelector:@selector(setOnTintColor:)])
        {
            onOffSwitch.frame = CGRectMake(215, 9, 94, 27);
            onOffSwitch.onTintColor = [Utilities currentThemeColor];
        }
        
        [cell addSubview:onOffSwitch];
        [onOffSwitch release];
        
        
        UISlider *volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(80, 10, 210, 27)]; 
        
        volumeSlider.tag = 4;
        [volumeSlider addTarget:self action:@selector(volumeChanged:) forControlEvents:UIControlEventValueChanged];
        
        if ([volumeSlider respondsToSelector:@selector(setMinimumTrackTintColor:)])
        {
            volumeSlider.minimumTrackTintColor = [Utilities currentThemeColor];
        }
        
        [cell addSubview:volumeSlider];
        [volumeSlider release];        
    } 
    
    // Configure the cell.
    
    [cell viewWithTag:1].hidden = YES;
    [cell viewWithTag:3].hidden = YES;
    [cell viewWithTag:4].hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Time";
            UILabel *labelTime = (UILabel *) [cell viewWithTag:1];
            labelTime.hidden = NO;
    
            NSDate *time = [defaults objectForKey:@"NewAlarmTime"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];                         
            
            dateFormatter.locale = [NSLocale currentLocale];
            [dateFormatter setAMSymbol:@"am"];
            [dateFormatter setPMSymbol:@"pm"];            
            [dateFormatter setDateFormat:@"hh:mm"];            
            
            labelTime.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:time]];
            [dateFormatter setDateFormat:@"a"];                
            labelTime.text = [NSString stringWithFormat:@"%@ %@", labelTime.text, [dateFormatter stringFromDate:time]];       
            
            [dateFormatter release];
            break;
            
        case 1:
            cell.textLabel.text = @"Repeat";
            
            UILabel *labelRepeatDays = (UILabel *) [cell viewWithTag:1];
            labelRepeatDays.hidden = NO;
            
            NSArray *repeatDayNames = [defaults arrayForKey:@"NewAlarmRepeatDays"];
            
            if ([repeatDayNames count] == 0)
            {
                labelRepeatDays.text = @"Today Only";
            }
            else if ([repeatDayNames count] == 7)
            {
                labelRepeatDays.text = @"Everyday";
            }
            else
            {
                NSString *repeatDaysShortNames = @"";
                
                for (int i = 0; i < repeatDayNames.count; i++)
                {
                    repeatDaysShortNames = [NSString stringWithFormat:@"%@ %@", repeatDaysShortNames, [[repeatDayNames objectAtIndex:i] substringToIndex:2]];
                }
                
                labelRepeatDays.text = repeatDaysShortNames;
            }
            
            break;
            
        case 2:
            cell.textLabel.text = @"Name";
            UILabel *labelName = (UILabel *) [cell viewWithTag:1];

            labelName.hidden = NO;
            labelName.text = [defaults stringForKey:@"NewAlarmName"];
            break;
            
        case 3:
            cell.textLabel.text = @"Melody";
            UILabel *labelMelody = (UILabel *) [cell viewWithTag:1];
            
            labelMelody.hidden = NO;
            labelMelody.text = [defaults stringForKey:@"NewAlarmMelody"];
            break;
            
        case 4:
            cell.textLabel.text = @"Volume";
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UISlider *volumeSlider = (UISlider *) [cell viewWithTag:4];

            volumeSlider.hidden = NO;
            volumeSlider.value = [defaults floatForKey:@"NewAlarmVolume"];
            
            break;
          
        case 5:
            cell.textLabel.text = @"Snooze";
            
            UILabel *labelSnooze = (UILabel *) [cell viewWithTag:1];
            
            labelSnooze.hidden = NO;
            NSInteger snoozeMinutes = [defaults integerForKey:@"NewAlarmSnooze"];
            
            if (snoozeMinutes == 0)
            {
                labelSnooze.text = @"None";
            }
            else 
            {
                labelSnooze.text = [NSString stringWithFormat:@"%d %@", snoozeMinutes, (snoozeMinutes == 1) ? @"minute" : @"minutes"];
            }
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetAlarmTimeViewController *vcTime;
    SetAlarmNameViewController *vcName;
    SetAlarmMelodyViewController *vcMelody;
    SetAlarmRepeatViewController *vcRepeat;
    SetAlarmSnoozeViewController *vcSnooze;
    
    switch (indexPath.row)
    {
        case 0:
            vcTime = [[SetAlarmTimeViewController alloc] init];
            [self.navigationController pushViewController:vcTime animated:YES];
            [vcTime release];
            break;
            
        case 1:
            vcRepeat = [[SetAlarmRepeatViewController alloc] init];
            [self.navigationController pushViewController:vcRepeat animated:YES];
            [vcRepeat release];
            break;
            
        case 2:
            vcName = [[SetAlarmNameViewController alloc] init];
            [self.navigationController pushViewController:vcName animated:YES];
            [vcName release];
            break;
            
        case 3:
            vcMelody = [[SetAlarmMelodyViewController alloc] init];
            [self.navigationController pushViewController:vcMelody animated:YES];
            [vcMelody release];
            break;
        
        case 5:
            vcSnooze = [[SetAlarmSnoozeViewController alloc] init];
            [self.navigationController pushViewController:vcSnooze animated:YES];
            [vcSnooze release];
            break;
            
        default:
            break;
    }
}

@end
