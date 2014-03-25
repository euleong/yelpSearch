//
//  ToggleSwitchCell.m
//  yelpSearch
//
//  Created by Eugenia Leong on 3/23/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "ToggleSwitchCell.h"

@interface ToggleSwitchCell()
-(void)didChangeValue:(id)sender;
@end

@implementation ToggleSwitchCell

- (void)awakeFromNib
{
    // Initialization code
    self.toggleSwitch.onTintColor = [UIColor colorWithRed:250/255.0 green:84/255.0 blue:0/255.0 alpha:1];
    //self.toggleSwitch.on = NO;
    
    [self.toggleSwitch addTarget:self action:@selector(didChangeValueForKey:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)didChangeValue:(id)sender
{
    [self.delegate sender:self.toggleSwitch didChangeValue:self.toggleSwitch.on];
}

@end
