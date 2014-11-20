//
//  SetAlarmNameViewController.m
//  iAlarmClock
//
//  Created by Mac on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetAlarmNameViewController.h"
#import "Utilities.h"

@implementation SetAlarmNameViewController

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.title = @"Name";    
    textFieldAlarmName.delegate = self;
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
     
    textFieldAlarmName.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [textFieldAlarmName setFont:[UIFont fontWithName:@"DS-Digital" size:18]];
    textFieldAlarmName.textColor = [Utilities currentThemeColor];
    
    if (![[defaults stringForKey:@"NewAlarmName"] isEqualToString:@"Alarm"])
    {
        textFieldAlarmName.text = [defaults stringForKey:@"NewAlarmName"];
    }
    else
    {
        textFieldAlarmName.text = @"Alarm";
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [textFieldAlarmName becomeFirstResponder];
}

- (void)viewDidUnload
{
    [textFieldAlarmName release];
    textFieldAlarmName = nil;
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
    [textFieldAlarmName release];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{   
    [textFieldAlarmName resignFirstResponder];
    
    return YES;
}

- (IBAction)setAlarmName:(id)sender 
{
    NSString *alarmName = textFieldAlarmName.text;
    
    if ([alarmName isEqualToString:@""])
    {
        alarmName = @"Alarm";
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:alarmName forKey:@"NewAlarmName"];
    [defaults synchronize];
}

@end
