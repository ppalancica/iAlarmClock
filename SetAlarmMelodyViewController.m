//
//  SetAlarmMelodyViewController.m
//  iAlarmClock
//
//  Created by Mac on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetAlarmMelodyViewController.h"
#import "CustomCellBackground.h"
#import "Utilities.h"

@interface SetAlarmMelodyViewController()
- (void)playNewMelody;
@end

@implementation SetAlarmMelodyViewController

@synthesize melodyNames = _melodyNames;
@synthesize player = _player;

// Private methods start

- (void)playNewMelody
{
    if ([self.player isPlaying])
    {
        [self.player stop];
        self.player = nil;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];   
    NSString *melodyName = [defaults stringForKey:@"NewAlarmMelody"];
    NSString *path = [[NSBundle mainBundle] pathForResource:melodyName ofType:@"mp3"];
    
    self.player = [[AVAudioPlayer alloc] 
                   initWithContentsOfURL:[NSURL fileURLWithPath:path]
                   error:nil];
    
    self.player.numberOfLoops = -1;
    self.player.volume = [defaults floatForKey:@"NewAlarmVolume"];
    self.player.delegate = self;
    
    [self.player prepareToPlay];
    [self.player play];
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
    self.title = @"Melody";
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *names = [[NSMutableArray alloc] 
                                initWithObjects:@"Ascending",
                                                @"Bells", 
                                                @"Best DJ",                                                
                                                @"Birds",
                                                @"Cool Reggae",
                                                @"Dance",
                                                @"Disco",
                                                @"Electronica",
                                                @"Fast Digital",
                                                @"Guitar",
                                                @"House",
                                                @"Love",
                                                @"Manele",
                                                @"Nostalgic",
                                                @"Oriental",
                                                @"Romantic",
                                                @"Royal",
                                                @"Spanish Guitar",
                                                @"Sufiana Flute",
                                                @"Twinkle",
                                nil];
    self.melodyNames = names;
    [names release];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *melodyName = [defaults stringForKey:@"NewAlarmMelody"];
    NSInteger index = [self.melodyNames indexOfObject:melodyName];
    
    [tableViewAlarmMelody scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]  
                                atScrollPosition:UITableViewScrollPositionNone 
                                        animated:YES];
    
    [self playNewMelody];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    if ([self.player isPlaying])
    {
        [self.player stop];
        self.player = nil;
    }
}

- (void)viewDidUnload
{
    NSLog(@"aha");
    [_player release];
    _player = nil;
    
    [_melodyNames release];
    _melodyNames = nil;
    [tableViewAlarmMelody release];
    tableViewAlarmMelody = nil;
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
    [_player release];
    
    [_melodyNames release];
    [tableViewAlarmMelody release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.melodyNames count];
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
    } 
    
    // Configure the cell.
    
    cell.textLabel.text = [self.melodyNames objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if ([self.melodyNames objectAtIndex:indexPath.row] == [defaults stringForKey:@"NewAlarmMelody"])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[self.melodyNames objectAtIndex:indexPath.row] forKey:@"NewAlarmMelody"];
    [defaults synchronize];
    [tableView reloadData];
    
    [self playNewMelody];
}

@end
