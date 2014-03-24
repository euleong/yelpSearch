//
//  ToggleSwitchCell.m
//  yelpSearch
//
//  Created by Eugenia Leong on 3/23/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "ToggleSwitchCell.h"

@implementation ToggleSwitchCell

- (void)awakeFromNib
{
    // Initialization code
    self.toggleSwitch.onTintColor = [UIColor colorWithRed:250/255.0 green:84/255.0 blue:0/255.0 alpha:1];
    self.toggleSwitch.on = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
