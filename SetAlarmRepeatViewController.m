//
//  SetAlarmRepeatViewController.m
//  iAlarmClock
//
//  Created by Mac on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetAlarmRepeatViewController.h"
#import "CustomCellBackground.h"

@implementation SetAlarmRepeatViewController

@synthesize dayNames = _dayNames;
@synthesize alarmRepeatDays = _alarmRepeatDays;

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
    self.title = @"Repeat";
 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *days = [[NSMutableArray alloc] 
                                 initWithObjects:@"Monday",
                                                 @"Tuesday", 
                                                 @"Wednesday",                                                
                                                 @"Thursday",
                                                 @"Friday",
                                                 @"Saturday",
                                                 @"Sunday",
                            nil];
    self.dayNames = days;
    [days release];
    
    NSMutableArray *repeatDays = [[NSMutableArray alloc] initWithArray:[defaults arrayForKey:@"NewAlarmRepeatDays"]];
    
    self.alarmRepeatDays = repeatDays;
    [repeatDays release];

    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidUnload
{
    [_dayNames release];
    _dayNames = nil;
    [_alarmRepeatDays release];
    _alarmRepeatDays = nil;
    
    [tableViewAlarmRepeatDays release];
    tableViewAlarmRepeatDays = nil;
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
    [_dayNames release];
    [_alarmRepeatDays release];
    
    [tableViewAlarmRepeatDays release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

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
    
    cell.textLabel.text = [self.dayNames objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([self.alarmRepeatDays containsObject:[self.dayNames objectAtIndex:indexPath.row]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.alarmRepeatDays containsObject:[self.dayNames objectAtIndex:indexPath.row]])
    {
        [self.alarmRepeatDays removeObject:[self.dayNames objectAtIndex:indexPath.row]];
    }
    else
    {
        [self.alarmRepeatDays addObject:[self.dayNames objectAtIndex:indexPath.row]];
    }
    
    [tableViewAlarmRepeatDays reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:self.alarmRepeatDays forKey:@"NewAlarmRepeatDays"];
    
    [super viewWillDisappear:YES];
}

@end
