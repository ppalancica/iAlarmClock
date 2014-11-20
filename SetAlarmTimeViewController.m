//
//  SetAlarmTimeViewController.m
//  iAlarmClock
//
//  Created by Mac on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetAlarmTimeViewController.h"
#import "Utilities.h"

@interface SetAlarmTimeViewController() 
- (void)setUpFonts;
- (void)setUpTime;
@end

@implementation SetAlarmTimeViewController

// Private methods start

- (void)setUpFonts
{
    // Set up the fonts of the time-digits to DS-Digital-Italic    
    [hourFirstDigit setFont:[UIFont fontWithName:@"DS-Digital-Italic" size:120]];    
    [hourSecondDigit setFont:[UIFont fontWithName:@"DS-Digital-Italic" size:120]];
    [minuteFirstDigit setFont:[UIFont fontWithName:@"DS-Digital-Italic" size:120]];    
    [minuteSecondDigit setFont:[UIFont fontWithName:@"DS-Digital-Italic" size:120]];
    
    [twoPoints setFont:[UIFont fontWithName:@"DS-Digital-Italic" size:120]];
    
    hourFirstDigit.textColor = hourSecondDigit.textColor = twoPoints.textColor = minuteFirstDigit.textColor = minuteSecondDigit.textColor = [Utilities currentThemeColor];//[UIColor colorWithRed:0 green:0.77344 blue:1 alpha:1]; 
}

- (void)setUpTime
{
    NSDate *currentTime = timePicker.date;//[[NSUserDefaults standardUserDefaults] objectForKey:@"time"];   
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:currentTime];
    
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    [gregorian release];
    
    // do it for hours digits
    if (hour / 10 == 1) 
    {
        [hourFirstDigit setCenter:CGPointMake(55 + 5, hourFirstDigit.center.y)];
    } 
    else 
    {
        [hourFirstDigit setCenter:CGPointMake(55, hourFirstDigit.center.y)];
    }
    
    if (hour % 10 == 1) 
    {
        [hourSecondDigit setCenter:CGPointMake(115 + 5, hourSecondDigit.center.y)];
    } 
    else 
    {
        [hourSecondDigit setCenter:CGPointMake(115, hourSecondDigit.center.y)];
    }    
    
    // do it for minutes digits    
    if (minute / 10 == 1) 
    {
        [minuteFirstDigit setCenter:CGPointMake(205 + 5, minuteFirstDigit.center.y)];
    } 
    else 
    {
        [minuteFirstDigit setCenter:CGPointMake(205, minuteFirstDigit.center.y)];
    }
    
    if (minute % 10 == 1)
    {
        [minuteSecondDigit setCenter:CGPointMake(265 + 5, minuteSecondDigit.center.y)];
    } 
    else 
    {
        [minuteSecondDigit setCenter:CGPointMake(265, minuteSecondDigit.center.y)];
    }    
    
    hourFirstDigit.text = [NSString stringWithFormat:@"%d", hour / 10];    
    hourSecondDigit.text = [NSString stringWithFormat:@"%d", hour % 10];    
    
    minuteFirstDigit.text = [NSString stringWithFormat:@"%d", minute / 10]; 
    minuteSecondDigit.text = [NSString stringWithFormat:@"%d", minute % 10]; 
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
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.title = @"Time";
    
    timePicker.date = [[NSUserDefaults standardUserDefaults] objectForKey:@"NewAlarmTime"];
    
    [self setUpFonts]; 
    [self setUpTime];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [timePicker release];
    timePicker = nil;
    [hourFirstDigit release];
    hourFirstDigit = nil;
    [hourSecondDigit release];
    hourSecondDigit = nil;
    [minuteFirstDigit release];
    minuteFirstDigit = nil;
    [minuteSecondDigit release];
    minuteSecondDigit = nil;
    [twoPoints release];
    twoPoints = nil;
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
    [timePicker release];
    [hourFirstDigit release];
    [hourSecondDigit release];
    [minuteFirstDigit release];
    [minuteSecondDigit release];
    [twoPoints release];
    [super dealloc];
}

- (IBAction)onAlarmTimeSet:(id)sender 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:timePicker.date forKey:@"NewAlarmTime"];
    [defaults synchronize];
    
    [self setUpTime];
}

@end
