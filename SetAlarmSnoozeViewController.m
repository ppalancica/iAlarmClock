//
//  SetAlarmSnoozeViewController.m
//  iAlarmClock
//
//  Created by Mac on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetAlarmSnoozeViewController.h"
#import "CustomCellBackground.h"

@implementation SetAlarmSnoozeViewController

@synthesize snoozeTimesArray = _snoozeTimesArray;

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
    self.title = @"Snooze";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    currentSnoozeMinutes = [defaults integerForKey:@"NewAlarmSnooze"];
    
    NSMutableArray *snoozes = [[NSMutableArray alloc] 
                                    initWithObjects:@"1 minute",
                                        @"2 minutes", 
                                        @"5 minutes",                                                
                                        @"10 minutes",
                                        @"15 minutes",
                                        @"30 minutes",
                                        @"None",
                                    nil];
    self.snoozeTimesArray = snoozes;
    [snoozes release];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [_snoozeTimesArray release];
    _snoozeTimesArray = nil;
    [tableViewAlarmSnooze release];
    tableViewAlarmSnooze = nil;
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
    [_snoozeTimesArray release];
    [tableViewAlarmSnooze release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 7;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.backgroundView = [[[CustomCellBackground alloc] init] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    } 
    
    // Configure the cell.
    
    cell.textLabel.text = [self.snoozeTimesArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (currentSnoozeMinutes) 
    {
        case 0:
            if (indexPath.row == 6) cell.accessoryType = UITableViewCellAccessoryCheckmark;    
            break;
            
        case 1:
            if (indexPath.row == 0) cell.accessoryType = UITableViewCellAccessoryCheckmark;    
            break;
            
        case 2:
            if (indexPath.row == 1) cell.accessoryType = UITableViewCellAccessoryCheckmark;    
            break;
            
        case 5:
            if (indexPath.row == 2) cell.accessoryType = UITableViewCellAccessoryCheckmark;    
            break;
            
        case 10:
            if (indexPath.row == 3) cell.accessoryType = UITableViewCellAccessoryCheckmark;    
            break;
        
        case 15:
            if (indexPath.row == 4) cell.accessoryType = UITableViewCellAccessoryCheckmark;    
            break;
            
        case 30:
            if (indexPath.row == 5) cell.accessoryType = UITableViewCellAccessoryCheckmark;    
            break;
            
        default:
            break;
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    switch (indexPath.row) 
    {
        case 0:
            currentSnoozeMinutes = 1;
            break;
            
        case 1:
            currentSnoozeMinutes = 2;
            break;
            
        case 2:
            currentSnoozeMinutes = 5;
            break;
            
        case 3:
            currentSnoozeMinutes = 10;
            break;
            
        case 4:
            currentSnoozeMinutes = 15;
            break;
            
        case 5:
            currentSnoozeMinutes = 30;
            break;
            
        case 6:
            currentSnoozeMinutes = 0;
            break;
            
        default:
            break;
    }
    
    [defaults setInteger:currentSnoozeMinutes forKey:@"NewAlarmSnooze"];
    [defaults synchronize];
       
    [tableViewAlarmSnooze reloadData];
}

@end
