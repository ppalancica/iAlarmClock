//
//  SettingsViewController.m
//  NavigationBasedTemplate
//
//  Created by Mac on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "Utilities.h"
#import "ThemeColorViewController.h"
#import "CustomCellBackground.h"
#import "CustomHeader.h"
#import "AddAlarmViewController.h"

@interface SettingsViewController()

- (void)switchChanged:(UISwitch *)sender;
- (void)dismissToRootViewController;
- (void)showSleepView;
- (void)refresh;

@end


@implementation SettingsViewController;

@synthesize alarmsData = _alarmsData;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    static int i = 0;
    
    if (i == 0)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
        ++i;
    }
    else
    {
        UIView *sleepView = [self.view viewWithTag:999];
        sleepView.alpha = 0.0f;
        
        self.navigationController.navigationBarHidden = NO;
        
        i = 0;
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AutoLock"])
        {
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            //        NSLog(@"Auto Lock is on");
        }
        else
        {
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            //         NSLog(@"Auto Lock is off");
        }
    }
}


// Private methods start

- (void)initAlarmsArray 
{ 
    NSString *alarmsDataFilePath = [Utilities alarmsDataFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:alarmsDataFilePath]) 
    {
        NSMutableArray *tmpArrayAlarms = [[NSMutableArray alloc] initWithContentsOfFile:alarmsDataFilePath];
        
        self.alarmsData = tmpArrayAlarms; 
        [tmpArrayAlarms release];
    }
}

- (void)switchChanged:(UISwitch *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *s = ((UITableViewCell *) [sender superview]).textLabel.text;
    
    if (sender.on)
    {
        if ([s isEqualToString:@"Show Seconds"])
        {
            [defaults setBool:YES forKey:@"ShowSeconds"];
        }
        else if ([s isEqualToString:@"Show Weekdays"])
        {
            [defaults setBool:YES forKey:@"ShowWeekdays"];
        }
        else if ([s isEqualToString:@"Show Next Alarm"])
        {
            [defaults setBool:YES forKey:@"ShowNextAlarm"];
        }
        else if ([s isEqualToString:@"24-hours Time"])
        {
            [defaults setBool:YES forKey:@"Show24HourTime"];
        }
        else if ([s isEqualToString:@"Slide Finger  ↓↑"])
        {
            [defaults setBool:YES forKey:@"SlideFinger"];
        }
        else if ([s isEqualToString:@"Shake To Light"])
        {
            [defaults setBool:YES forKey:@"ShakeToLight"];
        }
        else if ([s isEqualToString:@"Auto-Lock"])
        {
            [defaults setBool:YES forKey:@"AutoLock"];
        }
    }
    else
    {
        if ([s isEqualToString:@"Show Seconds"])
        {
            [defaults setBool:NO forKey:@"ShowSeconds"];
        }
        else if ([s isEqualToString:@"Show Weekdays"])
        {
            [defaults setBool:NO forKey:@"ShowWeekdays"];
        }
        else if ([s isEqualToString:@"Show Next Alarm"])
        {
            [defaults setBool:NO forKey:@"ShowNextAlarm"];
        }
        else if ([s isEqualToString:@"24-hours Time"])
        {
            [defaults setBool:NO forKey:@"Show24HourTime"];
        }
        else if ([s isEqualToString:@"Slide Finger  ↓↑"])
        {
            [defaults setBool:NO forKey:@"SlideFinger"];
        }
        else if ([s isEqualToString:@"Shake To Light"])
        {
            [defaults setBool:NO forKey:@"ShakeToLight"];
        }
        else if ([s isEqualToString:@"Auto-Lock"])
        {
            [defaults setBool:NO forKey:@"AutoLock"];
        }
    }
    
    [defaults synchronize];
    
    if ([defaults boolForKey:@"AutoLock"])
    {
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
//        NSLog(@"Auto Lock is on");
    }
    else
    {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
//         NSLog(@"Auto Lock is off");
    }
}

- (void)dismissToRootViewController
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)showSleepView
{
    UIView *sleepView = [self.view viewWithTag:999];
    
    sleepView.alpha = 1.0f;
    
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    
    // Turn Auo-Lock off
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
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

- (void)refresh
{
    [Utilities reScheduleAlarms];
    [self initAlarmsArray];
    [tableViewSettings reloadData];
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"AlarmFired" object:nil];
    
    self.title = @"Settings";
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
        
    UIView *sleepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    sleepView.tag = 999;
    sleepView.alpha = 0.0f;
    sleepView.backgroundColor = [UIColor blackColor];
    sleepView.userInteractionEnabled = YES;
    [self.view addSubview:sleepView];

    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] 
                                            initWithTitle:@"Clock" 
                                                    style:UIBarButtonItemStyleBordered 
                                                   target:self 
                                                   action:@selector(dismissToRootViewController)];    
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] 
//                                        initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
//                                                             target:self
//                                                             action:@selector(dismissToRootViewController)];   
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithTitle:@"Sleep" 
                                                      style:UIBarButtonItemStyleBordered 
                                                     target:self 
                                                     action:@selector(showSleepView)];    
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    [leftBarButtonItem release];
    [rightBarButtonItem release];
}

- (void)viewWillAppear:(BOOL)animated
{   
    [Utilities reScheduleAlarms];
    [self initAlarmsArray];
    [tableViewSettings reloadData];
}

- (void)viewDidUnload
{   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_alarmsData release];
    _alarmsData = nil;
    
    [tableViewSettings release];
    tableViewSettings = nil;
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
    [_alarmsData release];
    [tableViewSettings release];
    [super dealloc];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    
    if (section == 0)
    {
        title = @"Alarms";
    }
    else if (section == 1)
    {
        title = @"Display";
    }
    else if (section == 2)
    {
        title = @"Gesture Actions";
    }
    
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result;    
    
    switch (section)
    {
        case 0:
            result = 1 + self.alarmsData.count;
            break;

        case 1:
            result = 5;
            break;

        case 2:
            result = 3;
            break;
            
        default:
            result = 0;
            break;
    }
    
    return result;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    CustomHeader *header = [[[CustomHeader alloc] init] autorelease];
    
    header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
//    if (section % 2) {
//        header.lightColor = [UIColor colorWithRed:147.0/255.0 green:105.0/255.0 
//                                             blue:216.0/255.0 alpha:1.0];
//        header.darkColor = [UIColor colorWithRed:72.0/255.0 green:22.0/255.0 
//                                            blue:137.0/255.0 alpha:1.0];
//    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
    return 50;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)index
//{   
//    if ((index.section == 0 && index.row == 2) || (index.section == 1 && index.row == 6))
//    {
//        return 20;
//    }
//    else if (index.section != 0)// || (index.section == 0 && index.row == 1))
//    {
//        return 44;
//    }
//    
//    return 50;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row != 0)
    {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        // Cancel the notifications coresponding to that alarm
        NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        NSMutableArray *alarmsData = [[NSMutableArray alloc] initWithContentsOfFile:[Utilities alarmsDataFilePath]];
        
        NSDictionary *dictAlarmInfo = [alarmsData objectAtIndex:indexPath.row - 1];
        
        for (int i = 0; i < localNotifications.count; i++) 
        {
            UILocalNotification *localNotification = [localNotifications objectAtIndex:i];
            
            if ([localNotification.userInfo isEqualToDictionary:dictAlarmInfo])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
        
        [alarmsData removeObjectAtIndex:indexPath.row - 1];
        [alarmsData writeToFile:[Utilities alarmsDataFilePath] atomically:YES];
        [alarmsData release];
        
        [self initAlarmsArray];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
        //[tableViewSettings reloadData];
    }
}

// Customize the appearance of table view cells.
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
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        UISwitch *onOff = [[UISwitch alloc] init];
        onOff.frame = CGRectMake(195, 8, 94, 27);
        onOff.tag = 3;
        [onOff addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

        
        [cell addSubview:onOff];
        [onOff release];
        
        UILabel *labelAlarmName = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 220, 44)];
        
        labelAlarmName.tag = 1;
        labelAlarmName.textAlignment = UITextAlignmentLeft;
        labelAlarmName.backgroundColor = [UIColor clearColor]; 
        
        [cell addSubview:labelAlarmName];
        [labelAlarmName release];
        
        UILabel *labelRepeatDays = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, 220, 14)];
        
        labelRepeatDays.tag = 2;
        labelRepeatDays.textAlignment = UITextAlignmentLeft;
        labelRepeatDays.font = [UIFont fontWithName:@"DS-Digital-Bold" size:14];   					
        labelRepeatDays.textColor = [UIColor grayColor];
        labelRepeatDays.backgroundColor = [UIColor clearColor]; 
        
        [cell addSubview:labelRepeatDays];
        [labelRepeatDays release];
    } 
       
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row == 0))
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell.

    UISwitch *switchOnCell = (UISwitch *) [cell viewWithTag:3];
    
    switchOnCell.on = NO;
    switchOnCell.hidden = YES;
    
    if ([switchOnCell respondsToSelector:@selector(setOnTintColor:)])
    {
        switchOnCell.onTintColor = [Utilities currentThemeColor];
        switchOnCell.frame = CGRectMake(215, 8, 94, 27);
    }
    
    UILabel *labelAlarmName = (UILabel *) [cell viewWithTag:1];
    UILabel *labelRepeatDays = (UILabel *) [cell viewWithTag:2]; 
    
    labelAlarmName.hidden = YES;
    labelRepeatDays.hidden = YES;
    
    switch (indexPath.section)
    {
        case 0:
            
            switch (indexPath.row)
            {
                
                case 0:
                    cell.textLabel.text = @"Add Alarm";
                    break;
                    
                default:
                    labelAlarmName.hidden = NO;
                    labelRepeatDays.hidden = NO;
                    
                    NSDate *alarmTime = [((NSDictionary *) [self.alarmsData objectAtIndex:(indexPath.row - 1)]) objectForKey:@"NewAlarmTime"];
                    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
                    
                    [timeFormatter setDateFormat:@"HH:mm"];
                    cell.textLabel.textColor = [UIColor colorWithRed:0 green:0.77344 blue:1 alpha:1];
                    cell.textLabel.text = [NSString stringWithFormat:@"%@", [timeFormatter stringFromDate:alarmTime]];

                    labelAlarmName.text = [((NSDictionary *) [self.alarmsData objectAtIndex:(indexPath.row - 1)]) objectForKey:@"NewAlarmName"];
                    
                    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:(NSArray *) [((NSDictionary *) [self.alarmsData objectAtIndex:(indexPath.row - 1)]) objectForKey:@"NewAlarmRepeatDays"]];

                    NSString *daysShortNames = @"";
                    
                    if (tmpArray.count == 0)
                    {
                        daysShortNames = @"Today only";
                    }
                    else if (tmpArray.count == 7)
                    {
                        daysShortNames = @"Everyday";
                    }
                    else
                    {
                        for (int i = 0; i < tmpArray.count; i++)
                        {
                            daysShortNames = [daysShortNames stringByAppendingString:[[tmpArray objectAtIndex:i] substringToIndex:2]];
                            daysShortNames = [daysShortNames stringByAppendingString:@" "];
                        }
                    }
                    
                    labelRepeatDays.text = daysShortNames;
                    break;
            }
            
            break;
            
        case 1:
            
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"Theme Colors";
                    break;
                    
                case 1:
                    cell.textLabel.text = @"Show Seconds";
                    switchOnCell.hidden = NO;
                    
                    if ([defaults boolForKey:@"ShowSeconds"] == YES)
                    {
                        ((UISwitch *) [cell viewWithTag:3]).on = YES;
                    }
                    
                    break;

                case 2:
                    cell.textLabel.text = @"Show Weekdays";
                    switchOnCell.hidden = NO;
                    
                    if ([defaults boolForKey:@"ShowWeekdays"] == YES)
                    {
                        switchOnCell.on = YES;
                    }
                    
                    break;

                case 3:
                    cell.textLabel.text = @"Show Next Alarm";
                    switchOnCell.hidden = NO;
                    
                    if ([defaults boolForKey:@"ShowNextAlarm"] == YES)
                    {
                        switchOnCell.on = YES;
                    }
                    
                    break;
                    
                case 4:
                    cell.textLabel.text = @"24-hours Time";
                    switchOnCell.hidden = NO;
                    
                    if ([defaults boolForKey:@"Show24HourTime"] == YES)
                    {
                        switchOnCell.on = YES;
                    }
                    
                    break;
                    
                default:
                    break;
            }
            
            break;
        
        case 2:
            
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"Slide Finger  ↓↑";
                    switchOnCell.hidden = NO;
                    
                    if ([defaults boolForKey:@"SlideFinger"] == YES)
                    {
                        switchOnCell.on = YES;
                    }
                    
                    break;

                case 1:
                    cell.textLabel.text = @"Shake To Light";
                    switchOnCell.hidden = NO;
                    
                    if ([defaults boolForKey:@"ShakeToLight"] == YES)
                    {
                        switchOnCell.on = YES;
                    }
                    
                    break;

                case 2:
                    cell.textLabel.text = @"Auto-Lock";
                    switchOnCell.hidden = NO;
                    
                    if ([defaults boolForKey:@"AutoLock"] == YES)
                    {
                        switchOnCell.on = YES;
                    }
                    
                    break;

                default:
                    break;
            }
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [defaults setObject:[NSDate date] forKey:@"NewAlarmTime"];
        [defaults setObject:[NSArray array] forKey:@"NewAlarmRepeatDays"];
        [defaults setObject:@"Alarm" forKey:@"NewAlarmName"];
        [defaults setObject:@"Ascending" forKey:@"NewAlarmMelody"];
        [defaults setFloat:0.5f forKey:@"NewAlarmVolume"];
        [defaults setInteger:1 forKey:@"NewAlarmSnooze"];
        
        [defaults synchronize];
        
        AddAlarmViewController *vc = [[AddAlarmViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        ThemeColorViewController *tcvc = [[ThemeColorViewController alloc] init];
        
        [self.navigationController pushViewController:tcvc animated:YES];
        
        [tcvc release];
    }
}

@end
