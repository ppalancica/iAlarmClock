//
//  SettingsViewController.h
//  NavigationBasedTemplate
//
//  Created by Mac on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tableViewSettings;
}

@property (nonatomic, retain) NSMutableArray *alarmsData;

@end
