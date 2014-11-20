//
//  SetAlarmMelodyViewController.h
//  iAlarmClock
//
//  Created by Mac on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SetAlarmMelodyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate >
{
    IBOutlet UITableView *tableViewAlarmMelody;
}

@property (nonatomic, retain) NSMutableArray *melodyNames;
@property (nonatomic, retain) AVAudioPlayer *player;

@end
