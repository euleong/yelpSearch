//
//  FiltersViewController.h
//  yelpSearch
//
//  Created by Eugenia Leong on 3/22/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToggleSwitchCell.h"

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>
@optional
- (void)addItemViewController:(FiltersViewController *)controller setCategory:(NSString *)category;
- (void)addItemViewController:(FiltersViewController *)controller setSwitches:(NSDictionary *)switches;
- (void)addItemViewController:(FiltersViewController *)controller setDistance:(NSString *)distance;
- (void)addItemViewController:(FiltersViewController *)controller setSortBy:(NSInteger)sortBy;
- (void)setDeal:(BOOL)value;
@end

@interface FiltersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ToggleSwitchCellDelegate>
@property (nonatomic, weak) id <FiltersViewControllerDelegate> delegate;
@end

