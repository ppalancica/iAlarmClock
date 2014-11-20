//
//  ThemeColorViewController.m
//  iAlarmClock
//
//  Created by Mac on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThemeColorViewController.h"
#import "Utilities.h"
#import "InterruptedLineView.h"

#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f \
        green:((rgbValue & 0xFF00) >> 8) / 255.0f \
        blue:(rgbValue & 0xFF) / 255.0f \
        alpha:1.0f]

@implementation ThemeColorViewController

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
    self.title = @"Theme Colors";
    
    colorsArray = [[NSArray alloc] initWithObjects:@"red", @"green", @"blue", @"cyan", @"yellow", @"magenta", @"orange", @"purple", @"chocolate" , nil];
    
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *themeColorName = [[NSUserDefaults standardUserDefaults] stringForKey:@"theme_color_name"];
    
    if ([themeColorName isEqualToString:@"red"])
    {
        currentThemeIndex = 0;
    }
    else if ([themeColorName isEqualToString:@"green"])
    {
        currentThemeIndex = 1;
    }
    else if ([themeColorName isEqualToString:@"blue"])
    {
        currentThemeIndex = 2;
    }
    else if ([themeColorName isEqualToString:@"cyan"])
    {
        currentThemeIndex = 3;
    }
    else if ([themeColorName isEqualToString:@"yellow"])
    {
        currentThemeIndex = 4;
    }
    else if ([themeColorName isEqualToString:@"magenta"])
    {
        currentThemeIndex = 5;
    }
    else if ([themeColorName isEqualToString:@"orange"])
    {
        currentThemeIndex = 6;
    }
    else if ([themeColorName isEqualToString:@"purple"])
    {
        currentThemeIndex = 7;
    }
    else if ([themeColorName isEqualToString:@"chocolate"])
    {
        currentThemeIndex = 8;
    }
    else
    {
        currentThemeIndex = 1;
    }
    
    imageViewTheme.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", (currentThemeIndex + 1)]];
    
    [super viewDidAppear:YES];
}

- (void)viewDidUnload
{
    [tableViewThemeColors release];
    tableViewThemeColors = nil;
    [imageViewTheme release];
    imageViewTheme = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [tableViewThemeColors release];
    [imageViewTheme release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)index
{   
    return 47;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"currentThemeIndex = %d", currentThemeIndex);
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        InterruptedLineView *ilv = [[InterruptedLineView alloc] initWithFrame:CGRectMake(10, 0, 300, 1)];
        ilv.tag = 1;
        [cell addSubview:ilv];
        [ilv release];
        
        UILabel *navigateRightArrow = [[UILabel alloc] initWithFrame:CGRectMake(290, 12, 24, 24)] ;
        navigateRightArrow.tag = 2;
        navigateRightArrow.backgroundColor = [UIColor clearColor];
        navigateRightArrow.textColor = [Utilities currentThemeColor];
        navigateRightArrow.text = @"<";
        navigateRightArrow.font = [UIFont fontWithName:@"DS-Digital-Bold" size:24];
        [cell addSubview:navigateRightArrow];
        
        cell.textLabel.textAlignment = UITextAlignmentLeft;
//        cell.textLabel.textColor = [Utilities currentThemeColor];
        cell.textLabel.font = [UIFont fontWithName:@"DS-Digital-Bold" size:24];
    }    
    
    cell.textLabel.alpha = 1.0f;
    
    [[cell viewWithTag:1] setNeedsDisplay];
    [cell viewWithTag:2].hidden = YES;

    if (indexPath.row < 9)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [colorsArray objectAtIndex:indexPath.row]];
        
        if (indexPath.row == currentThemeIndex)
        {
            ((UILabel *) [cell viewWithTag:2]).textColor = [Utilities currentThemeColor];
            [cell viewWithTag:2].hidden = NO;
            cell.textLabel.alpha = 0.3f;
        }
    }
    
    switch (indexPath.row)
    {    
        case 0:
            cell.textLabel.textColor = [UIColor redColor];
            break;
            
        case 1:
            cell.textLabel.textColor = [UIColor greenColor];
            break;
            
        case 2:
            cell.textLabel.textColor = [UIColor blueColor];
            break;
            
        case 3:
            cell.textLabel.textColor = [UIColor cyanColor];
            break;
            
        case 4:
            cell.textLabel.textColor = [UIColor yellowColor];
            break;
            
        case 5:
            cell.textLabel.textColor = [UIColor magentaColor];
            break;
            
        case 6:
            cell.textLabel.textColor = [UIColor orangeColor];
            break;
            
        case 7:
            cell.textLabel.textColor = [UIColor purpleColor];
            break;
            
        case 8:
            cell.textLabel.textColor = UIColorFromRGB(0xD2691E);
            break;
            
        default:
            break;
    }
        
    // Configure the cell.
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    
    if (indexPath.row != 9) 
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:[colorsArray objectAtIndex:indexPath.row] forKey:@"theme_color_name"];    
        [defaults synchronize];
        
        currentThemeIndex = indexPath.row;
        
        imageViewTheme.alpha = 1.0f;
        imageViewTheme.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", indexPath.row + 1]];
        
        [UIImageView beginAnimations:nil context:nil];
        [UIImageView setAnimationDuration:0.5];        
        imageViewTheme.alpha = 0.5f;
        [UIImageView commitAnimations];
        
        [tableView reloadData];
    }
}

@end
