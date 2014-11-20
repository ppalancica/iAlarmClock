//
//  RootViewController.m
//  NavigationBasedTemplate
//
//  Created by Pavel Pavlusha on 3/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "Utilities.h"
#import "SettingsViewController.h"

@interface RootViewController()

- (void)initLabelsAndFonts;
- (void)setCurrentThemeColor;
- (void)highlightTodayDayShortName;
- (void)setTodayDateLabelText;

- (void)changeTimeDisplayDigits;

- (void)showOrHideControls;

- (void)startSecondsTimer;
- (void)stopSecondsTimer;
- (void)setLocationsForPortraitOrientation;
- (void)setLocationsForLandskapeOrientation;

- (void)changeBellsOpacity;
- (void)refresh;

@end


@implementation RootViewController

- (BOOL)canBecomeFirstResponder 
{
    return YES; 
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event 
{
    if (event.subtype == UIEventSubtypeMotionShake) 
    {
        if (shakeIsEnabled) 
        {
            UIView *lightView = [self.view viewWithTag:999];
            
            if (lightIsOn)
            {
                lightView.hidden = YES;
                lightIsOn = NO;
            }
            else
            {
                lightView.hidden = NO;
                lightIsOn = YES;
            }
        }    
    }  
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (!lightIsOn && slideFingerIsEnabled)
    {
        UITouch *touch = [touches anyObject]; 
        pointTouchStarted = [touch locationInView:self.view];  
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{   
    if (!lightIsOn && slideFingerIsEnabled)
    {
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self.view];
        
        UIView *dimView = [self.view viewWithTag:1000];
        
        if (dimView.alpha < 0.9f && currentPoint.y > pointTouchStarted.y) 
        {
            dimView.alpha += 0.01f;        
        }
        else if (dimView.alpha > 0.0f && currentPoint.y < pointTouchStarted.y) 
        {
            dimView.alpha -= 0.01f;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{   
}

// Private methods start

- (void)initLabelsAndFonts
{
    sunday.tag = 1;
    monday.tag = 2;
    tuesday.tag = 3;
    wednesday.tag = 4;
    thursday.tag = 5;
    friday.tag = 6;
    saturday.tag = 7;
    
    labelAmPm.font = [UIFont fontWithName:@"DS-Digital-Bold" size:30];
    
    hourFirstDigitBackground.font = hourSecondDigitBackground.font = twoPointsBackground.font = minuteFirstDigitBackground.font = minuteSecondDigitBackground.font = currentHourFirstDigit.font = currentHourSecondDigit.font = twoPoints.font = currentMinuteFirstDigit.font = currentMinuteSecondDigit.font = [UIFont fontWithName:@"DS-Digital-Italic" size:120];
    
    secondFirstDigitBackground.font = secondSecondDigitBackground.font = currentSecondFirstDigit.font = currentSecondSecondDigit.font = [UIFont fontWithName:@"DS-Digital-Italic" size:50];
    
    monday.font = tuesday.font = wednesday.font = thursday.font = friday.font = saturday.font = sunday.font = [UIFont fontWithName:@"DS-Digital-Bold" size:20];
    
    hourFirstDigitBackground.alpha = hourSecondDigitBackground.alpha = twoPointsBackground.alpha = minuteFirstDigitBackground.alpha = minuteSecondDigitBackground.alpha = secondFirstDigitBackground.alpha = secondSecondDigitBackground.alpha = 0.2f;
    
    currentHourFirstDigit.alpha = currentHourSecondDigit.alpha = twoPoints.alpha = currentMinuteFirstDigit.alpha = currentMinuteSecondDigit.alpha = currentSecondFirstDigit.alpha = currentSecondSecondDigit.alpha = 0.8f;
    
    labelTodayDate.font = [UIFont fontWithName:@"DS-Digital-Italic" size:16];
    
    [self highlightTodayDayShortName];
}

- (void)setCurrentThemeColor
{
    labelTodayDate.textColor = hourFirstDigitBackground.textColor = hourSecondDigitBackground.textColor = twoPointsBackground.textColor = minuteFirstDigitBackground.textColor = minuteSecondDigitBackground.textColor = secondFirstDigitBackground.textColor = secondSecondDigitBackground.textColor =  currentHourFirstDigit.textColor = currentHourSecondDigit.textColor = twoPoints.textColor = currentMinuteFirstDigit.textColor = currentMinuteSecondDigit.textColor = currentSecondFirstDigit.textColor = currentSecondSecondDigit.textColor = monday.textColor = tuesday.textColor = wednesday.textColor = thursday.textColor = friday.textColor = saturday.textColor = sunday.textColor = labelAmPm.textColor = [Utilities currentThemeColor];
}

- (void)highlightTodayDayShortName
{
    monday.alpha = tuesday.alpha = wednesday.alpha = thursday.alpha = friday.alpha = saturday.alpha = sunday.alpha = 0.3f;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
//    [dateFormatter setWeekdaySymbols:[NSArray arrayWithObjects:@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat",  nil]];
    [dateFormatter setDateFormat:@"EE"];
    dateFormatter.locale = [NSLocale systemLocale];
   
    // Sunday == 1, Monday == 2 ...
    NSInteger todayDayIndex = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
    
    [self.view viewWithTag:todayDayIndex].alpha = 1.0f;
    
    [dateFormatter release];
}

- (void)setTodayDateLabelText
{
    // Show the current Date Month Year    
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.locale = [NSLocale currentLocale];    
    [dateFormatter setMonthSymbols:[NSArray arrayWithObjects:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil]];
    labelTodayDate.text = [NSString stringWithFormat:@"%d %@ %d", day, [[dateFormatter monthSymbols] objectAtIndex:month - 1], year];
    
    [calendar release];
    [dateFormatter release];
}

- (void)changeTimeDisplayDigits
{
    NSLog(@"%s", __FUNCTION__);
    
    NSDate *currentTime = [NSDate date];   
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:currentTime];
    
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    
    [gregorian release];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // show or hide the AM/PM label and change the hour digits accordingly
    if ([defaults boolForKey:@"Show24HourTime"] == YES) 
    {      
        // do it for hours digits
        if (hour / 10 == 1)
        {
            [currentHourFirstDigit setCenter:CGPointMake(55 + 5, currentHourFirstDigit.center.y)];
        }
        else 
        {
            [currentHourFirstDigit setCenter:CGPointMake(55, currentHourFirstDigit.center.y)];
        }
        
        if (hour % 10 == 1) 
        {
            [currentHourSecondDigit setCenter:CGPointMake(115 + 5, currentHourSecondDigit.center.y)];
        }
        else 
        {
            [currentHourSecondDigit setCenter:CGPointMake(115, currentHourSecondDigit.center.y)];
        }  
        
        currentHourFirstDigit.text = [NSString stringWithFormat:@"%d", hour / 10];
        currentHourSecondDigit.text = [NSString stringWithFormat:@"%d", hour % 10];    
        labelAmPm.text = @"";
    } 
    else 
    {
        currentHourFirstDigit.text = [NSString stringWithFormat:@"%d", (hour > 12) ? (hour - 12) / 10 : hour / 10 ];
        currentHourSecondDigit.text = [NSString stringWithFormat:@"%d", (hour > 12) ? (hour - 12) % 10 : hour % 10];    
        
        // do it for hours digits
        if ([currentHourFirstDigit.text isEqualToString:@"1"]) 
        {
            [currentHourFirstDigit setCenter:CGPointMake(55 + 5, currentHourFirstDigit.center.y)];
        } 
        else 
        {
            [currentHourFirstDigit setCenter:CGPointMake(55, currentHourFirstDigit.center.y)];
        }
        
        if ([currentHourSecondDigit.text isEqualToString:@"1"]) 
        {
            [currentHourSecondDigit setCenter:CGPointMake(115 + 5, currentHourSecondDigit.center.y)];
        }
        else 
        {
            [currentHourSecondDigit setCenter:CGPointMake(115, currentHourSecondDigit.center.y)];
        }  
                
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];  
        dateFormatter.locale = [NSLocale currentLocale];
        [dateFormatter setAMSymbol:@"AM"];
        [dateFormatter setPMSymbol:@"PM"];            
        [dateFormatter setDateFormat:@"a"];   
        labelAmPm.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:currentTime]];   
        [dateFormatter release];         
    }      
    
    // do it for minutes digits    
    if (minute / 10 == 1) 
    {
        [currentMinuteFirstDigit setCenter:CGPointMake(205 + 5, currentMinuteFirstDigit.center.y)];
    } 
    else 
    {
        [currentMinuteFirstDigit setCenter:CGPointMake(205, currentMinuteFirstDigit.center.y)];
    }
    
    if (minute % 10 == 1) 
    {
        [currentMinuteSecondDigit setCenter:CGPointMake(265 + 5, currentMinuteSecondDigit.center.y)];
    } 
    else 
    {
        [currentMinuteSecondDigit setCenter:CGPointMake(265, currentMinuteSecondDigit.center.y)];
    }
    
    currentMinuteFirstDigit.text = [NSString stringWithFormat:@"%d", minute / 10];    
    currentMinuteSecondDigit.text = [NSString stringWithFormat:@"%d", minute % 10];
    
    // do it for seconds digits
    if (second / 10 == 1) 
    {
        [currentSecondFirstDigit setCenter:CGPointMake(147 + 4, currentSecondFirstDigit.center.y)];
    } 
    else 
    {
        [currentSecondFirstDigit setCenter:CGPointMake(147, currentSecondFirstDigit.center.y)];
    }
    
    if (second % 10 == 1) 
    {
        [currentSecondSecondDigit setCenter:CGPointMake(172 + 4, currentSecondSecondDigit.center.y)];
    } 
    else 
    {
        [currentSecondSecondDigit setCenter:CGPointMake(172, currentSecondSecondDigit.center.y)];
    }
    
    currentSecondFirstDigit.text = [NSString stringWithFormat:@"%d", second / 10]; 
    currentSecondSecondDigit.text = [NSString stringWithFormat:@"%d", second % 10]; 
    
    // change Current Day label
    if ((second % 60 == 0) && (minute % 60 == 0) && (hour % 12 == 0))
    {
        [self highlightTodayDayShortName];
        [self setTodayDateLabelText];
    }
}

- (void)showOrHideControls
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];   
    
    if ([defaults boolForKey:@"ShowSeconds"] == YES)
    {
        secondFirstDigitBackground.hidden = NO;
        secondSecondDigitBackground.hidden = NO;
        currentSecondFirstDigit.hidden = NO;
        currentSecondSecondDigit.hidden = NO;
    }
    else
    {
        secondFirstDigitBackground.hidden = YES;
        secondSecondDigitBackground.hidden = YES;
        currentSecondFirstDigit.hidden = YES;
        currentSecondSecondDigit.hidden = YES;        
    }
    
    if ([defaults boolForKey:@"ShowWeekdays"] == YES)
    {
        monday.hidden = NO;
        tuesday.hidden = NO;
        wednesday.hidden = NO;
        thursday.hidden = NO;
        friday.hidden = NO;
        saturday.hidden = NO;
        sunday.hidden = NO;
    }
    else
    {
        monday.hidden = YES;
        tuesday.hidden = YES;
        wednesday.hidden = YES;
        thursday.hidden = YES;
        friday.hidden = YES;
        saturday.hidden = YES;
        sunday.hidden = YES;
    }
    
    if ([defaults boolForKey:@"ShowNextAlarm"] == YES)
    {
        bellMonday.hidden = NO;
        bellTuesday.hidden = NO;
        bellWednesday.hidden = NO;
        bellThursday.hidden = NO;
        bellFriday.hidden = NO;
        bellSaturday.hidden = NO;
        bellSunday.hidden = NO;
    }
    else
    {
        bellMonday.hidden = YES;
        bellTuesday.hidden = YES;
        bellWednesday.hidden = YES;
        bellThursday.hidden = YES;
        bellFriday.hidden = YES;
        bellSaturday.hidden = YES;
        bellSunday.hidden = YES;
    }
    
    if ([defaults boolForKey:@"Show24HourTime"] == YES)
    {
        labelAmPm.hidden = YES;
    }
    else
    {
        labelAmPm.hidden = NO;
    }
}

- (void)startSecondsTimer
{
    NSLog(@"%s", __FUNCTION__);
    
    secondsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 
                                     target:self 
                                   selector:@selector(changeTimeDisplayDigits) 
                                   userInfo:nil 
                                    repeats:YES];
}

- (void)stopSecondsTimer
{
    NSLog(@"%s", __FUNCTION__);
    
    [secondsTimer invalidate];
    secondsTimer = nil;
}

- (void)changeBellsOpacity
{
    NSMutableArray *alarmsData = [[NSMutableArray alloc] initWithContentsOfFile:[Utilities alarmsDataFilePath]];
    
    BOOL isOnMo, isOnTu, isOnWe, isOnTh, isOnFr, isOnSa, isOnSu;       
    isOnMo = isOnTu = isOnWe = isOnTh = isOnFr = isOnSa = isOnSu = NO;
    
    for (int i = 0; i < alarmsData.count; i++) 
    {
        NSDictionary *dictAlarmInfo = [alarmsData objectAtIndex:i];
        NSArray *repeatDays = [dictAlarmInfo objectForKey:@"NewAlarmRepeatDays"];
        
        for (NSString *object in repeatDays) 
        {
            if ([object isEqualToString:@"Monday"])
            {       
                isOnMo = YES;
            }
            else if ([object isEqualToString:@"Tuesday"])
            {       
                isOnTu = YES;
            }
            else if ([object isEqualToString:@"Wednesday"])
            {       
                isOnWe = YES;
            }
            else if ([object isEqualToString:@"Thursday"])
            {       
                isOnTh = YES;
            }
            else if ([object isEqualToString:@"Friday"])
            {       
                isOnFr = YES;
            }
            else if ([object isEqualToString:@"Saturday"])
            {       
                isOnSa = YES;
            }
            else if ([object isEqualToString:@"Sunday"])
            {       
                isOnSu = YES;
            }
        }
    }
    
    bellMonday.alpha = (isOnMo) ? 1.0f : 0.3f;
    bellTuesday.alpha = (isOnTu) ? 1.0f : 0.3f;
    bellWednesday.alpha = (isOnWe) ? 1.0f : 0.3f;
    bellThursday.alpha = (isOnTh) ? 1.0f : 0.3f;
    bellFriday.alpha = (isOnFr) ? 1.0f : 0.3f;
    bellSaturday.alpha = (isOnSa) ? 1.0f : 0.3f;
    bellSunday.alpha = (isOnSu) ? 1.0f : 0.3f;
}

- (void)refresh
{
    [Utilities reScheduleAlarms];
    
    [self changeBellsOpacity];
    
    NSLog(@"%s", __FUNCTION__);
}

// Private methods end


- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"AlarmFired" object:nil];
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    [self initLabelsAndFonts];

    UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    dimView.tag = 1000;
    dimView.alpha = 0.0f;
    dimView.backgroundColor = [UIColor blackColor];
    dimView.userInteractionEnabled = NO;
    [self.view addSubview:dimView];

    UIView *lightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    lightView.tag = 999;
    lightView.hidden = YES;
    lightView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lightView];
}

- (void)viewWillAppear:(BOOL)animated
{
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    
//    if (UIInterfaceOrientationIsPortrait(orientation))
//    {
//        [self setLocationsForPortraitOrientation];
//    }
//    else
//    {
//        [self setLocationsForLandskapeOrientation];
//    }
    
    lightIsOn = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *themeColorName = [defaults stringForKey:@"theme_color_name"];
    
    if (!themeColorName)
    {
        themeColorName = @"green";
        
        [defaults setObject:themeColorName forKey:@"theme_color_name"];
        [defaults synchronize];
    }
    
    shakeIsEnabled = [defaults boolForKey:@"ShakeToLight"];
    slideFingerIsEnabled = [defaults boolForKey:@"SlideFinger"];
    
    [buttonSettings setImage:[UIImage imageNamed:[NSString stringWithFormat:@"setting_buttons/%@.png", themeColorName]] forState:UIControlStateNormal];
    
    [self showOrHideControls];
    [self changeBellsOpacity];
    
    [super viewWillAppear:animated];
    
    [self highlightTodayDayShortName];
    [self setTodayDateLabelText];
    
    [self setCurrentThemeColor];
    [self changeTimeDisplayDigits];    
    [self startSecondsTimer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self stopSecondsTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	// Return YES for supported orientations.
//    if (lightIsOn)
//    {
//        return NO;
//    }
//    
//    return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setLocationsForPortraitOrientation
{
    hourFirstDigitBackground.center = CGPointMake(55, 180);
    currentHourFirstDigit.center = CGPointMake(55, 180);
    hourSecondDigitBackground.center = CGPointMake(115, 180);
    currentHourSecondDigit.center = CGPointMake(115, 180);
    
    twoPointsBackground.center = CGPointMake(160, 180);
    twoPoints.center = CGPointMake(160, 180);
    
    minuteFirstDigitBackground.center = CGPointMake(205, 180);
    currentMinuteFirstDigit.center = CGPointMake(205, 180);
    minuteSecondDigitBackground.center = CGPointMake(265, 180);
    currentMinuteSecondDigit.center = CGPointMake(265, 180);
    
    labelAmPm.center = CGPointMake(272, 115);
    
    secondFirstDigitBackground.center = CGPointMake(147, 255);
    currentSecondFirstDigit.center = CGPointMake(147, 255);
    secondSecondDigitBackground.center = CGPointMake(172, 255);
    currentSecondSecondDigit.center = CGPointMake(172, 255);
    
    monday.center = CGPointMake(52, 295);
    tuesday.center = CGPointMake(87, 295);
    wednesday.center = CGPointMake(122, 295);
    thursday.center = CGPointMake(157, 295);
    friday.center = CGPointMake(192, 295);
    saturday.center = CGPointMake(227, 295);
    sunday.center = CGPointMake(262, 295);

    labelTodayDate.center = CGPointMake(160, 30);
    buttonSettings.center = CGPointMake(160, 458);
}

- (void)setLocationsForLandskapeOrientation
{
    hourFirstDigitBackground.center = CGPointMake(100, 120);
    currentHourFirstDigit.center = CGPointMake(100, 120);
    hourSecondDigitBackground.center = CGPointMake(160, 120);
    currentHourSecondDigit.center = CGPointMake(160, 120);
    
    twoPointsBackground.center = CGPointMake(205, 120);
    twoPoints.center = CGPointMake(205, 120);
    
    minuteFirstDigitBackground.center = CGPointMake(250, 120);
    currentMinuteFirstDigit.center = CGPointMake(250, 120);
    minuteSecondDigitBackground.center = CGPointMake(310, 120);
    currentMinuteSecondDigit.center = CGPointMake(310, 120);
    
    labelAmPm.center = CGPointMake(385, 100);
    
    secondFirstDigitBackground.center = CGPointMake(370, 140);
    currentSecondFirstDigit.center = CGPointMake(370, 140);
    secondSecondDigitBackground.center = CGPointMake(395, 140);
    currentSecondSecondDigit.center = CGPointMake(395, 140);

    monday.center = CGPointMake(100, 190);
    tuesday.center = CGPointMake(135, 190);
    wednesday.center = CGPointMake(170, 190);
    thursday.center = CGPointMake(205, 190);
    friday.center = CGPointMake(240, 190);
    saturday.center = CGPointMake(275, 190);
    sunday.center = CGPointMake(310, 190);
    
    labelTodayDate.center = CGPointMake(220, 291);
    buttonSettings.center = CGPointMake(380, 291);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{   
    UIView *lightView = [self.view viewWithTag:999];
    UIView *dimView = [self.view viewWithTag:1000];
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || 
        toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.view.frame = CGRectMake(0, 0, 320, 480);
        lightView.frame = CGRectMake(0, 0, 320, 480);
        dimView.frame = CGRectMake(0, 0, 320, 480);
        [self setLocationsForPortraitOrientation];
    }
    else
    {
        self.view.frame = CGRectMake(0, 0, 480, 320);
        lightView.frame = CGRectMake(0, 0, 480, 320);
        dimView.frame = CGRectMake(0, 0, 480, 320);
        [self setLocationsForLandskapeOrientation];
    }
    
    [self.view setNeedsDisplay];
}
 
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    
//    if (orientation == UIInterfaceOrientationPortrait ||
//        orientation == UIInterfaceOrientationPortraitUpsideDown)
//    {
//        self.view.frame = CGRectMake(0, 0, 320, 480);
//    }
//    else
//    {
//        self.view.frame = CGRectMake(0, 0, 480, 320);
//    }
//    
//    [self.view setNeedsDisplay];
//}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [currentHourFirstDigit release];
    currentHourFirstDigit = nil;
    [currentHourSecondDigit release];
    currentHourSecondDigit = nil;
    [twoPoints release];
    twoPoints = nil;
    [currentMinuteFirstDigit release];
    currentMinuteFirstDigit = nil;
    [currentMinuteSecondDigit release];
    currentMinuteSecondDigit = nil;
    [hourFirstDigitBackground release];
    hourFirstDigitBackground = nil;
    [hourSecondDigitBackground release];
    hourSecondDigitBackground = nil;
    [twoPointsBackground release];
    twoPointsBackground = nil;
    [minuteFirstDigitBackground release];
    minuteFirstDigitBackground = nil;
    [minuteSecondDigitBackground release];
    minuteSecondDigitBackground = nil;
    [secondFirstDigitBackground release];
    secondFirstDigitBackground = nil;
    [currentSecondFirstDigit release];
    currentSecondFirstDigit = nil;
    [secondSecondDigitBackground release];
    secondSecondDigitBackground = nil;
    [currentSecondSecondDigit release];
    currentSecondSecondDigit = nil;
    [monday release];
    monday = nil;
    [tuesday release];
    tuesday = nil;
    [wednesday release];
    wednesday = nil;
    [thursday release];
    thursday = nil;
    [friday release];
    friday = nil;
    [saturday release];
    saturday = nil;
    [sunday release];
    sunday = nil;
    [labelTodayDate release];
    labelTodayDate = nil;
    [labelAmPm release];
    labelAmPm = nil;
    [buttonSettings release];
    buttonSettings = nil;
    [bellMonday release];
    bellMonday = nil;
    [bellTuesday release];
    bellTuesday = nil;
    [bellWednesday release];
    bellWednesday = nil;
    [bellThursday release];
    bellThursday = nil;
    [bellFriday release];
    bellFriday = nil;
    [bellSaturday release];
    bellSaturday = nil;
    [bellSunday release];
    bellSunday = nil;
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [currentHourFirstDigit release];
    [currentHourSecondDigit release];
    [twoPoints release];
    [currentMinuteFirstDigit release];
    [currentMinuteSecondDigit release];
    [hourFirstDigitBackground release];
    [hourSecondDigitBackground release];
    [twoPointsBackground release];
    [minuteFirstDigitBackground release];
    [minuteSecondDigitBackground release];
    [secondFirstDigitBackground release];
    [currentSecondFirstDigit release];
    [secondSecondDigitBackground release];
    [currentSecondSecondDigit release];
    [monday release];
    [tuesday release];
    [wednesday release];
    [thursday release];
    [friday release];
    [saturday release];
    [sunday release];
    [labelTodayDate release];
    [labelAmPm release];
    [buttonSettings release];
    [bellMonday release];
    [bellTuesday release];
    [bellWednesday release];
    [bellThursday release];
    [bellFriday release];
    [bellSaturday release];
    [bellSunday release];
    [super dealloc];
}

- (IBAction)onButtonSettingsTap:(id)sender 
{
    SettingsViewController *svc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:svc];
    
//    nc.navigationBarHidden = YES;
    [nc.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    nc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentModalViewController:nc animated:YES];
    
    [svc release];
    [nc autorelease];
}

@end
