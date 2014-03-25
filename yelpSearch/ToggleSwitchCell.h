//
//  ToggleSwitchCell.h
//  yelpSearch
//
//  Created by Eugenia Leong on 3/23/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToggleSwitchCell;

@protocol ToggleSwitchCellDelegate <NSObject>
@optional
- (void)sender:(ToggleSwitchCell *)sender didChangeValue:(BOOL)value;
@end

@interface ToggleSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;
@property (weak, nonatomic) IBOutlet UILabel *switchName;
@property (weak, nonatomic) id<ToggleSwitchCellDelegate> delegate;

@end
