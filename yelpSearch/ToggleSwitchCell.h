//
//  ToggleSwitchCell.h
//  yelpSearch
//
//  Created by Eugenia Leong on 3/23/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToggleSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;

@property (weak, nonatomic) IBOutlet UILabel *switchName;

@end
